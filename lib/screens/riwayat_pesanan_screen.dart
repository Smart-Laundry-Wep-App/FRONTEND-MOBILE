import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/custom_icons.dart';
import 'dashboard_screen.dart';
import 'gps_tracking_screen.dart';
import 'info_layanan_screen.dart';
import 'jam_operasional_screen.dart';

class RiwayatOrderItem {
  final String orderId;
  final String serviceName;
  final String date;
  final String status; // 'Berlangsung' | 'Selesai'

  const RiwayatOrderItem({
    required this.orderId,
    required this.serviceName,
    required this.date,
    required this.status,
  });
}

class RiwayatPesananScreen extends StatefulWidget {
  const RiwayatPesananScreen({super.key});

  @override
  State<RiwayatPesananScreen> createState() => _RiwayatPesananScreenState();
}

class _RiwayatPesananScreenState extends State<RiwayatPesananScreen> {
  int _selectedFilterIndex = 0; // 0: Semua, 1: Berlangsung, 2: Selesai
  String _selectedMonth = 'Nov 2026';

  final List<String> _filters = const ['Semua', 'Berlangsung', 'Selesai'];

  final List<RiwayatOrderItem> _orders = const [
    RiwayatOrderItem(
      orderId: '#SL0126',
      serviceName: 'Cuci Kering - 3kg',
      date: '16 November 2026',
      status: 'Berlangsung',
    ),
    RiwayatOrderItem(
      orderId: '#SL0125',
      serviceName: 'Cuci Setrika - 2kg',
      date: '18 November 2026',
      status: 'Selesai',
    ),
    RiwayatOrderItem(
      orderId: '#SL0138',
      serviceName: 'Cuci Kering - 4kg',
      date: '20 November 2026',
      status: 'Selesai',
    ),
    RiwayatOrderItem(
      orderId: '#SL0139',
      serviceName: 'Cuci Setrika - 1kg',
      date: '22 November 2026',
      status: 'Selesai',
    ),
    RiwayatOrderItem(
      orderId: '#SL0211',
      serviceName: 'Cuci Express - 2kg',
      date: '26 November 2026',
      status: 'Selesai',
    ),
  ];

  List<RiwayatOrderItem> get _filteredOrders {
    if (_selectedFilterIndex == 1) {
      return _orders.where((o) => o.status == 'Berlangsung').toList();
    } else if (_selectedFilterIndex == 2) {
      return _orders.where((o) => o.status == 'Selesai').toList();
    }
    return _orders;
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

  void _onBottomNavTap(int index) {
    if (index == 0) return; // Already on Riwayat
    if (index == 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const InfoLayananScreen()),
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

  void _selectDateFilter() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final months = ['Nov 2026', 'Okt 2026', 'Sep 2026', 'Agt 2026'];
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Pilih Bulan',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                ...months.map((m) {
                  final isSelected = m == _selectedMonth;
                  return ListTile(
                    title: Text(
                      m,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? AppColors.primary : AppColors.textDark,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: AppColors.primary)
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedMonth = m;
                      });
                      Navigator.pop(ctx);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final scale = (screenWidth / 375).clamp(1.0, 1.25);
    final horizontalPadding = (screenWidth * 0.05).clamp(16.0, 24.0);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header: Back Button + Title
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 14.0,
              ),
              child: Row(
                children: [
                  CircleBackButton(onTap: _onKembali),
                  const SizedBox(width: 18),
                  Text(
                    'Riwayat Pesanan',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: (20.0 * scale).clamp(20.0, 23.0),
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: 0.3,
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
                    const SizedBox(height: 4),

                    // Filter Tabs: Semua | Berlangsung | Selesai
                    Row(
                      children: List.generate(_filters.length, (index) {
                        final isSelected = _selectedFilterIndex == index;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedFilterIndex = index;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(
                                horizontal: (20.0 * scale).clamp(18.0, 26.0),
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: AppColors.primary,
                                  width: 1.3,
                                ),
                              ),
                              child: Text(
                                _filters[index],
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: (12.0 * scale).clamp(12.0, 13.5),
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 18),

                    // Filter Tanggal Card
                    GestureDetector(
                      onTap: _selectDateFilter,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFF1F3F7),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Filter Tanggal',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _selectedMonth,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 24,
                              color: Color(0xFFCBD5E1),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Order Cards List
                    if (_filteredOrders.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Column(
                            children: const [
                              Icon(
                                Icons.inbox_outlined,
                                size: 48,
                                color: AppColors.textMuted,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Tidak ada pesanan pada kategori ini',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12.5,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ..._filteredOrders.map((order) {
                        return _buildOrderCard(order, scale);
                      }),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Bar
            AppBottomNavBar(
              currentIndex: 0, // Riwayat active
              isBeranda: false, // Shows Home icon in center
              onItemSelected: _onBottomNavTap,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(RiwayatOrderItem order, double scale) {
    final isBerlangsung = order.status == 'Berlangsung';

    return GestureDetector(
      onTap: () {
        if (isBerlangsung) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const GpsTrackingScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Detail pesanan ${order.orderId}'),
              duration: const Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFF1F3F7),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.orderId,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: (14.0 * scale).clamp(14.0, 16.0),
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    order.serviceName,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: (13.0 * scale).clamp(13.0, 15.0),
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    order.date,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: (11.5 * scale).clamp(11.5, 13.0),
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isBerlangsung ? 10 : 16,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: isBerlangsung ? Colors.white : const Color(0xFF4C9A2A),
                borderRadius: BorderRadius.circular(20),
                border: isBerlangsung
                    ? Border.all(color: AppColors.primary, width: 1.2)
                    : null,
              ),
              child: Text(
                order.status,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: isBerlangsung ? AppColors.primary : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

