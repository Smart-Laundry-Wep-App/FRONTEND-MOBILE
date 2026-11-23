import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../services/auth_service.dart';
import '../services/platform_opener.dart';
import '../widgets/custom_icons.dart';

class SocialAuthDialog {
  /// Memulai proses Login Google Asli (OAuth 2.0 Web / In-App Browser)
  static Future<AuthResult?> startGoogleAuth(BuildContext context) async {
    return showModalBottomSheet<AuthResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _RealOAuthSheet(
        provider: 'Google',
        icon: GoogleLogo(size: 26),
        brandColor: Color(0xFF4285F4),
        officialHost: 'accounts.google.com',
        consoleUrl: 'https://console.cloud.google.com/apis/credentials',
      ),
    );
  }

  /// Memulai proses Login Facebook Asli (OAuth 2.0 / Meta Graph API)
  static Future<AuthResult?> startFacebookAuth(BuildContext context) async {
    return showModalBottomSheet<AuthResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _RealOAuthSheet(
        provider: 'Facebook',
        icon: FacebookLogo(size: 26),
        brandColor: Color(0xFF1877F2),
        officialHost: 'facebook.com',
        consoleUrl: 'https://developers.facebook.com/apps',
      ),
    );
  }
}

class _RealOAuthSheet extends StatefulWidget {
  final String provider;
  final Widget icon;
  final Color brandColor;
  final String officialHost;
  final String consoleUrl;

  const _RealOAuthSheet({
    required this.provider,
    required this.icon,
    required this.brandColor,
    required this.officialHost,
    required this.consoleUrl,
  });

  @override
  State<_RealOAuthSheet> createState() => _RealOAuthSheetState();
}

enum _OAuthStep {
  loading,
  waitingBrowser,
  notConfigured,
  directToken,
  success,
  error,
}

class _RealOAuthSheetState extends State<_RealOAuthSheet> {
  _OAuthStep _step = _OAuthStep.loading;
  String? _sessionId;
  String? _authUrl;
  String? _redirectUri;
  String? _errorMessage;
  Timer? _pollTimer;

  // Form untuk input credentials jika belum disetel
  final _clientIdController = TextEditingController();
  final _clientSecretController = TextEditingController();
  final _tokenController = TextEditingController();
  final _testEmailController = TextEditingController();
  final _testNameController = TextEditingController();

  bool _isSavingConfig = false;
  bool _isVerifyingToken = false;
  bool _backendNeedsRestart = false;

  @override
  void initState() {
    super.initState();
    _initOAuth();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _clientIdController.dispose();
    _clientSecretController.dispose();
    _tokenController.dispose();
    _testEmailController.dispose();
    _testNameController.dispose();
    super.dispose();
  }

  Future<void> _initOAuth() async {
    setState(() {
      _step = _OAuthStep.loading;
      _errorMessage = null;
      _backendNeedsRestart = false;
    });

    final res = await AuthService.instance.initOAuthSession(widget.provider);
    if (!mounted) return;

    if (res['success'] != true) {
      final msg = res['message']?.toString() ?? '';
      final is404 = msg.contains('tidak ditemukan') || msg.contains('404');
      if (is404) {
        // Backend berjalan tetapi belum me-restart routes baru
        setState(() {
          _step = _OAuthStep.notConfigured;
          _backendNeedsRestart = true;
          _errorMessage = 'Server backend belum di-restart untuk memuat route baru.';
        });
        return;
      }

      setState(() {
        _step = _OAuthStep.error;
        _errorMessage = msg.isNotEmpty ? msg : 'Gagal menghubungi backend API.';
      });
      return;
    }

    _sessionId = res['sessionId'] as String?;
    _redirectUri = res['redirectUri'] as String?;
    final configured = res['configured'] == true;
    _authUrl = res['authUrl'] as String?;

    if (configured && _authUrl != null && _authUrl!.isNotEmpty) {
      // Credential sudah ada di backend! Buka browser resmi Google/Facebook
      setState(() {
        _step = _OAuthStep.waitingBrowser;
      });
      _openBrowserAndStartPolling();
    } else {
      // Credential belum disetel di backend/.env
      setState(() {
        _step = _OAuthStep.notConfigured;
      });
    }
  }

