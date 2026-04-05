import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class PistonComponent extends PositionComponent with HasGameReference {
  double volume;

  PistonComponent({required this.volume});

  @override
  void render(Canvas canvas) {
    // Elegant gray piston lid
    final lidPaint = Paint()
      ..color = const Color(0xFF616161) // Medium-dark gray
      ..style = PaintingStyle.fill;
    
    // Smooth rounded rect for the lid
    final lidRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(4),
    );
    canvas.drawRRect(lidRect, lidPaint);

    // Accent line for depth
    final accentPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRRect(lidRect, accentPaint);

    // Piston rod (center)
    final rodPaint = Paint()..color = const Color(0xFF424242);
    canvas.drawRect(
      Rect.fromLTWH(size.x / 2 - 4, -40, 8, 40),
      rodPaint,
    );
    
    // Top handle
    canvas.drawRect(
      Rect.fromLTWH(size.x / 2 - 20, -50, 40, 10),
      rodPaint,
    );
  }

  void updateVolume(double newVolume, double gameHeight) {
    volume = newVolume;
    // Map volume (0.1 - 5.0) to vertical position
    final targetY = gameHeight - (volume / 5.0 * gameHeight);
    position.y = targetY.clamp(20.0, gameHeight - 20.0);
  }
}
