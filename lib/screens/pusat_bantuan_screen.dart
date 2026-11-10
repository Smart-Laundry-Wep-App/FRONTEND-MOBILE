import 'package:flutter/material.dart';

import '../constants/colors.dart';

class PusatBantuanScreen extends StatelessWidget {
  const PusatBantuanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    customBorder: const CircleBorder(),
                    child: const CircleAvatar(
                      radius: 10,
                      backgroundColor: AppColors.primary,
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Pusat Bantuan',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),
            const SizedBox(height: 27),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23),
              child: Column(
                children: [
                  _HelpOption(
                    icon: Image.asset(
                      'assets/images/group_45.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                    title: 'CleanBOT Asisten 24/7',
                    subtitle: '(Disarankan)',
                  ),
                  const SizedBox(height: 7),
                  _HelpOption(
                    icon: const CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.primary,
                      child: Icon(
                        Icons.call_rounded,
                        color: Colors.white,
                        size: 70,
                      ),
                    ),
                    title: 'Hubungi admin',
                    subtitle: '(Slowrespon jika sibuk)',
                  ),
                ],
              ),
            ),
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.headset_mic_rounded,
                      color: AppColors.primary,
                      size: 68,
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Kami siap membantu\nanda 24 Jam',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        height: 1.15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HelpOption extends StatelessWidget {
  const _HelpOption({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final Widget icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  height: 1.15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 9,
                  height: 1.1,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
