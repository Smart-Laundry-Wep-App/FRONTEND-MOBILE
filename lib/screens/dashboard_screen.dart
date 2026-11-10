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
    } else if (index == 3) {
      // 2. Jam Kerja ke Jam Operasional
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const JamOperasionalScreen()));
    } else if (index == 0) {
      _showActionFeedback('Riwayat');
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar / Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 14.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left: Logo + SCA Smart Laundry
                  Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: Image.asset(
                          'assets/images/logo_circle.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'SCA',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                              height: 1.1,
                            ),
                          ),
                          Text(
                            'Smart Laundry',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12.5,
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
                            children: const [
                              Text(
                                'Rendra',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark,
                                  height: 1.15,
                                ),
                              ),
                              Text(
                                'Customer',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 10.5,
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
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              size: 32,
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
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),

                    // Hero Banner Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 26.0,
                        horizontal: 16.0,
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
                          const Text(
                            'Layanan Laundry',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 22,
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
                              fontSize: 12.5,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.92),
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),

                    // 4 Quick Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildQuickActionItem(
                          label: 'Pesanan',
                          icon: const Icon(
                            Icons.shopping_cart_outlined,
                            color: AppColors.primary,
                            size: 26,
                          ),
                          onTap: _navigateToPesanan,
                        ),
                        // 3. Flow Promo -> Page Promo
                        _buildQuickActionItem(
                          label: 'Promo',
                          icon: const Icon(
                            Icons.percent_rounded,
                            color: AppColors.primary,
                            size: 26,
                          ),
                          onTap: _navigateToPromo,
                        ),
                        _buildQuickActionItem(
                          label: 'Tracking',
                          icon: const TrackingMapIcon(
                            size: 26,
                            color: AppColors.primary,
                          ),
                          onTap: _navigateToGpsTracking,
                        ),
                        _buildQuickActionItem(
                          label: 'Hubungi',
                          icon: const Icon(
                            Icons.help_outline_rounded,
                            color: AppColors.primary,
                            size: 26,
                          ),
                          onTap: _navigateToPusatBantuan,
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Section: Info Layanan
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Info Layanan',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                        GestureDetector(
                          onTap: _navigateToInfoLayanan,
                          child: const Text(
                            'Lihat Semua',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
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
                            iconWidget: const WashingMachineIcon(
                              size: 44,
                              color: AppColors.primary,
                            ),
                            onTap: _navigateToInfoLayanan,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildServiceCard(
                            title: 'Cuci Setrika',
                            iconWidget: const IronIcon(
                              size: 44,
                              color: AppColors.primary,
                            ),
                            onTap: _navigateToInfoLayanan,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildServiceCard(
                            title: 'Express',
                            iconWidget: const TshirtIcon(
                              size: 44,
                              color: AppColors.primary,
                            ),
                            onTap: _navigateToInfoLayanan,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Bar
            AppBottomNavBar(
              currentIndex: _currentNavIndex,
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
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 66,
            height: 66,
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
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
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
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
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
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11.5,
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
