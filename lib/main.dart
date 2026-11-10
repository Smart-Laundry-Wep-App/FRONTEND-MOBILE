import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants/colors.dart';
import 'screens/dashboard_screen.dart';
import 'screens/info_layanan_screen.dart';
import 'screens/jam_operasional_screen.dart';
import 'screens/login_screen.dart';
import 'screens/promo_screen.dart';
import 'screens/register_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
    return MaterialApp(
      title: 'SCA Smart Laundry - Mobile Simulator',
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
      home: const ScreenPreviewShell(),
    );
  }
}

/// A shell wrapper that provides:
/// 1. A realistic smartphone simulator frame for desktop/web browsing.
/// 2. An intuitive floating quick switcher for demonstration & testing.
class ScreenPreviewShell extends StatefulWidget {
  const ScreenPreviewShell({super.key});

  @override
  State<ScreenPreviewShell> createState() => _ScreenPreviewShellState();
}

class _ScreenPreviewShellState extends State<ScreenPreviewShell> {
  int _activeScreenIndex = 0; // 0: Login, 1: Register, 2: Dashboard, 3: Layanan, 4: Jam Kerja, 5: Promo
  bool _showMobileFrame = true;

  final List<Widget> _screens = const [
    LoginScreen(),
    RegisterScreen(),
    DashboardScreen(),
    InfoLayananScreen(),
    JamOperasionalScreen(),
    PromoScreen(),
  ];

  final List<String> _screenTitles = const [
    'Login',
    'Register',
    'Dashboard',
    'Layanan',
    'Jam Kerja',
    'Promo',
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isDesktopOrWeb = mediaQuery.size.width > 540;

    return Scaffold(
      backgroundColor: isDesktopOrWeb && _showMobileFrame
          ? const Color(0xFF0F172A) // Dark slate background for desktop simulator
          : AppColors.background,
      body: Stack(
        children: [
          // Content Area
          if (isDesktopOrWeb && _showMobileFrame)
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 24),
                width: 390,
                height: 844,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(44),
                  border: Border.all(
                    color: const Color(0xFF1E293B),
                    width: 10,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.50),
                      blurRadius: 36,
                      spreadRadius: 4,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(34),
                  child: Stack(
                    children: [
                      // Simulated Phone Status Bar
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 38,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '09:41',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark,
                                ),
                              ),
                              // Dynamic Island / Speaker Pill
                              Container(
                                width: 90,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              Row(
                                children: const [
                                  Icon(Icons.signal_cellular_alt, size: 14, color: AppColors.textDark),
                                  SizedBox(width: 4),
                                  Icon(Icons.wifi, size: 14, color: AppColors.textDark),
                                  SizedBox(width: 4),
                                  Icon(Icons.battery_full, size: 16, color: AppColors.textDark),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Screen Content inside Phone Frame
                      Positioned.fill(
                        top: 38,
                        child: IndexedStack(
                          index: _activeScreenIndex,
                          children: _screens,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            // Full Screen Mode (Mobile or Frame Disabled)
            IndexedStack(
              index: _activeScreenIndex,
              children: _screens,
            ),

          // Top Control Toolbar (Floating Quick Switcher & Frame Toggle)
          Positioned(
            top: 10,
            left: 12,
            right: 12,
            child: SafeArea(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 580),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B0F19).withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFF334155),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Frame Toggle Button (when desktop/web)
                        if (isDesktopOrWeb) ...[
                          InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () {
                              setState(() {
                                _showMobileFrame = !_showMobileFrame;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: _showMobileFrame
                                    ? const Color(0xFF3B82F6).withValues(alpha: 0.25)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: _showMobileFrame
                                      ? const Color(0xFF60A5FA)
                                      : Colors.transparent,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _showMobileFrame
                                        ? Icons.smartphone_rounded
                                        : Icons.fullscreen_rounded,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _showMobileFrame ? 'Simulator ON' : 'Full Screen',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 16,
                            width: 1,
                            color: const Color(0xFF475569),
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ],

                        // Screen Tabs
                        ...List.generate(_screenTitles.length, (index) {
                          final isSelected = _activeScreenIndex == index;
                          return InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () {
                              setState(() {
                                _activeScreenIndex = index;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                _screenTitles[index],
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 10.5,
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
