import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'custom_icons.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemSelected;
  final bool? isBeranda;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
    this.isBeranda,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final scale = (screenWidth / 375).clamp(1.0, 1.25);
    final navHeight = (68.0 * scale).clamp(68.0, 78.0);
    final centerBtnSize = (44.0 * scale).clamp(44.0, 52.0);
    final showPlus = isBeranda ?? (currentIndex == 2);

    return Container(
      height: navHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(
            color: Color(0xFFF1F3F7),
            width: 1.2,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Nav 0: Riwayat
          _buildNavItem(
            index: 0,
            label: 'Riwayat',
            icon: HistoryPieIcon(
              size: (20.0 * scale).clamp(20.0, 24.0),
              color: currentIndex == 0 ? AppColors.primary : AppColors.textDark,
            ),
            fontSize: (10.0 * scale).clamp(10.0, 12.0),
          ),

          // Nav 1: Layanan
          _buildNavItem(
            index: 1,
            label: 'Layanan',
            icon: LayoutGridIcon(
              size: (20.0 * scale).clamp(20.0, 24.0),
              color: currentIndex == 1 ? AppColors.primary : AppColors.textDark,
            ),
            fontSize: (10.0 * scale).clamp(10.0, 12.0),
          ),

          // Nav 2: Center Floating Button (Plus on Beranda, Home icon on other pages)
          GestureDetector(
            onTap: () => onItemSelected(2),
            child: Container(
              width: centerBtnSize,
              height: centerBtnSize,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: showPlus
                    ? Icon(
                        Icons.add,
                        size: (26.0 * scale).clamp(26.0, 32.0),
                        color: AppColors.textDark,
                      )
                    : HomeBerandaIcon(
                        size: (20.0 * scale).clamp(20.0, 25.0),
                        color: AppColors.textDark,
                      ),
              ),
            ),
          ),

          // Nav 3: Jam Kerja
          _buildNavItem(
            index: 3,
            label: 'Jam Kerja',
            icon: ClockArrowIcon(
              size: (20.0 * scale).clamp(20.0, 24.0),
              color: currentIndex == 3 ? AppColors.primary : AppColors.textDark,
            ),
            fontSize: (10.0 * scale).clamp(10.0, 12.0),
          ),

          // Nav 4: Profile
          _buildNavItem(
            index: 4,
            label: 'Profile',
            icon: Icon(
              Icons.person_rounded,
              size: (22.0 * scale).clamp(22.0, 26.0),
              color: currentIndex == 4 ? AppColors.primary : AppColors.textDark,
            ),
            fontSize: (10.0 * scale).clamp(10.0, 12.0),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required Widget icon,
    double fontSize = 10,
  }) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onItemSelected(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: fontSize,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.primary : AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom Painter for the home beranda icon with the bottom horizontal slit cutout
class HomeBerandaPainter extends CustomPainter {
  final Color color;

  HomeBerandaPainter({this.color = AppColors.textDark});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Outer house silhouette (sharp pointed roof)
    final housePath = Path()
      ..moveTo(w * 0.5, h * 0.08) // Top apex of the roof
      ..lineTo(w * 0.92, h * 0.44) // Right roof eave
      ..lineTo(w * 0.92, h * 0.92) // Bottom right corner
      ..lineTo(w * 0.08, h * 0.92) // Bottom left corner
      ..lineTo(w * 0.08, h * 0.44) // Left roof eave
      ..close();

    // Horizontal doorway slit cutout at the lower center
    final slitPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.32, h * 0.70, w * 0.36, h * 0.09),
          const Radius.circular(1.2),
        ),
      );

    // Cut out the slit from the house silhouette
    final combined = Path.combine(
      PathOperation.difference,
      housePath,
      slitPath,
    );

    canvas.drawPath(combined, paint);
  }

  @override
  bool shouldRepaint(covariant HomeBerandaPainter oldDelegate) =>
      oldDelegate.color != color;
}

class HomeBerandaIcon extends StatelessWidget {
  final double size;
  final Color color;

  const HomeBerandaIcon({
    super.key,
    this.size = 22,
    this.color = AppColors.textDark,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: HomeBerandaPainter(color: color),
    );
  }
}

