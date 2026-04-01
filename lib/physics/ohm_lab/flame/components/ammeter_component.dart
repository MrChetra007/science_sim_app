import 'package:flutter/material.dart';
import 'package:flame/components.dart';

class AmmeterComponent extends PositionComponent {
  AmmeterComponent({
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, anchor: Anchor.center);

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = const Color(0xFF00CFFF)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final center = size / 2;
    final radius = size.x / 2;

    canvas.drawCircle(center.toOffset(), radius, paint);

    // Glow
    final glowPaint = Paint()
      ..color = const Color(0xFF00CFFF).withOpacity(0.3)
      ..strokeWidth = 6.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0)
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center.toOffset(), radius, glowPaint);

    final textPaint = TextPaint(
      style: const TextStyle(
        color: Color(0xFF00CFFF),
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: 'Orbitron',
      ),
    );
    textPaint.render(canvas, 'A', Vector2(center.x - 10, center.y - 15));
  }
}
