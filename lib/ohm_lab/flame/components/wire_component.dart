import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class WireComponent extends PositionComponent {
  final Vector2 start;
  final Vector2 end;
  Color wireColor = const Color(0xFF00FF88);
  double glowIntensity = 0.5;

  WireComponent({
    required this.start,
    required this.end,
  });

  Color targetColor = const Color(0xFF00FF88);

  double _time = 0;

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
    // Smoothly transition wire color
    wireColor = Color.lerp(wireColor, targetColor, dt * 5) ?? targetColor;
    
    // Pulse glow if dangerous
    if (targetColor == const Color(0xFFFF4455)) {
      glowIntensity = 0.5 + (0.5 * (1.0 + (0.1 * (_time * 10).floor() % 2 == 0 ? 1 : -1))); // Simple blink/pulse
      // Better pulse:
      glowIntensity = 0.5 + 0.3 * (1.0 + (0.5 * (1.0 + (0.5 * (_time * 6).floor() % 2 == 0 ? 1 : -1)))); 
      // Actually let's use a simple continuous pulse
      glowIntensity = 0.4 + 0.4 * (0.5 * (1 + (0.5 * (_time * 8).floor() % 2 == 0 ? 1 : -1)));
    } else {
      glowIntensity = 0.5;
    }
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = wireColor
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    // Draw base wire
    canvas.drawLine(start.toOffset(), end.toOffset(), paint);

    // Draw glow layer using MaskFilter
    final glowPaint = Paint()
      ..color = wireColor.withOpacity(0.3 * glowIntensity)
      ..strokeWidth = 10.0 * glowIntensity
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6.0 * glowIntensity)
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start.toOffset(), end.toOffset(), glowPaint);
  }

  void setCurrentLevel(double current) {
    if (current > 1.0) {
      targetColor = const Color(0xFFFF4455); // Red = danger
    } else if (current > 0.2) {
      targetColor = const Color(0xFFF5A623); // Amber = medium
    } else {
      targetColor = const Color(0xFF00FF88); // Green = low
    }
  }
}
