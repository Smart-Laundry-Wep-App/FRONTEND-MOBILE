import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'custom_icons.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
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
              size: 20,
              color: currentIndex == 0 ? AppColors.primary : AppColors.textDark,
            ),
          ),

          // Nav 1: Layanan
          _buildNavItem(
            index: 1,
            label: 'Layanan',
            icon: LayoutGridIcon(
              size: 20,
              color: currentIndex == 1 ? AppColors.primary : AppColors.textDark,
            ),
          ),

          // Nav 2: Center Floating Button
          GestureDetector(
            onTap: () => onItemSelected(2),
            child: Container(
              width: 44,
              height: 44,
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
              child: const Center(
                child: Icon(
                  Icons.add,
                  size: 26,
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
              size: 20,
              color: currentIndex == 3 ? AppColors.primary : AppColors.textDark,
            ),
          ),

          // Nav 4: Profile
          _buildNavItem(
            index: 4,
            label: 'Profile',
            icon: Icon(
              Icons.person_rounded,
              size: 22,
              color: currentIndex == 4 ? AppColors.primary : AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required Widget icon,
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
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.primary : AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