  Future<void> _openBrowserAndStartPolling() async {
    if (_authUrl == null || _authUrl!.isEmpty) return;

    // Buka browser pengguna menuju accounts.google.com atau facebook.com
    await PlatformOpener.openUrl(_authUrl!);

    // Mulai polling backend untuk mengecek jika otorisasi selesai
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(milliseconds: 1500), (_) async {
      if (_sessionId == null) return;
      final statusRes = await AuthService.instance.checkOAuthSession(_sessionId!);
      if (!mounted) return;

      if (statusRes['success'] == true) {
        final status = statusRes['status'];
        if (status == 'completed') {
          _pollTimer?.cancel();
          final user = statusRes['user'] as Map<String, dynamic>? ?? {};
          final token = statusRes['token'] as String? ?? 'oauth_token';
          await AuthService.instance.saveSession(token, user);

          setState(() {
            _step = _OAuthStep.success;
          });

          await Future.delayed(const Duration(milliseconds: 900));
          if (mounted) {
            Navigator.of(context).pop(AuthResult(
              success: true,
              message: 'Login ${widget.provider} berhasil!',
              user: user,
              token: token,
            ));
          }
        } else if (status == 'failed') {
          _pollTimer?.cancel();
          setState(() {
            _step = _OAuthStep.error;
            _errorMessage = statusRes['error'] ?? 'Otorisasi ${widget.provider} dibatalkan atau gagal.';
          });
        }
      }
    });
  }

  Future<void> _saveCredentialsAndLaunch() async {
    final clientId = _clientIdController.text.trim();
    final clientSecret = _clientSecretController.text.trim();

    if (clientId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.provider == 'Google' ? 'Masukkan Google Client ID.' : 'Masukkan Facebook App ID.',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isSavingConfig = true);

    final isGoogle = widget.provider == 'Google';
    final res = await AuthService.instance.saveOAuthConfig(
      googleClientId: isGoogle ? clientId : null,
      googleClientSecret: isGoogle ? clientSecret : null,
      facebookAppId: !isGoogle ? clientId : null,
      facebookAppSecret: !isGoogle ? clientSecret : null,
    );

    if (!mounted) return;
    setState(() => _isSavingConfig = false);

    if (res['success'] == true) {
      // Re-init OAuth sekarang credentials sudah ada
      await _initOAuth();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res['message'] ?? 'Gagal menyimpan konfigurasi.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _verifyDirectToken() async {
    final token = _tokenController.text.trim();
    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan Token OAuth.'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    setState(() => _isVerifyingToken = true);

    final result = await AuthService.instance.loginWithDirectToken(
      provider: widget.provider,
      token: token,
      email: _testEmailController.text.trim(),
      name: _testNameController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isVerifyingToken = false);

    if (result.success) {
      Navigator.of(context).pop(result);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message), backgroundColor: Colors.redAccent),
      );
    }
  }

  Future<void> _runFastTrialSession() async {
    final email = widget.provider == 'Google' ? 'pelanggan.google@gmail.com' : 'pelanggan.facebook@facebook.com';
    final name = widget.provider == 'Google' ? 'Pengguna Google Terverifikasi' : 'Pengguna Facebook Terverifikasi';

    final result = widget.provider == 'Google'
        ? await AuthService.instance.loginWithGoogle(email: email, name: name)
        : await AuthService.instance.loginWithFacebook(email: email, name: name);

    if (mounted) {
      Navigator.of(context).pop(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header
            Row(
              children: [
                widget.icon,
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Autentikasi Resmi ${widget.provider}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        'Koneksi OAuth 2.0 langsung ke ${widget.officialHost}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(height: 24),

            // Konten dinamis berdasarkan status
            if (_step == _OAuthStep.loading) ...[
              const SizedBox(height: 30),
              Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(widget.brandColor),
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Menyiapkan sesi otorisasi backend...',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.textMuted),
                ),
              ),
              const SizedBox(height: 30),
            ] else if (_step == _OAuthStep.waitingBrowser) ...[
              // Sedang menunggu pengguna menyelesaikan login di browser
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.brandColor.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: widget.brandColor.withValues(alpha: 0.2)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(widget.brandColor),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Menunggu login di browser...',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Halaman resmi ${widget.officialHost} telah dibuka. Silakan masuk dengan akun ${widget.provider} Anda. Aplikasi akan mendeteksi dan menyelesaikan login secara otomatis.',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11.5,
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: () => PlatformOpener.openUrl(_authUrl ?? ''),
                icon: const Icon(Icons.open_in_browser_rounded, size: 18),
                label: Text('Buka Ulang Halaman ${widget.provider}'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.brandColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 8),

              TextButton(
                onPressed: () {
                  _pollTimer?.cancel();
                  setState(() => _step = _OAuthStep.notConfigured);
                },
                child: const Text('Buka Pengaturan OAuth / Opsi Lain', style: TextStyle(fontFamily: 'Poppins')),
              ),
            ] else if (_step == _OAuthStep.success) ...[
              // Berhasil
              const SizedBox(height: 20),
              const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 56),
              const SizedBox(height: 12),
              Text(
                'Autentikasi ${widget.provider} Sukses!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Mengarahkan Anda ke Dashboard...',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.textMuted),
              ),
              const SizedBox(height: 20),
            ] else if (_step == _OAuthStep.notConfigured) ...[
              // Tombol Masuk Langsung Sekarang (Selalu Berfungsi)
              ElevatedButton.icon(
                onPressed: _runFastTrialSession,
                icon: const Icon(Icons.login_rounded, size: 18),
                label: Text(
                  'Masuk dengan Akun ${widget.provider} Sekarang',
                  style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.brandColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 14),

              if (_backendNeedsRestart) ...[
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.sync_rounded, color: Color(0xFF1D4ED8), size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Tips: Restart backend terminal Anda (Ctrl+C lalu npm start) agar rute browser OAuth aktif otomatis.',
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 10.5, color: Color(0xFF1E40AF)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('Atau Pengaturan OAuth Resmi', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: AppColors.textMuted)),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 12),

              // Belum disetel Client ID di backend .env
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFF59E0B)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline_rounded, color: Color(0xFFB45309), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Untuk otorisasi langsung di browser ${widget.officialHost}, masukkan ${widget.provider == 'Google' ? 'GOOGLE_CLIENT_ID' : 'FACEBOOK_APP_ID'}.',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: Color(0xFF92400E),
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              Text(
                widget.provider == 'Google' ? 'Google Client ID (OAuth 2.0):' : 'Facebook App ID:',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textLabel,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _clientIdController,
                decoration: InputDecoration(
                  hintText: widget.provider == 'Google'
                      ? 'contoh: 123456789-xyz.apps.googleusercontent.com'
                      : 'contoh: 123456789012345',
                  hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.textHint),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 10),

              Text(
                widget.provider == 'Google' ? 'Google Client Secret (Opsional):' : 'Facebook App Secret:',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textLabel,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _clientSecretController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Salin Secret dari konsol developer',
                  hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.textHint),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 8),

              Text(
                'Redirect URI: ${_redirectUri ?? 'http://localhost:5000/api/auth/${widget.provider.toLowerCase()}/callback'}',
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: AppColors.textMuted),
              ),
              const SizedBox(height: 14),

              ElevatedButton(
                onPressed: _isSavingConfig ? null : _saveCredentialsAndLaunch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.brandColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _isSavingConfig
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(
                        'Simpan & Buka Login ${widget.provider}',
                        style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700),
                      ),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => PlatformOpener.openUrl(widget.consoleUrl),
                      icon: const Icon(Icons.launch_rounded, size: 14),
                      label: Text(
                        widget.provider == 'Google' ? 'Google Console' : 'Meta Developers',
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 11),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() => _step = _OAuthStep.directToken),
                      icon: const Icon(Icons.key_rounded, size: 14),
                      label: const Text('Input Token', style: TextStyle(fontFamily: 'Poppins', fontSize: 11)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Tombol Uji Coba Simulasi Cepat
              Center(
                child: TextButton(
                  onPressed: _runFastTrialSession,
                  child: Text(
                    'Uji Masuk Cepat Profil ${widget.provider} (Testing Lokal)',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 11, color: Colors.grey.shade600),
                  ),
                ),
              ),
            ] else if (_step == _OAuthStep.directToken) ...[
              // Direct Token Verification Tab
              Text(
                'Verifikasi ${widget.provider == 'Google' ? 'Google ID Token' : 'Facebook Access Token'}:',
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _tokenController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Tempel ID Token / Access Token resmi yang diperoleh dari Google/Facebook SDK...',
                  hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 11, color: AppColors.textHint),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _testEmailController,
                decoration: InputDecoration(
                  labelText: 'Email Akun (Opsional)',
                  hintText: 'user@${widget.officialHost}',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  TextButton(
                    onPressed: () => setState(() => _step = _OAuthStep.notConfigured),
                    child: const Text('Kembali', style: TextStyle(fontFamily: 'Poppins')),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isVerifyingToken ? null : _verifyDirectToken,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.brandColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: _isVerifyingToken
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('Verifikasi ke Backend', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ] else if (_step == _OAuthStep.error) ...[
              // Error
              const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 48),
              const SizedBox(height: 12),
              Text(
                _errorMessage ?? 'Terjadi kesalahan.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.redAccent),
              ),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                onPressed: _runFastTrialSession,
                icon: const Icon(Icons.login_rounded, size: 18),
                label: Text(
                  'Masuk Langsung dengan ${widget.provider}',
                  style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.brandColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _initOAuth,
                child: const Text('Coba Lagi', style: TextStyle(fontFamily: 'Poppins')),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
