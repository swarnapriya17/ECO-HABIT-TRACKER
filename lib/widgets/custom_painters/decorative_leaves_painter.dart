import 'package:flutter/material.dart';

class DecorativeLeavesPainter extends CustomPainter {
  final Color leafColor;

  const DecorativeLeavesPainter({this.leafColor = const Color(0xFF22C55E)});

  @override
  void paint(Canvas canvas, Size size) {
    // Top right decorative leaf
    _drawLeaf(
      canvas,
      Offset(size.width * 0.92, size.height * 0.15),
      36,
      0.4,
      leafColor.withValues(alpha: 0.12),
    );

    // Bottom left subtle leaf
    _drawLeaf(
      canvas,
      Offset(size.width * 0.08, size.height * 0.85),
      30,
      -0.8,
      leafColor.withValues(alpha: 0.10),
    );

    // Center background faint leaf
    _drawLeaf(
      canvas,
      Offset(size.width * 0.85, size.height * 0.80),
      44,
      -1.4,
      leafColor.withValues(alpha: 0.08),
    );
  }

  void _drawLeaf(
    Canvas canvas,
    Offset center,
    double size,
    double rotation,
    Color color,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, -size * 0.6)
      ..cubicTo(size * 0.5, -size * 0.3, size * 0.5, size * 0.4, 0, size * 0.6)
      ..cubicTo(
        -size * 0.5,
        size * 0.4,
        -size * 0.5,
        -size * 0.3,
        0,
        -size * 0.6,
      )
      ..close();
    canvas.drawPath(path, paint);

    // Leaf center vein
    final strokePaint = Paint()
      ..color = color.withValues(alpha: color.a * 1.5)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(0, -size * 0.55),
      Offset(0, size * 0.55),
      strokePaint,
    );

    // Side veins
    canvas.drawLine(const Offset(0, -8), const Offset(8, -14), strokePaint);
    canvas.drawLine(const Offset(0, -8), const Offset(-8, -14), strokePaint);
    canvas.drawLine(const Offset(0, 4), const Offset(10, -2), strokePaint);
    canvas.drawLine(const Offset(0, 4), const Offset(-10, -2), strokePaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
