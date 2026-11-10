import 'package:flutter/material.dart';

import '../constants/colors.dart';

class GpsTrackingScreen extends StatelessWidget {
  const GpsTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 34, 20, 24),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    customBorder: const CircleBorder(),
                    child: const CircleAvatar(
                      radius: 19,
                      backgroundColor: AppColors.primary,
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'GPS Tracking',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 38),
                ],
              ),
              const SizedBox(height: 76),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pesanan #12345',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 22,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 7),
                        Text(
                          'Sedang dalam perjalanan',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),
                    const Text(
                      'Estimasi tiba\n15 Menit lagi',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        height: 1.35,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.account_circle_outlined,
                            size: 28,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'Samuela',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(
                              Icons.phone_in_talk_rounded,
                              color: AppColors.primary,
                              size: 21,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 44),
              AspectRatio(
                aspectRatio: 2.4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(painter: _TrackingMapPainter()),
                      ),
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        right: 0,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.primary,
                              width: 1.4,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        right: 0,
                        child: _MapMarkers(),
                      ),
                      Positioned(
                        right: 7,
                        bottom: 6,
                        child: Icon(
                          Icons.fullscreen_rounded,
                          size: 20,
                          color: Colors.black.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapMarkers extends StatelessWidget {
  const _MapMarkers();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        return Stack(
          children: [
            Positioned(
              left: width * 0.15,
              top: height * 0.15,
              child: const _LocationMarker(
                icon: Icons.storefront_rounded,
                color: Color(0xFF00A9D8),
              ),
            ),
            Positioned(
              left: width * 0.43,
              top: height * 0.45,
              child: const _LocationMarker(
                icon: Icons.delivery_dining_rounded,
                color: Color(0xFF0074C8),
                small: true,
              ),
            ),
            Positioned(
              left: width * 0.78,
              top: height * 0.70,
              child: const _LocationMarker(
                icon: Icons.home_rounded,
                color: Color(0xFF063A75),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LocationMarker extends StatelessWidget {
  const _LocationMarker({
    required this.icon,
    required this.color,
    this.small = false,
  });

  final IconData icon;
  final Color color;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final size = small ? 28.0 : 23.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Icon(icon, size: small ? 17 : 13, color: Colors.white),
    );
  }
}

class _TrackingMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()..color = const Color(0xFFE5F0FC);
    canvas.drawRect(Offset.zero & size, background);

    final streetPaint = Paint()
      ..color = const Color(0xFFF8FBFF)
      ..strokeWidth = 9
      ..style = PaintingStyle.stroke;
    final minorStreetPaint = Paint()
      ..color = const Color(0xFFD2E1F2)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    for (var i = -3; i < 12; i++) {
      final x = i * size.width / 7;
      final y = i * size.height / 5;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height * 0.45, size.height),
        streetPaint,
      );
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y + size.width * 0.12),
        streetPaint,
      );
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height * 0.45, size.height),
        minorStreetPaint,
      );
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y + size.width * 0.12),
        minorStreetPaint,
      );
    }

    final parkPaint = Paint()..color = const Color(0xFFB7E4D0);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.08, size.height * 0.57,
          size.width * 0.22, size.height * 0.31),
      parkPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.63, size.height * 0.05,
          size.width * 0.10, size.height * 0.22),
      parkPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.56, size.height * 0.51,
          size.width * 0.07, size.height * 0.12),
      parkPaint,
    );

    final river = Path()
      ..moveTo(size.width * 0.96, -size.height * 0.1)
      ..cubicTo(
        size.width * 0.80,
        size.height * 0.22,
        size.width * 1.08,
        size.height * 0.35,
        size.width * 0.90,
        size.height * 0.58,
      )
      ..cubicTo(
        size.width * 0.79,
        size.height * 0.76,
        size.width * 0.99,
        size.height * 0.85,
        size.width * 0.83,
        size.height * 1.1,
      );
    canvas.drawPath(
      river,
      Paint()
        ..color = const Color(0xFF86D8F3)
        ..strokeWidth = size.width * 0.075
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      river,
      Paint()
        ..color = const Color(0xFFF8FBFF)
        ..strokeWidth = size.width * 0.018
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    final route = Path()
      ..moveTo(size.width * 0.18, size.height * 0.34)
      ..lineTo(size.width * 0.42, size.height * 0.51)
      ..lineTo(size.width * 0.54, size.height * 0.55)
      ..lineTo(size.width * 0.67, size.height * 0.77)
      ..lineTo(size.width * 0.80, size.height * 0.77);
    canvas.drawPath(
      route,
      Paint()
        ..color = Colors.white
        ..strokeWidth = 5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawPath(
      route,
      Paint()
        ..color = const Color(0xFF08A9F2)
        ..strokeWidth = 2.6
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _TrackingMapPainter oldDelegate) => false;
}
