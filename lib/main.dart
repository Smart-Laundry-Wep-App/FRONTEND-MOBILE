import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants/colors.dart';
import 'screens/dashboard_screen.dart';
import 'screens/info_layanan_screen.dart';
import 'screens/jam_operasional_screen.dart';
import 'screens/login_screen.dart';
import 'screens/promo_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/register_screen.dart';
import 'screens/riwayat_pesanan_screen.dart';

import 'services/api_config.dart';
import 'services/auth_service.dart';
import 'services/language_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiConfig.init();
  await AuthService.instance.init();
  await LanguageService.instance.init();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const SCASmartLaundryApp());
}

class SCASmartLaundryApp extends StatelessWidget {
  const SCASmartLaundryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageService.instance,
      builder: (context, _) {
        return MaterialApp(
          title: 'SCA Smart Laundry',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Poppins',
            scaffoldBackgroundColor: AppColors.background,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              primary: AppColors.primary,
            ),
            useMaterial3: true,
          ),
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
              PointerDeviceKind.stylus,
              PointerDeviceKind.trackpad,
              PointerDeviceKind.unknown,
            },
          ),
          home: const ScreenPreviewShell(),
        );
      },
    );
  }
}

/// A shell wrapper that allows viewing each screen naturally,
/// while providing an elegant floating quick switcher for demonstration & testing.
class ScreenPreviewShell extends StatefulWidget {
  const ScreenPreviewShell({super.key});

  @override
  State<ScreenPreviewShell> createState() => _ScreenPreviewShellState();
}

class _ScreenPreviewShellState extends State<ScreenPreviewShell> {
  int _activeScreenIndex = 0;

  final List<Widget> _screens = const [
    LoginScreen(),
    RegisterScreen(),
    DashboardScreen(),
    InfoLayananScreen(),
    JamOperasionalScreen(),
    PromoScreen(),
    RiwayatPesananScreen(),
    ProfileScreen(),
  ];

  List<String> get _screenTitles => [
    LanguageService.tr('nav_login'),
    LanguageService.tr('nav_register'),
    LanguageService.tr('nav_dashboard'),
    LanguageService.tr('nav_services'),
    LanguageService.tr('nav_hours'),
    LanguageService.tr('nav_promo'),
    LanguageService.tr('nav_history'),
    LanguageService.tr('nav_profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Active Screen
        IndexedStack(index: _activeScreenIndex, children: _screens),

        // Floating Quick Switcher Pill (Top, discreet & convenient)
        Positioned(
          top: 10,
          right: 12,
          child: SafeArea(
            child: Material(
              color: Colors.transparent,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 320),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.90),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(_screenTitles.length, (index) {
                      final isSelected = _activeScreenIndex == index;
                      return InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          setState(() {
                            _activeScreenIndex = index;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            _screenTitles[index],
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.75),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
