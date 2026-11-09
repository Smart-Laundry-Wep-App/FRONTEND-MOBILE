import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/colors.dart';

/// Custom Painter for Washing Machine (Cuci Kering)
class WashingMachinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  WashingMachinePainter({
    this.color = AppColors.primary,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Outer machine body with rounded corners
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.08, h * 0.06, w * 0.84, h * 0.88),
      const Radius.circular(8),
    );
    canvas.drawRRect(rrect, paint);

    // Top control panel separator line
    canvas.drawLine(
      Offset(w * 0.08, h * 0.28),
      Offset(w * 0.92, h * 0.28),
      paint,
    );

    // Knob on top right
    canvas.drawCircle(
      Offset(w * 0.78, h * 0.17),
      w * 0.045,
      paint,
    );
    // Optional indicator dot inside knob
    canvas.drawCircle(
      Offset(w * 0.78, h * 0.17),
      w * 0.015,
      fillPaint,
    );

    // Optional small button on the left of knob
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.20, h * 0.14, w * 0.18, h * 0.06),
        const Radius.circular(2),
      ),
      paint,
    );

    // Center circular drum
    final drumCenter = Offset(w * 0.5, h * 0.62);
    final drumRadius = w * 0.25;
    canvas.drawCircle(drumCenter, drumRadius, paint);

    // Drum inner wave / swirl detail
    final innerPath = Path();
    innerPath.addArc(
      Rect.fromCircle(center: drumCenter, radius: drumRadius * 0.65),
      math.pi * 0.2,
      math.pi * 1.2,
    );
    canvas.drawPath(innerPath, paint);
  }

  @override
  bool shouldRepaint(covariant WashingMachinePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

class WashingMachineIcon extends StatelessWidget {
  final double size;
  final Color color;

  const WashingMachineIcon({
    super.key,
    this.size = 36,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: WashingMachinePainter(color: color),
    );
  }
}

/// Custom Painter for Iron (Cuci Setrika)
class IronPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  IronPainter({
    this.color = AppColors.primary,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    // Iron sole plate (bottom base line)
    canvas.drawLine(
      Offset(w * 0.08, h * 0.88),
      Offset(w * 0.92, h * 0.88),
      paint,
    );

    // Iron body
    final bodyPath = Path();
    // Start at bottom back
    bodyPath.moveTo(w * 0.88, h * 0.82);
    // Up along rear
    bodyPath.lineTo(w * 0.88, h * 0.54);
    // Curve or slope towards front handle base
    bodyPath.lineTo(w * 0.38, h * 0.54);
    // Slanted nose down to the front tip
    bodyPath.lineTo(w * 0.12, h * 0.82);
    // Base of body
    bodyPath.close();
    canvas.drawPath(bodyPath, paint);

    // Handle on top
    final handlePath = Path();
    handlePath.moveTo(w * 0.82, h * 0.54);
    handlePath.lineTo(w * 0.82, h * 0.22);
    handlePath.lineTo(w * 0.28, h * 0.22);
    handlePath.lineTo(w * 0.28, h * 0.38);
    canvas.drawPath(handlePath, paint);

    // Steam vents / lines in body
    canvas.drawLine(
      Offset(w * 0.44, h * 0.63),
      Offset(w * 0.44, h * 0.74),
      paint,
    );
    canvas.drawLine(
      Offset(w * 0.56, h * 0.63),
      Offset(w * 0.56, h * 0.74),
      paint,
    );
    canvas.drawLine(
      Offset(w * 0.68, h * 0.63),
      Offset(w * 0.68, h * 0.74),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant IronPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

class IronIcon extends StatelessWidget {
  final double size;
  final Color color;

  const IronIcon({
    super.key,
    this.size = 36,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: IronPainter(color: color),
    );
  }
}

/// Custom Painter for T-shirt (Express)
class TshirtPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  TshirtPainter({
    this.color = AppColors.primary,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    final path = Path();
    // Neck collar center
    path.moveTo(w * 0.36, h * 0.12);
    // Collar dip
    path.quadraticBezierTo(w * 0.50, h * 0.24, w * 0.64, h * 0.12);
    // Right shoulder
    path.lineTo(w * 0.86, h * 0.22);
    // Right sleeve outer edge
    path.lineTo(w * 0.95, h * 0.42);
    // Right sleeve bottom
    path.lineTo(w * 0.80, h * 0.50);
    // Right armpit
    path.lineTo(w * 0.76, h * 0.42);
    // Right body side down
    path.lineTo(w * 0.76, h * 0.90);
    // Bottom hem
    path.lineTo(w * 0.24, h * 0.90);
    // Left body side up
    path.lineTo(w * 0.24, h * 0.42);
    // Left armpit
    path.lineTo(w * 0.20, h * 0.50);
    // Left sleeve bottom
    path.lineTo(w * 0.05, h * 0.42);
    // Left sleeve outer edge
    path.lineTo(w * 0.14, h * 0.22);
    // Left shoulder to neck
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant TshirtPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

class TshirtIcon extends StatelessWidget {
  final double size;
  final Color color;

  const TshirtIcon({
    super.key,
    this.size = 36,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: TshirtPainter(color: color),
    );
  }
}

/// Custom Painter for Tracking (Folded Map with +)
class TrackingMapPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  TrackingMapPainter({
    this.color = AppColors.primary,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    // 3 panels folded map
    final p1 = Offset(w * 0.10, h * 0.25);
    final p2 = Offset(w * 0.38, h * 0.12);
    final p3 = Offset(w * 0.66, h * 0.25);
    final p4 = Offset(w * 0.88, h * 0.15);

    final b1 = Offset(w * 0.10, h * 0.85);
    final b2 = Offset(w * 0.38, h * 0.72);
    final b3 = Offset(w * 0.66, h * 0.85);
    final b4 = Offset(w * 0.88, h * 0.75);

    // Map outline
    final path = Path();
    path.moveTo(p1.dx, p1.dy);
    path.lineTo(p2.dx, p2.dy);
    path.lineTo(p3.dx, p3.dy);
    path.lineTo(p4.dx, p4.dy);
    path.lineTo(b4.dx, b4.dy);
    path.lineTo(b3.dx, b3.dy);
    path.lineTo(b2.dx, b2.dy);
    path.lineTo(b1.dx, b1.dy);
    path.close();
    canvas.drawPath(path, paint);

    // Vertical fold lines
    canvas.drawLine(p2, b2, paint);
    canvas.drawLine(p3, b3, paint);

    // Small plus badge on top-right panel
    final plusCenter = Offset(w * 0.84, h * 0.40);
    final plusSize = w * 0.10;
    canvas.drawLine(
      Offset(plusCenter.dx - plusSize, plusCenter.dy),
      Offset(plusCenter.dx + plusSize, plusCenter.dy),
      paint,
    );
    canvas.drawLine(
      Offset(plusCenter.dx, plusCenter.dy - plusSize),
      Offset(plusCenter.dx, plusCenter.dy + plusSize),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant TrackingMapPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

class TrackingMapIcon extends StatelessWidget {
  final double size;
  final Color color;

  const TrackingMapIcon({
    super.key,
    this.size = 28,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: TrackingMapPainter(color: color),
    );
  }
}

/// Custom Painter for Riwayat (Pie Chart / Clock slice)
class HistoryPiePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  HistoryPiePainter({
    this.color = AppColors.textDark,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.42;

    // Draw full outer circle
    canvas.drawCircle(center, radius, linePaint);

    // Draw filled sector (top right quadrant / pie slice)
    final piePath = Path();
    piePath.moveTo(center.dx, center.dy);
    piePath.arcTo(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi / 2,
      false,
    );
    piePath.close();
    canvas.drawPath(piePath, paint);
  }

  @override
  bool shouldRepaint(covariant HistoryPiePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

class HistoryPieIcon extends StatelessWidget {
  final double size;
  final Color color;

  const HistoryPieIcon({
    super.key,
    this.size = 22,
    this.color = AppColors.textDark,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: HistoryPiePainter(color: color),
    );
  }
}

/// Custom Painter for Layanan (Browser / Window / Grid Icon)
class LayoutGridPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  LayoutGridPainter({
    this.color = AppColors.textDark,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    // Outer window rectangle
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.10, h * 0.12, w * 0.80, h * 0.76),
      const Radius.circular(4),
    );
    canvas.drawRRect(rrect, paint);

    // Top window bar
    canvas.drawLine(
      Offset(w * 0.10, h * 0.36),
      Offset(w * 0.90, h * 0.36),
      paint,
    );

    // Inner content panel: vertical split or small sub-box
    canvas.drawLine(
      Offset(w * 0.48, h * 0.36),
      Offset(w * 0.48, h * 0.88),
      paint,
    );

    // Left content line
    canvas.drawLine(
      Offset(w * 0.22, h * 0.58),
      Offset(w * 0.36, h * 0.58),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant LayoutGridPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

class LayoutGridIcon extends StatelessWidget {
  final double size;
  final Color color;

  const LayoutGridIcon({
    super.key,
    this.size = 22,
    this.color = AppColors.textDark,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: LayoutGridPainter(color: color),
    );
  }
}

/// Custom Painter for Jam Kerja (Clock with Circular Arrow)
class ClockArrowPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  ClockArrowPainter({
    this.color = AppColors.textDark,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.38;

    // Arc with arrow (nearly full circle)
    final arcPath = Path();
    arcPath.addArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi * 0.4,
      math.pi * 1.7,
    );
    canvas.drawPath(arcPath, paint);

    // Arrowhead at top
    final arrowTip = Offset(
      center.dx + radius * math.cos(-math.pi * 0.4),
      center.dy + radius * math.sin(-math.pi * 0.4),
    );
    final arrowPath = Path();
    arrowPath.moveTo(arrowTip.dx - 3, arrowTip.dy - 6);
    arrowPath.lineTo(arrowTip.dx + 4, arrowTip.dy);
    arrowPath.lineTo(arrowTip.dx + 1, arrowTip.dy + 6);
    canvas.drawPath(arrowPath, paint);

    // Clock hands
    canvas.drawLine(center, Offset(center.dx, center.dy - radius * 0.55), paint);
    canvas.drawLine(center, Offset(center.dx + radius * 0.45, center.dy), paint);
  }

  @override
  bool shouldRepaint(covariant ClockArrowPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

class ClockArrowIcon extends StatelessWidget {
  final double size;
  final Color color;

  const ClockArrowIcon({
    super.key,
    this.size = 22,
    this.color = AppColors.textDark,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: ClockArrowPainter(color: color),
    );
  }
}

/// Google Logo Widget
class GoogleLogo extends StatelessWidget {
  final double size;

  const GoogleLogo({super.key, this.size = 18});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: GoogleLogoPainter(),
    );
  }
}

class GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double stroke = w * 0.22;
    final center = Offset(w / 2, h / 2);
    final radius = (w - stroke) / 2;

    final rect = Rect.fromCircle(center: center, radius: radius);

    final paintBlue = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;

    final paintGreen = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;

    final paintYellow = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;

    final paintRed = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;

    // Draw Google arcs
    // Red (top)
    canvas.drawArc(rect, -math.pi * 0.75, math.pi * 0.55, false, paintRed);
    // Yellow (left)
    canvas.drawArc(rect, -math.pi * 0.20, -math.pi * 0.55, false, paintYellow);
    // Green (bottom)
    canvas.drawArc(rect, math.pi * 0.25, math.pi * 0.55, false, paintGreen);
    // Blue (right)
    canvas.drawArc(rect, -math.pi * 0.20, math.pi * 0.45, false, paintBlue);

    // Blue horizontal bar
    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(w * 0.45, h * 0.40, w * 0.50, h * 0.20),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Facebook 'f' Logo Widget
class FacebookLogo extends StatelessWidget {
  final double size;

  const FacebookLogo({super.key, this.size = 18});

  @override
  Widget build(BuildContext context) {
    return Text(
      'f',
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: size * 1.3,
        fontWeight: FontWeight.w900,
        color: AppColors.facebookBlue,
        height: 1.0,
      ),
    );
  }
}

/// Circular Royal Blue Back Button
class CircleBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double size;

  const CircleBackButton({
    super.key,
    this.onTap,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.maybePop(context),
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: size * 0.58,
          ),
        ),
      ),
    );
  }
}

/// Custom Painter for Folded Blanket (Cuci Selimut)
class BlanketPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  BlanketPainter({
    this.color = AppColors.primary,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Outer folded blanket (top roll)
    final topRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.12, h * 0.20, w * 0.76, h * 0.30),
      const Radius.circular(8),
    );
    canvas.drawRRect(topRect, fillPaint);

    // Inner fold roll line on top layer
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.12, h * 0.52, w * 0.76, h * 0.28),
        const Radius.circular(8),
      ),
      paint,
    );

    // Bottom layer fold
    canvas.drawLine(
      Offset(w * 0.20, h * 0.82),
      Offset(w * 0.88, h * 0.82),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant BlanketPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

class BlanketIcon extends StatelessWidget {
  final double size;
  final Color color;

  const BlanketIcon({
    super.key,
    this.size = 28,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: BlanketPainter(color: color),
    );
  }
}

/// Custom Painter for Bed Cover (Cuci Bed Cover)
class BedCoverPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  BedCoverPainter({
    this.color = AppColors.primary,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    // Bed frame: headboard on left
    canvas.drawLine(
      Offset(w * 0.12, h * 0.25),
      Offset(w * 0.12, h * 0.78),
      paint,
    );

    // Mattress top line
    canvas.drawLine(
      Offset(w * 0.12, h * 0.52),
      Offset(w * 0.88, h * 0.52),
      paint,
    );

    // Footboard on right
    canvas.drawLine(
      Offset(w * 0.88, h * 0.42),
      Offset(w * 0.88, h * 0.78),
      paint,
    );

    // Bed legs
    canvas.drawLine(
      Offset(w * 0.12, h * 0.78),
      Offset(w * 0.12, h * 0.88),
      paint,
    );
    canvas.drawLine(
      Offset(w * 0.88, h * 0.78),
      Offset(w * 0.88, h * 0.88),
      paint,
    );

    // Pillow on the left
    final pillowRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.20, h * 0.36, w * 0.22, h * 0.14),
      const Radius.circular(3),
    );
    canvas.drawRRect(pillowRRect, paint);

    // Bed sheet / blanket line
    canvas.drawLine(
      Offset(w * 0.44, h * 0.48),
      Offset(w * 0.88, h * 0.48),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant BedCoverPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

class BedCoverIcon extends StatelessWidget {
  final double size;
  final Color color;

  const BedCoverIcon({
    super.key,
    this.size = 28,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: BedCoverPainter(color: color),
    );
  }
}

/// Custom Painter for Teddy Bear (Cuci Boneka)
class TeddyBearPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  TeddyBearPainter({
    this.color = AppColors.primary,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    // Left Ear
    canvas.drawCircle(Offset(w * 0.28, h * 0.26), w * 0.12, paint);
    // Right Ear
    canvas.drawCircle(Offset(w * 0.72, h * 0.26), w * 0.12, paint);

    // Head
    canvas.drawCircle(Offset(w * 0.50, h * 0.40), w * 0.24, paint);

    // Muzzle / snout
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.50, h * 0.46),
        width: w * 0.20,
        height: h * 0.14,
      ),
      paint,
    );

    // Body
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.50, h * 0.74),
        width: w * 0.38,
        height: h * 0.30,
      ),
      paint,
    );

    // Left Foot
    canvas.drawCircle(Offset(w * 0.30, h * 0.84), w * 0.10, paint);
    // Right Foot
    canvas.drawCircle(Offset(w * 0.70, h * 0.84), w * 0.10, paint);
  }

  @override
  bool shouldRepaint(covariant TeddyBearPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

class TeddyBearIcon extends StatelessWidget {
  final double size;
  final Color color;

  const TeddyBearIcon({
    super.key,
    this.size = 28,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: TeddyBearPainter(color: color),
    );
  }
}

/// Custom Painter for Shoe (Cuci Sepatu)
class ShoePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  ShoePainter({
    this.color = AppColors.primary,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    // Sneaker outline path
    final path = Path();
    path.moveTo(w * 0.18, h * 0.35);
    // Ankle collar down to heel
    path.lineTo(w * 0.12, h * 0.55);
    path.lineTo(w * 0.12, h * 0.78);
    // Heel to toe (sole)
    path.lineTo(w * 0.88, h * 0.78);
    // Toe upward curve
    path.quadraticBezierTo(w * 0.94, h * 0.72, w * 0.88, h * 0.65);
    // Forefoot back to tongue
    path.lineTo(w * 0.55, h * 0.58);
    // Laces slope up to collar
    path.lineTo(w * 0.38, h * 0.35);
    // Collar top
    path.close();
    canvas.drawPath(path, paint);

    // Sole bottom accent line
    canvas.drawLine(
      Offset(w * 0.10, h * 0.86),
      Offset(w * 0.90, h * 0.86),
      paint,
    );

    // Laces ticks
    canvas.drawLine(
      Offset(w * 0.44, h * 0.45),
      Offset(w * 0.50, h * 0.48),
      paint,
    );
    canvas.drawLine(
      Offset(w * 0.50, h * 0.52),
      Offset(w * 0.56, h * 0.55),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant ShoePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

class ShoeIcon extends StatelessWidget {
  final double size;
  final Color color;

  const ShoeIcon({
    super.key,
    this.size = 28,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: ShoePainter(color: color),
    );
  }
}

/// Custom Painter for Pants (Wenter Pakaian)
class PantsPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  PantsPainter({
    this.color = AppColors.primary,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    final path = Path();
    // Waistband top
    path.moveTo(w * 0.22, h * 0.18);
    path.lineTo(w * 0.78, h * 0.18);
    // Right outer hip & leg down
    path.lineTo(w * 0.82, h * 0.40);
    path.lineTo(w * 0.74, h * 0.88);
    // Right cuff
    path.lineTo(w * 0.54, h * 0.88);
    // Inseam up to crotch
    path.lineTo(w * 0.50, h * 0.52);
    // Left inseam down
    path.lineTo(w * 0.46, h * 0.88);
    // Left cuff
    path.lineTo(w * 0.26, h * 0.88);
    // Left outer leg & hip up
    path.lineTo(w * 0.18, h * 0.40);
    path.close();
    canvas.drawPath(path, paint);

    // Waistband horizontal stitch line
    canvas.drawLine(
      Offset(w * 0.21, h * 0.26),
      Offset(w * 0.79, h * 0.26),
      paint,
    );

    // Fly seam
    canvas.drawLine(
      Offset(w * 0.50, h * 0.26),
      Offset(w * 0.50, h * 0.44),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant PantsPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

class PantsIcon extends StatelessWidget {
  final double size;
  final Color color;

  const PantsIcon({
    super.key,
    this.size = 28,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: PantsPainter(color: color),
    );
  }
}

/// Analog Clock Widget for Jam Operasional
class AnalogClockWidget extends StatelessWidget {
  final double size;

  const AnalogClockWidget({
    super.key,
    this.size = 140,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: AnalogClockPainter(),
    );
  }
}

class AnalogClockPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer thick grey ring
    final ringPaint = Paint()
      ..color = const Color(0xFFD1D5DB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.12;
    canvas.drawCircle(center, radius - ringPaint.strokeWidth / 2, ringPaint);

    // Inner white face
    final facePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - ringPaint.strokeWidth, facePaint);

    // 4 cardinal tick markers (12, 3, 6, 9)
    final tickPaint = Paint()
      ..color = const Color(0xFF9CA3AF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final tickOffset = radius - ringPaint.strokeWidth * 1.35;
    // 12 o'clock
    canvas.drawLine(
      Offset(center.dx, center.dy - tickOffset),
      Offset(center.dx, center.dy - tickOffset + 6),
      tickPaint,
    );
    // 6 o'clock
    canvas.drawLine(
      Offset(center.dx, center.dy + tickOffset),
      Offset(center.dx, center.dy + tickOffset - 6),
      tickPaint,
    );
    // 9 o'clock
    canvas.drawLine(
      Offset(center.dx - tickOffset, center.dy),
      Offset(center.dx - tickOffset + 6, center.dy),
      tickPaint,
    );
    // 3 o'clock
    canvas.drawLine(
      Offset(center.dx + tickOffset, center.dy),
      Offset(center.dx + tickOffset - 6, center.dy),
      tickPaint,
    );

    // Hour Hand (points towards 4:00 or 4:30)
    final hourAngle = math.pi * 0.28; // ~4 o'clock
    final hourLength = radius * 0.44;
    final hourPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.040
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      center,
      Offset(
        center.dx + hourLength * math.cos(hourAngle),
        center.dy + hourLength * math.sin(hourAngle),
      ),
      hourPaint,
    );

    // Minute Hand (points straight up towards 12:00)
    final minuteAngle = -math.pi * 0.50; // 12 o'clock
    final minuteLength = radius * 0.58;
    final minutePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.032
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      center,
      Offset(
        center.dx + minuteLength * math.cos(minuteAngle),
        center.dy + minuteLength * math.sin(minuteAngle),
      ),
      minutePaint,
    );

    // Center circular cap
    final capPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.055, capPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Coupon Ticket Icon
class CouponTicketIcon extends StatelessWidget {
  final double size;
  final Color color;

  const CouponTicketIcon({
    super.key,
    this.size = 22,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.confirmation_number_outlined,
      size: size,
      color: color,
    );
  }
}


