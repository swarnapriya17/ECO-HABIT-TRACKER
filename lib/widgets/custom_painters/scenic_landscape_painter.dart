import 'package:flutter/material.dart';

class ScenicLandscapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Sky soft gradient
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFEAF5EE), Color(0xFFD6EDE0), Color(0xFFC7E6D3)],
      ).createShader(rect);
    canvas.drawRect(rect, skyPaint);

    // Warm Sun
    final sunCenter = Offset(size.width * 0.78, size.height * 0.28);
    final sunGlowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFEF08A).withValues(alpha: 0.6),
          const Color(0xFFFEF9C3).withValues(alpha: 0.2),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: sunCenter, radius: 45));
    canvas.drawCircle(sunCenter, 45, sunGlowPaint);

    final sunCorePaint = Paint()
      ..color = const Color(0xFFFDE047).withValues(alpha: 0.85);
    canvas.drawCircle(sunCenter, 20, sunCorePaint);

    // Floating subtle clouds
    _drawCloud(canvas, Offset(size.width * 0.25, size.height * 0.22), 26);
    _drawCloud(canvas, Offset(size.width * 0.60, size.height * 0.16), 34);

    // Birds in flight
    _drawBird(canvas, Offset(size.width * 0.40, size.height * 0.22), 7);
    _drawBird(canvas, Offset(size.width * 0.44, size.height * 0.18), 9);
    _drawBird(canvas, Offset(size.width * 0.48, size.height * 0.24), 6);

    // Far distant mountain/hills (soft sage)
    final farHill = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.65)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.48,
        size.width * 0.55,
        size.height * 0.62,
      )
      ..quadraticBezierTo(
        size.width * 0.8,
        size.height * 0.72,
        size.width,
        size.height * 0.52,
      )
      ..lineTo(size.width, size.height)
      ..close();
    final farHillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF98C7A8), Color(0xFF7FA88E)],
      ).createShader(rect);
    canvas.drawPath(farHill, farHillPaint);

    // Mid hills (rich mint green)
    final midHill = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.78)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.56,
        size.width * 0.68,
        size.height * 0.74,
      )
      ..quadraticBezierTo(
        size.width * 0.88,
        size.height * 0.84,
        size.width,
        size.height * 0.66,
      )
      ..lineTo(size.width, size.height)
      ..close();
    final midHillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF52A56E), Color(0xFF388352)],
      ).createShader(rect);
    canvas.drawPath(midHill, midHillPaint);

    // Near front hill (deep lush green)
    final nearHill = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.90)
      ..quadraticBezierTo(
        size.width * 0.42,
        size.height * 0.72,
        size.width * 0.82,
        size.height * 0.92,
      )
      ..lineTo(size.width, size.height * 0.85)
      ..lineTo(size.width, size.height)
      ..close();
    final nearHillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF2E7D47), Color(0xFF1B552F)],
      ).createShader(rect);
    canvas.drawPath(nearHill, nearHillPaint);

    // Stylized trees
    _drawStylizedTree(
      canvas,
      Offset(size.width * 0.72, size.height * 0.72),
      28,
      const Color(0xFF23683A),
    );
    _drawStylizedTree(
      canvas,
      Offset(size.width * 0.78, size.height * 0.76),
      34,
      const Color(0xFF1B552F),
    );
    _drawStylizedTree(
      canvas,
      Offset(size.width * 0.85, size.height * 0.70),
      24,
      const Color(0xFF2E7D47),
    );
    _drawPineTree(
      canvas,
      Offset(size.width * 0.92, size.height * 0.78),
      30,
      const Color(0xFF154826),
    );
    _drawPineTree(
      canvas,
      Offset(size.width * 0.62, size.height * 0.68),
      22,
      const Color(0xFF3A8553),
    );
  }

  void _drawCloud(Canvas canvas, Offset center, double width) {
    final cloudPaint = Paint()..color = Colors.white.withValues(alpha: 0.55);
    canvas.drawCircle(center, width * 0.4, cloudPaint);
    canvas.drawCircle(
      Offset(center.dx - width * 0.35, center.dy + 3),
      width * 0.28,
      cloudPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + width * 0.35, center.dy + 2),
      width * 0.30,
      cloudPaint,
    );
  }

  void _drawBird(Canvas canvas, Offset pos, double size) {
    final birdPaint = Paint()
      ..color = const Color(0xFF2D573B).withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(pos.dx - size, pos.dy + size * 0.3)
      ..quadraticBezierTo(
        pos.dx - size * 0.4,
        pos.dy - size * 0.5,
        pos.dx,
        pos.dy,
      )
      ..quadraticBezierTo(
        pos.dx + size * 0.4,
        pos.dy - size * 0.5,
        pos.dx + size,
        pos.dy + size * 0.3,
      );
    canvas.drawPath(path, birdPaint);
  }

  void _drawStylizedTree(
    Canvas canvas,
    Offset bottom,
    double height,
    Color crownColor,
  ) {
    // Trunk
    final trunkPaint = Paint()
      ..color = const Color(0xFF5D4037)
      ..strokeWidth = height * 0.12
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      bottom,
      Offset(bottom.dx, bottom.dy - height * 0.45),
      trunkPaint,
    );

    // Crown
    final crownCenter = Offset(bottom.dx, bottom.dy - height * 0.65);
    final crownPaint = Paint()..color = crownColor;
    canvas.drawCircle(crownCenter, height * 0.38, crownPaint);

    // Crown highlight
    final highlightPaint = Paint()..color = Colors.white.withValues(alpha: 0.2);
    canvas.drawCircle(
      Offset(crownCenter.dx - height * 0.08, crownCenter.dy - height * 0.08),
      height * 0.20,
      highlightPaint,
    );
  }

  void _drawPineTree(
    Canvas canvas,
    Offset bottom,
    double height,
    Color foliageColor,
  ) {
    final trunkPaint = Paint()
      ..color = const Color(0xFF4E342E)
      ..strokeWidth = height * 0.1;
    canvas.drawLine(
      bottom,
      Offset(bottom.dx, bottom.dy - height * 0.3),
      trunkPaint,
    );

    final foliagePaint = Paint()..color = foliageColor;
    for (int i = 0; i < 3; i++) {
      final baseY = bottom.dy - (height * (0.25 + i * 0.22));
      final tierWidth = height * (0.42 - i * 0.08);
      final tierHeight = height * 0.30;
      final path = Path()
        ..moveTo(bottom.dx - tierWidth, baseY)
        ..lineTo(bottom.dx + tierWidth, baseY)
        ..lineTo(bottom.dx, baseY - tierHeight)
        ..close();
      canvas.drawPath(path, foliagePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
