import 'package:flutter/material.dart';
import 'package:flame/components.dart';

class BatteryComponent extends PositionComponent {
  BatteryComponent({
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, anchor: Anchor.center);

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = const Color(0xFFF5A623)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final center = size / 2;
    
    // Negative terminal (shorter line)
    canvas.drawLine(
      Offset(center.x - 10, center.y - 20),
      Offset(center.x - 10, center.y + 20),
      paint,
    );

    // Positive terminal (longer line)
    canvas.drawLine(
      Offset(center.x + 10, center.y - 35),
      Offset(center.x + 10, center.y + 35),
      paint,
    );

    // Plus sign
    final textPaint = TextPaint(
      style: const TextStyle(
        color: Color(0xFFF5A623),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
    textPaint.render(canvas, '+', Vector2(center.x + 15, center.y - 50));
    textPaint.render(canvas, '-', Vector2(center.x - 25, center.y - 35));
  }
}
