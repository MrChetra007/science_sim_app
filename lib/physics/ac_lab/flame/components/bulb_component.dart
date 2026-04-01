import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../ac_game.dart';

class BulbComponent extends Component with HasGameReference<ACGame> {
  Vector2 size = Vector2.zero();
  Vector2 position = Vector2.zero();

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(position.x, position.y);

    final state = game.provider.state;
    final center = Offset(size.x / 2, size.y / 2);
    final brightness = state.brightness;

    // Outer glow
    final glowPaint = Paint()
      ..color = Colors.amber.withValues(alpha: 0.1 + 0.5 * brightness)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10 + 20 * brightness);
    canvas.drawCircle(center, 30, glowPaint);

    // Bulb glass
    final glassPaint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, 20, glassPaint);

    // Filament (glows with brightness)
    final filamentPaint = Paint()
      ..color = Colors.amber.withValues(alpha: 0.3 + 0.7 * brightness)
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;
    
    canvas.drawLine(
      Offset(center.dx - 10, center.dy + 5),
      Offset(center.dx + 10, center.dy + 5),
      filamentPaint,
    );

    canvas.restore();
  }
}
