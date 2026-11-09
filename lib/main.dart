import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants/colors.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/dashboard_screen.dart';

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
      home: const ScreenPreviewShell(),
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
  int _activeScreenIndex = 0; // 0: Login, 1: Register, 2: Dashboard

  final List<Widget> _screens = const [
    LoginScreen(),
    RegisterScreen(),
    DashboardScreen(),
  ];

  final List<String> _screenTitles = const [
    'Login',
    'Register',
    'Dashboard',
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Active Screen
        IndexedStack(
          index: _activeScreenIndex,
          children: _screens,
        ),

        // Floating Quick Switcher Pill (Top Right, unobtrusive)
        Positioned(
          top: 12,
          right: 12,
          child: SafeArea(
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.88),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
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
                          horizontal: 10,
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
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
