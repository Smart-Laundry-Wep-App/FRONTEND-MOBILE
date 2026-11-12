import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../widgets/custom_icons.dart';
import 'dashboard_screen.dart';

class PromoItemData {
  final Widget icon;
  final String title;
  final String promoTitle;
  final String validity;

  const PromoItemData({
    required this.icon,
    required this.title,
    required this.promoTitle,
    required this.validity,
  });
}

class PromoScreen extends StatefulWidget {
  const PromoScreen({super.key});

  @override
  State<PromoScreen> createState() => _PromoScreenState();
}

class _PromoScreenState extends State<PromoScreen>
    with TickerProviderStateMixin {
  final _voucherController = TextEditingController();
  int _activeCarouselIndex = 0;
  String? _appliedPromoCode;
  bool _isSubmitting = false;
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  final List<PromoItemData> _otherPromos = const [
    PromoItemData(
      icon: Icon(
        Icons.confirmation_number_outlined,
        color: AppColors.primary,
        size: 22,
      ),
      title: 'Promo Kemerdekaan Indonesia.',
      promoTitle: 'Dirgahayu Indonesia',
      validity: '17-18 Agustus',
    ),
    PromoItemData(
      icon: Icon(
        Icons.local_shipping_outlined,
        color: AppColors.primary,
        size: 22,
      ),
      title: 'Gratis Ongkir Untuk Lokasi Tertentu.',
      promoTitle: 'Gratis Ongkir',
      validity: 'Syarat & Ketentuan Berlaku',
    ),
    PromoItemData(
      icon: Icon(Icons.percent_rounded, color: AppColors.primary, size: 22),
      title: 'Potongan 15% S&K Berlaku.',
      promoTitle: 'Diskon 15%',
      validity: 'Syarat & Ketentuan Berlaku',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -8), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8, end: 8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8, end: -6), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6, end: 4), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 4, end: 0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.easeInOut,
    ));
    _voucherController.addListener(_onVoucherChanged);
  }

  void _onVoucherChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _voucherController.removeListener(_onVoucherChanged);
    _voucherController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _onKembali() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    }
  }

  void _showFeedback(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _showPromoDetails({
    required String badge,
    required String title,
    required String validity,
  }) async {
    final claimed = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Tutup detail promo',
      barrierColor: const Color(0xB31C2438),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(10, 9, 9, 9),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.inputBorder, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          badge,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 22,
                          height: 1.05,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Berlaku S/D',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 9,
                                  color: AppColors.textMuted,
                                ),
                              ),
                              Text(
                                validity,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                          _PromoDialogButton(
                            label: 'Klaim Promo',
                            onPressed: () =>
                                Navigator.of(dialogContext).pop(true),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: curved, child: child),
        );
      },
    );

    if (claimed == true && mounted) {
      await _showClaimSuccess();
    }
  }

  Future<void> _applyPromoCode() async {
    if (_isSubmitting) return;

    final code = _voucherController.text.trim();
    if (code.isEmpty) {
      _shakeController.forward(from: 0.0);
      _showFeedback('Silahkan masukkan kode promo terlebih dahulu.');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _isSubmitting = true;
    });

    // Loading animation on "Kirim" button to simulate validation
    await Future.delayed(const Duration(milliseconds: 550));
    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    final used = await _showPromoSuccessDialog(promoCode: code);
    if (used == true && mounted) {
      setState(() {
        _appliedPromoCode = code;
      });
      _voucherController.clear();
      _showFeedback('Kode promo "$code" berhasil digunakan!');
    }
  }

  Future<bool?> _showPromoSuccessDialog({String? promoCode}) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Tutup konfirmasi promo',
      barrierColor: const Color(0xB31C2438),
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 300),
                margin: const EdgeInsets.symmetric(horizontal: 32),
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.16),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _AnimatedCheckmark(
                      size: 56,
                      color: Color(0xFF00E055),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Kode Promo\nbenar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        height: 1.25,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 26),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Pakai Promo',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: curved, child: child),
        );
      },
    );
  }

  Future<void> _showClaimSuccess() async {
    await _showPromoSuccessDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header: Back Button + Title + Ticket Icon
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 14.0,
              ),
              child: Row(
                children: [
                  CircleBackButton(onTap: _onKembali),
                  Expanded(
                    child: Center(
                      child: const Text(
                        'Promo',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                  const CouponTicketIcon(size: 24, color: AppColors.primary),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),

                    // Featured Promo Banner Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.inputBorder,
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.025),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Promo Badge: Promo Maba
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Promo Maba',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Discount Title
                          const Text(
                            'Diskon 20%',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 2),

                          // Target Audience
                          const Text(
                            'Untuk Mahasiswa Baru',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Validity & Claim Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Berlaku S/D',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                  Text(
                                    '1-31 Agustus',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () => _showPromoDetails(
                                  badge: 'Promo Maba',
                                  title: 'Diskon 20%',
                                  validity: '1-31 Agustus',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  minimumSize: const Size(0, 34),
                                ),
                                child: const Text(
                                  'Klaim Promo',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Carousel Indicator Dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final isSelected = _activeCarouselIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _activeCarouselIndex = index;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: isSelected ? 20 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.textDark
                                  : const Color(0xFFCBD5E1),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 18),

                    // Coupon Voucher Input Bar with shake animation
                    ListenableBuilder(
                      listenable: _shakeController,
                      builder: (context, _) {
                        return Transform.translate(
                          offset: Offset(
                            _shakeController.isAnimating
                                ? _shakeAnimation.value
                                : 0,
                            0,
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _shakeController.isAnimating
                                    ? Colors.red.shade300
                                    : _voucherController.text.trim().isNotEmpty
                                        ? AppColors.primary
                                        : AppColors.cardBorder,
                                width: _voucherController.text.trim().isNotEmpty
                                    ? 1.6
                                    : 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.account_balance_wallet_outlined,
                                  size: 20,
                                  color: AppColors.textMuted,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: _voucherController,
                                    textInputAction: TextInputAction.send,
                                    onSubmitted: (_) => _applyPromoCode(),
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 11.5,
                                      color: AppColors.textDark,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText:
                                          'Punya kode menarik? Masukan.....',
                                      hintStyle: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 11,
                                        color: AppColors.textHint,
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                                AnimatedSwitcher(
                                  duration:
                                      const Duration(milliseconds: 200),
                                  transitionBuilder: (child, animation) {
                                    return ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    );
                                  },
                                  child: _isSubmitting
                                      ? const SizedBox(
                                          key: ValueKey('loading'),
                                          width: 32,
                                          height: 32,
                                          child: Padding(
                                            padding: EdgeInsets.all(6),
                                            child:
                                                CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        )
                                      : ElevatedButton(
                                          key:
                                              const ValueKey('kirim'),
                                          onPressed: _applyPromoCode,
                                          style:
                                              ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.primary,
                                            foregroundColor:
                                                Colors.white,
                                            elevation: 0,
                                            padding:
                                                const EdgeInsets
                                                    .symmetric(
                                              horizontal: 16,
                                            ),
                                            shape:
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius
                                                      .circular(8),
                                            ),
                                            minimumSize:
                                                const Size(0, 32),
                                          ),
                                          child: const Text(
                                            'Kirim',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 11.5,
                                              fontWeight:
                                                  FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    if (_appliedPromoCode != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F9EE),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                const Color(0xFF00D632).withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              size: 14,
                              color: Color(0xFF00D632),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Kode "$_appliedPromoCode" aktif',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0F7638),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _appliedPromoCode = null;
                                });
                                _showFeedback('Kode promo dibatalkan.');
                              },
                              child: const Icon(
                                Icons.close_rounded,
                                size: 14,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),

                    // Section: Promo Lainnya
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Promo Lainnya',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                        Text(
                          '3 Tersedia',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // 3 Promo Cards List
                    ..._otherPromos.map((promo) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.cardBorder,
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14.0,
                            vertical: 11.0,
                          ),
                          child: Row(
                            children: [
                              promo.icon,
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  promo.title,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => _showPromoDetails(
                                  badge: promo.title.startsWith('Promo')
                                      ? 'Promo Kemerdekaan'
                                      : 'Promo Spesial',
                                  title: promo.promoTitle,
                                  validity: promo.validity,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  minimumSize: const Size(0, 28),
                                ),
                                child: const Text(
                                  'Check',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Bottom Fixed Button: + Pesan Laundry Sekarang
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: ElevatedButton(
                onPressed: () =>
                    _showFeedback('Membuka form pemesanan laundry...'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text(
                  '+ Pesan Laundry Sekarang',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PromoDialogButton extends StatelessWidget {
  const _PromoDialogButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 26,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _AnimatedCheckmark extends StatefulWidget {
  final double size;
  final Color color;

  const _AnimatedCheckmark({
    this.size = 56.0,
    this.color = const Color(0xFF00E055),
  });

  @override
  State<_AnimatedCheckmark> createState() => _AnimatedCheckmarkState();
}

class _AnimatedCheckmarkState extends State<_AnimatedCheckmark>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _circleProgress;
  late final Animation<double> _checkProgress;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _circleProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );

    _checkProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.38, 0.85, curve: Curves.easeInOut),
      ),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.3, end: 1.08)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.08, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
    ]).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: CustomPaint(
              painter: _CheckmarkPainter(
                circleProgress: _circleProgress.value,
                checkProgress: _checkProgress.value,
                color: widget.color,
                strokeWidth: 3.2,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CheckmarkPainter extends CustomPainter {
  final double circleProgress;
  final double checkProgress;
  final Color color;
  final double strokeWidth;

  _CheckmarkPainter({
    required this.circleProgress,
    required this.checkProgress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - (strokeWidth / 2);

    // Draw circular outline clockwise from top (-pi / 2)
    if (circleProgress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * circleProgress,
        false,
        paint,
      );
    }

    // Draw animated checkmark
    if (checkProgress > 0) {
      final p1 = Offset(size.width * 0.28, size.height * 0.52);
      final p2 = Offset(size.width * 0.44, size.height * 0.68);
      final p3 = Offset(size.width * 0.72, size.height * 0.38);

      const split = 0.355;
      if (checkProgress <= split) {
        final t = checkProgress / split;
        final current = Offset.lerp(p1, p2, t)!;
        canvas.drawLine(p1, current, paint);
      } else {
        canvas.drawLine(p1, p2, paint);
        final t = (checkProgress - split) / (1.0 - split);
        final current = Offset.lerp(p2, p3, t)!;
        canvas.drawLine(p2, current, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CheckmarkPainter oldDelegate) {
    return oldDelegate.circleProgress != circleProgress ||
        oldDelegate.checkProgress != checkProgress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
