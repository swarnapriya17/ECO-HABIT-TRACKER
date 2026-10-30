import 'dart:math' as math;
import 'package:flutter/material.dart';

class EcoBannerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Background gradient: pale mint to warm sage
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFE2F3E7), Color(0xFFCBEAD4)],
      ).createShader(rect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(16)),
      bgPaint,
    );

    // Subtle sun in corner
    final sunCenter = Offset(size.width * 0.88, size.height * 0.3);
    final sunPaint = Paint()
      ..color = const Color(0xFFFDE047).withValues(alpha: 0.6);
    canvas.drawCircle(sunCenter, 18, sunPaint);

    // Rolling green hill at bottom
    final hillPath = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.7)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.5,
        size.width * 0.65,
        size.height * 0.68,
      )
      ..quadraticBezierTo(
        size.width * 0.85,
        size.height * 0.8,
        size.width,
        size.height * 0.58,
      )
      ..lineTo(size.width, size.height)
      ..close();
    final hillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF489960), Color(0xFF2C6B40)],
      ).createShader(rect);
    canvas.drawPath(hillPath, hillPaint);

    // Wind turbine
    _drawWindTurbine(canvas, Offset(size.width * 0.74, size.height * 0.62), 32);

    // Clustered Trees
    _drawMiniTree(
      canvas,
      Offset(size.width * 0.84, size.height * 0.72),
      22,
      const Color(0xFF1B552F),
    );
    _drawMiniTree(
      canvas,
      Offset(size.width * 0.90, size.height * 0.76),
      18,
      const Color(0xFF2E7D47),
    );
  }

  void _drawWindTurbine(Canvas canvas, Offset base, double height) {
    // Tower
    final towerPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    final top = Offset(base.dx, base.dy - height);
    canvas.drawLine(base, top, towerPaint);

    // Hub
    final hubPaint = Paint()..color = Colors.white;
    canvas.drawCircle(top, 2.5, hubPaint);

    // Blades (3 blades at 120 degrees)
    final bladePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 3; i++) {
      final angle = (i * 2 * math.pi / 3) - 0.5;
      final bladeLen = height * 0.45;
      final end = Offset(
        top.dx + bladeLen * math.cos(angle),
        top.dy + bladeLen * math.sin(angle),
      );
      canvas.drawLine(top, end, bladePaint);
    }
  }

  void _drawMiniTree(Canvas canvas, Offset base, double height, Color color) {
    final trunkPaint = Paint()
      ..color = const Color(0xFF4E342E)
      ..strokeWidth = 2.0;
    canvas.drawLine(base, Offset(base.dx, base.dy - height * 0.35), trunkPaint);

    final crownCenter = Offset(base.dx, base.dy - height * 0.65);
    final crownPaint = Paint()..color = color;
    canvas.drawCircle(crownCenter, height * 0.35, crownPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
