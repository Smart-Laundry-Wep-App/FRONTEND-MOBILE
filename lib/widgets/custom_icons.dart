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

