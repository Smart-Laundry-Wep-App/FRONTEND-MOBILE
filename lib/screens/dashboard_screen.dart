import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/custom_icons.dart';
import 'info_layanan_screen.dart';
import 'jam_operasional_screen.dart';
import 'login_screen.dart';
import 'gps_tracking_screen.dart';
import 'pusat_bantuan_screen.dart';
import 'pesan_laundry_screen.dart';
import 'promo_screen.dart';
import 'riwayat_pesanan_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final int _currentNavIndex = 2; // Center / Home Dashboard

  void _onNavTap(int index) {
    if (index == 1) {
      // 1. Toggle Layanan ke Info Layanan
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const InfoLayananScreen()));
    } else if (index == 2) {
      // Center + Button -> Langsung ke Pesan Laundry
      _navigateToPesanan();
    } else if (index == 3) {
      // 2. Jam Kerja ke Jam Operasional
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const JamOperasionalScreen()));
    } else if (index == 0) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const RiwayatPesananScreen()),
      );
    } else if (index == 4) {
      _showActionFeedback('Profile');
    }
  }

  void _navigateToPromo() {
    // 3. Promo ke Page Promo
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const PromoScreen()));
  }

  void _navigateToPesanan() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const PesanLaundryScreen()));
  }

  void _navigateToPusatBantuan() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const PusatBantuanScreen()));
  }

  void _navigateToGpsTracking() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const GpsTrackingScreen()));
  }

  void _navigateToInfoLayanan() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const InfoLayananScreen()));
  }

  void _showActionFeedback(String actionName) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Menu "$actionName" dipilih.'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Keluar Akun',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Apakah Anda ingin kembali ke halaman Login?',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(fontFamily: 'Poppins')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: const Text(
              'Keluar',
              style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final screenHeight = media.size.height;

    // Responsive scaling based on device width & height
    final scale = (screenWidth / 375).clamp(1.0, 1.25);
    final horizontalPadding = (screenWidth * 0.05).clamp(16.0, 24.0);

    // Responsive Quick Action sizes
    final quickActionBoxSize =
        ((screenWidth - (horizontalPadding * 2) - (3 * 12)) / 4)
            .clamp(66.0, 84.0);
    final quickActionIconSize = (26.0 * scale).clamp(26.0, 32.0);
    final quickActionFontSize = (11.0 * scale).clamp(11.0, 13.0);

    // Responsive Service Card sizes
    final serviceCardHeight = (screenWidth * 0.31).clamp(120.0, 150.0);
    final serviceIconSize = (44.0 * scale).clamp(44.0, 54.0);
    final serviceTitleSize = (11.5 * scale).clamp(11.5, 13.5);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar / Header
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 14.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left: Logo + SCA Smart Laundry
                  Row(
                    children: [
                      Container(
                        width: (34.0 * scale).clamp(34.0, 42.0),
                        height: (34.0 * scale).clamp(34.0, 42.0),
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: Image.asset(
                          'assets/images/logo_circle.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SCA',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: (12.5 * scale).clamp(12.5, 15.0),
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                              height: 1.1,
                            ),
                          ),
                          Text(
                            'Smart Laundry',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: (12.5 * scale).clamp(12.5, 15.0),
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Right: Rendra Customer + Profile Avatar
                  InkWell(
                    onTap: _onLogout,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Rendra',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: (12.5 * scale).clamp(12.5, 15.0),
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark,
                                  height: 1.15,
                                ),
                              ),
                              Text(
                                'Customer',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: (10.5 * scale).clamp(10.5, 12.5),
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textMuted,
                                  height: 1.15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          // User Avatar Silhouette
                          Container(
                            width: (32.0 * scale).clamp(32.0, 40.0),
                            height: (32.0 * scale).clamp(32.0, 40.0),
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person_rounded,
                              size: (32.0 * scale).clamp(32.0, 40.0),
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),

                    // Hero Banner Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: (screenHeight * 0.026).clamp(22.0, 34.0),
                        horizontal: 18.0,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.22),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Layanan Laundry',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: (22.0 * scale).clamp(22.0, 27.0),
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Bersih, Rapih, Tepat Waktu',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: (12.5 * scale).clamp(12.5, 15.0),
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.92),
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: (screenHeight * 0.022).clamp(18.0, 26.0)),

                    // 4 Quick Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildQuickActionItem(
                          label: 'Pesanan',
                          icon: Icon(
                            Icons.shopping_cart_outlined,
                            color: AppColors.primary,
                            size: quickActionIconSize,
                          ),
                          onTap: _navigateToPesanan,
                          boxSize: quickActionBoxSize,
                          fontSize: quickActionFontSize,
                        ),
                        // 3. Flow Promo -> Page Promo
                        _buildQuickActionItem(
                          label: 'Promo',
                          icon: Icon(
                            Icons.percent_rounded,
                            color: AppColors.primary,
                            size: quickActionIconSize,
                          ),
                          onTap: _navigateToPromo,
                          boxSize: quickActionBoxSize,
                          fontSize: quickActionFontSize,
                        ),
                        _buildQuickActionItem(
                          label: 'Tracking',
                          icon: TrackingMapIcon(
                            size: quickActionIconSize,
                            color: AppColors.primary,
                          ),
                          onTap: _navigateToGpsTracking,
                          boxSize: quickActionBoxSize,
                          fontSize: quickActionFontSize,
                        ),
                        _buildQuickActionItem(
                          label: 'Hubungi',
                          icon: Icon(
                            Icons.help_outline_rounded,
                            color: AppColors.primary,
                            size: quickActionIconSize,
                          ),
                          onTap: _navigateToPusatBantuan,
                          boxSize: quickActionBoxSize,
                          fontSize: quickActionFontSize,
                        ),
                      ],
                    ),
                    SizedBox(height: (screenHeight * 0.026).clamp(20.0, 30.0)),

                    // Section: Info Layanan
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Info Layanan',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: (16.0 * scale).clamp(16.0, 19.0),
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                        GestureDetector(
                          onTap: _navigateToInfoLayanan,
                          child: Text(
                            'Lihat Semua',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: (12.0 * scale).clamp(12.0, 14.0),
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // 3 Service Cards (Tapping also opens Info Layanan)
                    Row(
                      children: [
                        Expanded(
                          child: _buildServiceCard(
                            title: 'Cuci Kering',
                            iconWidget: WashingMachineIcon(
                              size: serviceIconSize,
                              color: AppColors.primary,
                            ),
                            onTap: _navigateToInfoLayanan,
                            cardHeight: serviceCardHeight,
                            fontSize: serviceTitleSize,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildServiceCard(
                            title: 'Cuci Setrika',
                            iconWidget: IronIcon(
                              size: serviceIconSize,
                              color: AppColors.primary,
                            ),
                            onTap: _navigateToInfoLayanan,
                            cardHeight: serviceCardHeight,
                            fontSize: serviceTitleSize,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildServiceCard(
                            title: 'Express',
                            iconWidget: TshirtIcon(
                              size: serviceIconSize,
                              color: AppColors.primary,
                            ),
                            onTap: _navigateToInfoLayanan,
                            cardHeight: serviceCardHeight,
                            fontSize: serviceTitleSize,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: (screenHeight * 0.024).clamp(18.0, 26.0)),

                    // Section: Pesanan Aktif / Status Terkini
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pesanan Aktif',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: (16.0 * scale).clamp(16.0, 19.0),
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                        GestureDetector(
                          onTap: _navigateToGpsTracking,
                          child: Text(
                            'Lacak Status',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: (12.0 * scale).clamp(12.0, 14.0),
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _navigateToGpsTracking,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(
                          (14.0 * scale).clamp(14.0, 18.0),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.cardBorder,
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: (48.0 * scale).clamp(48.0, 56.0),
                              height: (48.0 * scale).clamp(48.0, 56.0),
                              decoration: BoxDecoration(
                                color: AppColors.inputFill,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.local_laundry_service_rounded,
                                  color: AppColors.primary,
                                  size: 26,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Order #SCA-2841',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize:
                                              (12.0 * scale).clamp(12.0, 14.0),
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textDark,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE8F9EE),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: const Text(
                                          'Sedang Dicuci',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF0F7638),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Cuci Komplit • 3.5 Kg • Estimasi 16.00 WIB',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize:
                                          (10.5 * scale).clamp(10.5, 12.0),
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: AppColors.textMuted,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: (screenHeight * 0.024).clamp(18.0, 26.0)),

                    // Section: Promo Menarik Banner
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Promo Menarik',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: (16.0 * scale).clamp(16.0, 19.0),
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                        GestureDetector(
                          onTap: _navigateToPromo,
                          child: Text(
                            'Lihat Promo',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: (12.0 * scale).clamp(12.0, 14.0),
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _navigateToPromo,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(
                          (16.0 * scale).clamp(16.0, 20.0),
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1B22A7), Color(0xFF333CBF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.22),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'Promo Spesial',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Diskon 20% Mahasiswa Baru',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize:
                                          (15.0 * scale).clamp(15.0, 18.0),
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Gunakan kode promo HEMAT20 sekarang!',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize:
                                          (11.0 * scale).clamp(11.0, 13.0),
                                      color: Colors.white
                                          .withValues(alpha: 0.88),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Klaim',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Bar
            AppBottomNavBar(
              currentIndex: _currentNavIndex,
              isBeranda: true,
              onItemSelected: _onNavTap,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem({
    required String label,
    required Widget icon,
    required VoidCallback onTap,
    double boxSize = 66,
    double fontSize = 11,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: boxSize,
            height: boxSize,
            decoration: BoxDecoration(
              color: AppColors.actionCardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cardBorder, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(child: icon),
          ),
          const SizedBox(height: 7),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard({
    required String title,
    required Widget iconWidget,
    required VoidCallback onTap,
    double cardHeight = 120,
    double fontSize = 11.5,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: cardHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.025),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            SizedBox(height: cardHeight * 0.1),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
