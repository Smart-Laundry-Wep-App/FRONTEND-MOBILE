import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../services/api_service.dart';
import '../widgets/app_bottom_nav_bar.dart';
import 'dashboard_screen.dart';
import 'edit_profile_screen.dart';
import 'info_layanan_screen.dart';
import 'jam_operasional_screen.dart';
import 'language_selection_screen.dart';
import 'login_screen.dart';
import 'notification_settings_screen.dart';
import 'pesan_laundry_screen.dart';
import 'riwayat_pesanan_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'Narendra';
  String _username = 'narendraub';
  String _email = 'narendraub@gmail.com';
  String _phone = '+62 812 3366 2335';
  String _province = 'Jawa Timur';
  String _city = 'Kota Malang';
  String _address = 'Jl. Bareng menuju IPK 4, Malang, Jawa Timur';
  String _language = 'Indonesia (INA)';
  Map<String, bool> _notificationSettings = {};

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (!await ApiService.instance.hasSession) return;
    try {
      final profile = await ApiService.instance.fetchProfile();
      final notificationData = await ApiService.instance
          .fetchNotificationSettings();
      if (!mounted) return;
      setState(() {
        _name = profile['name'] as String? ?? _name;
        _username = profile['username'] as String? ?? _username;
        _email = profile['email'] as String? ?? _email;
        _phone = profile['phone'] as String? ?? _phone;
        _province = profile['province'] as String? ?? _province;
        _city = profile['city'] as String? ?? _city;
        _address = profile['address'] as String? ?? _address;
        _language =
            notificationData['language'] as String? ??
            profile['language'] as String? ??
            _language;
        _notificationSettings = Map<String, bool>.from(
          notificationData['notification_settings'] as Map? ?? const {},
        );
      });
    } on ApiException catch (error) {
      if (mounted) _showMessage(error.message);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _onBottomNavTap(int index) {
    if (index == 4) return;

    final Widget destination = switch (index) {
      0 => const RiwayatPesananScreen(),
      1 => const InfoLayananScreen(),
      2 => const DashboardScreen(),
      3 => const JamOperasionalScreen(),
      _ => const DashboardScreen(),
    };
    if (index < 0 || index > 3) return;

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute<void>(builder: (_) => destination));
  }

  void _goBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const DashboardScreen()),
      );
    }
  }

  Future<void> _editProfile() async {
    final profile = await Navigator.of(context).push<ProfileFormData>(
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(
          name: _name,
          username: _username,
          email: _email,
          phone: _phone,
          province: _province,
          city: _city,
          address: _address,
        ),
      ),
    );

    if (profile != null && mounted) {
      if (await ApiService.instance.hasSession) {
        try {
          await ApiService.instance.updateProfile({
            'name': profile.name,
            'username': profile.username,
            'email': profile.email,
            'phone': profile.phone,
            'province': profile.province,
            'city': profile.city,
            'address': profile.address,
          });
        } on ApiException catch (error) {
          if (mounted) _showMessage(error.message);
          return;
        }
      }
      if (!mounted) return;
      setState(() {
        _name = profile.name;
        _username = profile.username;
        _email = profile.email;
        _phone = profile.phone;
        _province = profile.province;
        _city = profile.city;
        _address = profile.address;
      });
    }
  }

  Future<void> _chooseLanguage() async {
    final language = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => LanguageSelectionScreen(selectedLanguage: _language),
      ),
    );

    if (language != null && mounted) {
      if (await ApiService.instance.hasSession) {
        try {
          await ApiService.instance.updateProfile({'language': language});
        } on ApiException catch (error) {
          if (mounted) _showMessage(error.message);
          return;
        }
      }
      if (!mounted) return;
      setState(() => _language = language);
    }
  }

  void _manageNotifications() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => NotificationSettingsScreen(
          initialSettings: Map<String, bool>.of(_notificationSettings),
          onSettingsChanged: _saveNotificationSettings,
        ),
      ),
    );
  }

  Future<void> _saveNotificationSettings(Map<String, bool> settings) async {
    if (await ApiService.instance.hasSession) {
      try {
        await ApiService.instance.saveNotificationSettings(settings);
      } on ApiException catch (error) {
        if (mounted) _showMessage(error.message);
        return;
      }
    }
    if (mounted) {
      setState(() => _notificationSettings = Map<String, bool>.of(settings));
    }
  }

  void _showLocationInfo() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(
          'Sesuaikan Lokasi',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Lokasi penjemputan dapat disesuaikan saat membuat pesanan laundry.',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const PesanLaundryScreen(),
                ),
              );
            },
            child: const Text('Buat Pesanan'),
          ),
        ],
      ),
    );
  }

  void _showAccountOptions() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(
          'Akun',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Masuk dengan akun lain atau tambahkan akun untuk melanjutkan.',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
              );
            },
            child: const Text('Tambah Akun'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(
          'Keluar Akun',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari akun?',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      await ApiService.instance.signOut();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 4),
              child: SizedBox(
                height: 44,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _goBack,
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.primary,
                      ),
                      tooltip: 'Kembali',
                    ),
                    const Expanded(
                      child: Text(
                        'Profil Pengguna',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
                child: Column(
                  children: [
                    _buildProfileHeader(),
                    const SizedBox(height: 12),
                    _buildMenuCard([
                      _ProfileMenuItem(
                        icon: Icons.badge_outlined,
                        label: 'Edit Profil dan Informasi',
                        onTap: _editProfile,
                      ),
                      _ProfileMenuItem(
                        icon: Icons.location_on_outlined,
                        label: 'Sesuaikan Lokasi',
                        onTap: _showLocationInfo,
                      ),
                      _ProfileMenuItem(
                        icon: Icons.translate_rounded,
                        label: 'Bahasa',
                        onTap: _chooseLanguage,
                        trailingLabel: _language == 'English (US)'
                            ? 'EN'
                            : null,
                      ),
                    ]),
                    const SizedBox(height: 10),
                    _buildMenuCard([
                      _ProfileMenuItem(
                        icon: Icons.notifications_none_rounded,
                        label: 'Kelola Notifikasi',
                        onTap: _manageNotifications,
                      ),
                      _ProfileMenuItem(
                        icon: Icons.history_rounded,
                        label: 'Riwayat Pesanan',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const RiwayatPesananScreen(),
                          ),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 10),
                    _buildMenuCard([
                      _ProfileMenuItem(
                        icon: Icons.person_add_alt_1_rounded,
                        label: 'Ganti Akun atau Tambah akun',
                        onTap: _showAccountOptions,
                      ),
                      _ProfileMenuItem(
                        icon: Icons.logout_rounded,
                        label: 'Keluar',
                        onTap: _confirmLogout,
                        isDestructive: true,
                      ),
                    ]),
                  ],
                ),
              ),
            ),
            AppBottomNavBar(
              currentIndex: 4,
              isBeranda: false,
              onItemSelected: _onBottomNavTap,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return SizedBox(
      height: 178,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 0,
            left: -18,
            right: -18,
            height: 104,
            child: CustomPaint(painter: _ProfileWavePainter()),
          ),
          Positioned(
            top: 15,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  key: const Key('profile-avatar'),
                  width: 82,
                  height: 82,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFE9EAF8),
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/profile_avatar.png',
                      width: 76,
                      height: 76,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  right: -1,
                  bottom: 1,
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: _editProfile,
                      customBorder: const CircleBorder(),
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(
                          Icons.edit_rounded,
                          size: 15,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 104,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  _name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 17,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _email,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 9.5,
                            color: AppColors.primary,
                          ),
                        ),
                        const Text(
                          ' | ',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 9.5,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          _phone,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 9.5,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(List<_ProfileMenuItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE7E8ED)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            _buildMenuRow(items[index]),
            if (index < items.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Divider(height: 1, color: Color(0xFFF0F1F4)),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildMenuRow(_ProfileMenuItem item) {
    final color = item.isDestructive
        ? const Color(0xFFE53935)
        : AppColors.primary;

    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 36,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Icon(item.icon, size: 16, color: color),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
              ),
              if (item.trailingLabel != null) ...[
                Text(
                  item.trailingLabel!,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 9,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: item.isDestructive ? color : AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileMenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;
  final String? trailingLabel;

  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
    this.trailingLabel,
  });
}

class _ProfileWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final band = Path()
      ..moveTo(0, 20)
      ..quadraticBezierTo(size.width * 0.5, 68, size.width, 16)
      ..lineTo(size.width, 31)
      ..quadraticBezierTo(size.width * 0.5, 79, 0, 36)
      ..close();

    canvas.drawPath(band, Paint()..color = const Color(0xFFC9C9EA));
  }

  @override
  bool shouldRepaint(covariant _ProfileWavePainter oldDelegate) => false;
}
