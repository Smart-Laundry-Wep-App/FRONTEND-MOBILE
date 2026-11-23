import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/colors.dart';
import '../services/api_service.dart';
import 'chatbot_screen.dart';

class PusatBantuanScreen extends StatefulWidget {
  const PusatBantuanScreen({super.key});

  @override
  State<PusatBantuanScreen> createState() => _PusatBantuanScreenState();
}

class _PusatBantuanScreenState extends State<PusatBantuanScreen> {
  Map<String, dynamic> _helpCenter = const {};

  @override
  void initState() {
    super.initState();
    _loadHelpCenter();
  }

  Future<void> _loadHelpCenter() async {
    try {
      final result = await ApiService.instance.fetchHelpCenter();
      if (mounted) setState(() => _helpCenter = result);
    } on ApiException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      }
    }
  }

  Future<void> _contactAdmin() async {
    final link = _helpCenter['admin']?['whatsapp'] as String?;
    if (link == null || link.isEmpty) return;
    final launched = await launchUrl(
      Uri.parse(link),
      mode: LaunchMode.externalApplication,
    );
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('WhatsApp tidak dapat dibuka.')),
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
                    title: _helpCenter['bot']?['name'] as String? ??
                        'CleanBOT Asisten 24/7',
                    subtitle: _helpCenter['bot']?['badge'] as String? ??
                        '(Disarankan)',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ChatBotScreen(),
                        ),
                      );
                    },
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
                    title: _helpCenter['admin']?['name'] as String? ??
                        'Hubungi admin',
                    subtitle: _helpCenter['admin']?['note'] as String? ??
                        '(Slowrespon jika sibuk)',
                    onTap: _contactAdmin,
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
    this.onTap,
  });

  final Widget icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
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
        ),
      ),
    );
  }
}
