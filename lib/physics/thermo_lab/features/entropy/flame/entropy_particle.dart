import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class EntropyParticle extends PositionComponent with HasGameReference {
  final bool isRed;
  Vector2 velocity;

  EntropyParticle({
    required Vector2 position,
    required this.isRed,
    required this.velocity,
  }) : super(position: position, size: Vector2.all(8));

  @override
  void update(double dt) {
    super.update(dt);
    
    // Move particle
    position += velocity * dt;

    // Bounce off outer walls
    if (position.x < 5) {
      position.x = 5;
      velocity.x = velocity.x.abs();
    }
    if (position.x > game.size.x - 5) {
      position.x = game.size.x - 5;
      velocity.x = -velocity.x.abs();
    }
    if (position.y < 5) {
      position.y = 5;
      velocity.y = velocity.y.abs();
    }
    if (position.y > game.size.y - 5) {
      position.y = game.size.y - 5;
      velocity.y = -velocity.y.abs();
    }
  }

  void handleWallCollision(double wallX) {
    // If hitting the central partition (from left or right)
    if (isRed) {
      // Red starts on Left [0 to wallX]
      if (position.x > wallX - 5) {
        position.x = wallX - 5;
        velocity.x = -velocity.x.abs();
      }
    } else {
      // Blue starts on Right [wallX to gameWidth]
      if (position.x < wallX + 5) {
        position.x = wallX + 5;
        velocity.x = velocity.x.abs();
      }
    }
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = isRed ? Colors.redAccent : Colors.blueAccent
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);
    canvas.drawCircle(Offset.zero, 3, paint);
  }
}
