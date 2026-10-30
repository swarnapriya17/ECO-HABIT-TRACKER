import 'dart:math' as math;
import 'package:flutter/material.dart';

class GlowingSeedlingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.58);
    final scale = math.min(size.width, size.height) / 100.0;

    // Glowing halo behind the seedling
    final haloPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF4ADE80).withValues(alpha: 0.35),
          const Color(0xFF22C55E).withValues(alpha: 0.15),
          Colors.transparent,
        ],
        stops: const [0.1, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: 45 * scale));
    canvas.drawCircle(center, 45 * scale, haloPaint);

    // Sparkle particles
    _drawSparkle(
      canvas,
      Offset(center.dx - 28 * scale, center.dy - 25 * scale),
      4 * scale,
    );
    _drawSparkle(
      canvas,
      Offset(center.dx + 26 * scale, center.dy - 32 * scale),
      5 * scale,
    );
    _drawSparkle(
      canvas,
      Offset(center.dx + 32 * scale, center.dy - 8 * scale),
      3 * scale,
    );
    _drawSparkle(
      canvas,
      Offset(center.dx - 18 * scale, center.dy + 8 * scale),
      3 * scale,
    );

    // Earthen mound at base
    final soilPaint = Paint()
      ..shader =
          const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3F2E1E), Color(0xFF231A12)],
          ).createShader(
            Rect.fromLTWH(
              center.dx - 30 * scale,
              center.dy + 16 * scale,
              60 * scale,
              20 * scale,
            ),
          );
    final soilPath = Path()
      ..moveTo(center.dx - 28 * scale, center.dy + 26 * scale)
      ..quadraticBezierTo(
        center.dx,
        center.dy + 16 * scale,
        center.dx + 28 * scale,
        center.dy + 26 * scale,
      )
      ..close();
    canvas.drawPath(soilPath, soilPaint);

    // Green moss/grass tuft at base
    final mossPaint = Paint()
      ..color = const Color(0xFF22C55E).withValues(alpha: 0.8);
    canvas.drawCircle(
      Offset(center.dx - 12 * scale, center.dy + 22 * scale),
      4 * scale,
      mossPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + 10 * scale, center.dy + 23 * scale),
      5 * scale,
      mossPaint,
    );

    // Stem (graceful bezier curve)
    final stemPaint = Paint()
      ..color = const Color(0xFF4ADE80)
      ..strokeWidth = 3.5 * scale
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final stemPath = Path()
      ..moveTo(center.dx, center.dy + 20 * scale)
      ..cubicTo(
        center.dx - 4 * scale,
        center.dy + 5 * scale,
        center.dx + 6 * scale,
        center.dy - 10 * scale,
        center.dx,
        center.dy - 22 * scale,
      );
    canvas.drawPath(stemPath, stemPaint);

    // Left Leaf (broad fresh leaf)
    final leftLeafPaint = Paint()
      ..shader =
          const LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [Color(0xFF22C55E), Color(0xFF86EFAC)],
          ).createShader(
            Rect.fromLTWH(
              center.dx - 28 * scale,
              center.dy - 32 * scale,
              30 * scale,
              24 * scale,
            ),
          );
    final leftLeafPath = Path()
      ..moveTo(center.dx + 2 * scale, center.dy - 14 * scale)
      ..cubicTo(
        center.dx - 14 * scale,
        center.dy - 12 * scale,
        center.dx - 28 * scale,
        center.dy - 24 * scale,
        center.dx - 26 * scale,
        center.dy - 32 * scale,
      )
      ..cubicTo(
        center.dx - 16 * scale,
        center.dy - 36 * scale,
        center.dx - 4 * scale,
        center.dy - 26 * scale,
        center.dx + 1 * scale,
        center.dy - 16 * scale,
      )
      ..close();
    canvas.drawPath(leftLeafPath, leftLeafPaint);

    // Left leaf vein
    final veinPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..strokeWidth = 1.0 * scale
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final leftVein = Path()
      ..moveTo(center.dx, center.dy - 15 * scale)
      ..quadraticBezierTo(
        center.dx - 12 * scale,
        center.dy - 24 * scale,
        center.dx - 24 * scale,
        center.dy - 30 * scale,
      );
    canvas.drawPath(leftVein, veinPaint);

    // Right Leaf (larger uplifting leaf)
    final rightLeafPaint = Paint()
      ..shader =
          const LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [Color(0xFF16A34A), Color(0xFF4ADE80)],
          ).createShader(
            Rect.fromLTWH(
              center.dx,
              center.dy - 38 * scale,
              32 * scale,
              26 * scale,
            ),
          );
    final rightLeafPath = Path()
      ..moveTo(center.dx - 1 * scale, center.dy - 20 * scale)
      ..cubicTo(
        center.dx + 14 * scale,
        center.dy - 18 * scale,
        center.dx + 28 * scale,
        center.dy - 30 * scale,
        center.dx + 26 * scale,
        center.dy - 40 * scale,
      )
      ..cubicTo(
        center.dx + 14 * scale,
        center.dy - 40 * scale,
        center.dx + 4 * scale,
        center.dy - 30 * scale,
        center.dx - 1 * scale,
        center.dy - 22 * scale,
      )
      ..close();
    canvas.drawPath(rightLeafPath, rightLeafPaint);

    // Right leaf vein
    final rightVein = Path()
      ..moveTo(center.dx, center.dy - 21 * scale)
      ..quadraticBezierTo(
        center.dx + 14 * scale,
        center.dy - 28 * scale,
        center.dx + 24 * scale,
        center.dy - 38 * scale,
      );
    canvas.drawPath(rightVein, veinPaint);

    // Small budding top leaf
    final budPaint = Paint()..color = const Color(0xFFBBF7D0);
    final budPath = Path()
      ..moveTo(center.dx, center.dy - 22 * scale)
      ..quadraticBezierTo(
        center.dx + 3 * scale,
        center.dy - 28 * scale,
        center.dx,
        center.dy - 32 * scale,
      )
      ..quadraticBezierTo(
        center.dx - 3 * scale,
        center.dy - 28 * scale,
        center.dx,
        center.dy - 22 * scale,
      )
      ..close();
    canvas.drawPath(budPath, budPaint);
  }

  void _drawSparkle(Canvas canvas, Offset pos, double radius) {
    final paint = Paint()
      ..color = const Color(0xFFFEF08A).withValues(alpha: 0.85);
    canvas.drawCircle(pos, radius * 0.4, paint);

    final linePaint = Paint()
      ..color = const Color(0xFFFEF08A).withValues(alpha: 0.8)
      ..strokeWidth = 1.0;
    canvas.drawLine(
      Offset(pos.dx - radius, pos.dy),
      Offset(pos.dx + radius, pos.dy),
      linePaint,
    );
    canvas.drawLine(
      Offset(pos.dx, pos.dy - radius),
      Offset(pos.dx, pos.dy + radius),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
