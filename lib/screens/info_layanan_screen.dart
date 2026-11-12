import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/custom_icons.dart';
import 'dashboard_screen.dart';
import 'jam_operasional_screen.dart';
import 'riwayat_pesanan_screen.dart';

class ServiceItemData {
  final String title;
  final String description;
  final Widget icon;

  const ServiceItemData({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class InfoLayananScreen extends StatefulWidget {
  const InfoLayananScreen({super.key});

  @override
  State<InfoLayananScreen> createState() => _InfoLayananScreenState();
}

class _InfoLayananScreenState extends State<InfoLayananScreen> {
  final List<ServiceItemData> _services = const [
    ServiceItemData(
      title: 'Cuci Kering',
      description: 'Pakaian bersih dan kering, siap digunakan.',
      icon: WashingMachineIcon(size: 28, color: AppColors.primary),
    ),
    ServiceItemData(
      title: 'Cuci Express',
      description: 'Laundry cepat untuk kebutuhan mendesak.',
      icon: WashingMachineIcon(size: 28, color: AppColors.primary),
    ),
    ServiceItemData(
      title: 'Cuci Selimut',
      description: 'Selimut bersih, lembut, dan nyaman.',
      icon: BlanketIcon(size: 28, color: AppColors.primary),
    ),
    ServiceItemData(
      title: 'Cuci Bed Cover',
      description: 'Perlengkapan tidur bersih dan segar.',
      icon: BedCoverIcon(size: 28, color: AppColors.primary),
    ),
    ServiceItemData(
      title: 'Cuci Boneka',
      description: 'Boneka bersih dan nyaman dipeluk.',
      icon: TeddyBearIcon(size: 28, color: AppColors.primary),
    ),
    ServiceItemData(
      title: 'Cuci Sepatu',
      description: 'Sepatu bersih dengan perawatan tepat.',
      icon: ShoeIcon(size: 28, color: AppColors.primary),
    ),
    ServiceItemData(
      title: 'Wenter Pakaian',
      description: 'Segarkan warna pakaian favoritmu.',
      icon: PantsIcon(size: 28, color: AppColors.primary),
    ),
  ];

  void _onBottomNavTap(int index) {
    if (index == 1) return; // Already on Layanan
    if (index == 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const RiwayatPesananScreen()),
      );
    } else if (index == 2) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else if (index == 3) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const JamOperasionalScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Menu index $index dipilih.'),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header: Back Button + Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
              child: Row(
                children: [
                  CircleBackButton(onTap: _onKembali),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 36.0),
                        child: const Text(
                          'Info Layanan',
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
                  ),
                ],
              ),
            ),

            // Services List
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                itemCount: _services.length + 1, // +1 for the Kembali button
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  if (index == _services.length) {
                    // Tombol Kembali
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                      child: ElevatedButton(
                        onPressed: _onKembali,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          minimumSize: const Size(double.infinity, 44),
                        ),
                        child: const Text(
                          'Kembali',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    );
                  }

                  final item = _services[index];
                  return Container(
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
                          blurRadius: 5,
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
                        // Left Icon
                        SizedBox(
                          width: 38,
                          height: 38,
                          child: Center(child: item.icon),
                        ),
                        const SizedBox(width: 12),

                        // Title & Subtitle
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                item.description,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Navigation Bar
            AppBottomNavBar(
              currentIndex: 1, // Layanan
              isBeranda: false,
              onItemSelected: _onBottomNavTap,
            ),
          ],
        ),
      ),
    );
  }
}

