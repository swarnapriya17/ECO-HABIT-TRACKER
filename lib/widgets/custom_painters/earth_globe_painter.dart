import 'dart:math' as math;
import 'package:flutter/material.dart';

class EarthGlobePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.38;

    // Outer gentle aura
    final auraPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF22C55E).withValues(alpha: 0.25),
          const Color(0xFF10B981).withValues(alpha: 0.1),
          Colors.transparent,
        ],
        stops: const [0.4, 0.75, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 1.55));
    canvas.drawCircle(center, radius * 1.55, auraPaint);

    // Globe ocean (deep emerald/teal)
    final oceanPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF0F766E), Color(0xFF115E59), Color(0xFF042F2E)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, oceanPaint);

    // Clip to circle for continents
    canvas.save();
    final clipPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
    canvas.clipPath(clipPath);

    // Land masses (stylized continents in fresh green)
    final landPaint = Paint()
      ..color = const Color(0xFF22C55E).withValues(alpha: 0.85);

    // Continent 1 (North/Central America style)
    final path1 = Path()
      ..moveTo(center.dx - radius * 0.7, center.dy - radius * 0.4)
      ..quadraticBezierTo(
        center.dx - radius * 0.2,
        center.dy - radius * 0.6,
        center.dx - radius * 0.1,
        center.dy - radius * 0.2,
      )
      ..quadraticBezierTo(
        center.dx - radius * 0.3,
        center.dy + radius * 0.1,
        center.dx - radius * 0.2,
        center.dy + radius * 0.6,
      )
      ..quadraticBezierTo(
        center.dx - radius * 0.5,
        center.dy + radius * 0.4,
        center.dx - radius * 0.65,
        center.dy + radius * 0.1,
      )
      ..close();
    canvas.drawPath(path1, landPaint);

    // Continent 2 (Eurasia/Africa style)
    final path2 = Path()
      ..moveTo(center.dx + radius * 0.1, center.dy - radius * 0.5)
      ..quadraticBezierTo(
        center.dx + radius * 0.6,
        center.dy - radius * 0.4,
        center.dx + radius * 0.7,
        center.dy - radius * 0.1,
      )
      ..quadraticBezierTo(
        center.dx + radius * 0.4,
        center.dy + radius * 0.3,
        center.dx + radius * 0.5,
        center.dy + radius * 0.6,
      )
      ..quadraticBezierTo(
        center.dx + radius * 0.2,
        center.dy + radius * 0.5,
        center.dx + radius * 0.1,
        center.dy + radius * 0.1,
      )
      ..close();
    canvas.drawPath(path2, landPaint);

    // Latitude/Longitude grid lines
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: radius * 1.2,
        height: radius * 1.95,
      ),
      gridPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: radius * 1.95,
        height: radius * 0.8,
      ),
      gridPaint,
    );

    // Atmosphere inner shadow/glow
    final innerGlowPaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.35)],
        stops: const [0.75, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, innerGlowPaint);

    canvas.restore();

    // Orbiting decorative leaves around globe
    _drawOrbitLeaf(canvas, center, radius * 1.2, -0.6, const Color(0xFF4ADE80));
    _drawOrbitLeaf(canvas, center, radius * 1.25, 1.2, const Color(0xFF86EFAC));
    _drawOrbitLeaf(canvas, center, radius * 1.15, 2.7, const Color(0xFF22C55E));
  }

  void _drawOrbitLeaf(
    Canvas canvas,
    Offset center,
    double dist,
    double angle,
    Color color,
  ) {
    final x = center.dx + dist * math.cos(angle);
    final y = center.dy + dist * math.sin(angle);

    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(angle + math.pi / 4);

    final leafPaint = Paint()..color = color;
    final leafPath = Path()
      ..moveTo(0, -9)
      ..quadraticBezierTo(6, -2, 0, 9)
      ..quadraticBezierTo(-6, -2, 0, -9)
      ..close();
    canvas.drawPath(leafPath, leafPaint);

    final veinPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(0, -7), const Offset(0, 7), veinPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
