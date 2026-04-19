import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class DropComponent extends PositionComponent {
  final double targetY;
  final VoidCallback onLand;
  bool _landed = false;

  DropComponent({
    required double startY,
    required this.targetY,
    required double x,
    required this.onLand,
  }) : super(position: Vector2(x, startY), size: Vector2(8, 14));

  @override
  void update(double dt) {
    super.update(dt);
    if (_landed) return;

    position.y += 350 * dt; // fall speed px/sec
    if (position.y >= targetY) {
      _landed = true;
      onLand();
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    // Draw an oval drop shape
    final paint = Paint()..color = const Color(0xFF4090FF).withOpacity(0.9);
    
    // Tear-drop shape using a simple oval
    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.x, size.y),
      paint,
    );
    
    // Shine highlight
    final shine = Paint()..color = Colors.white.withOpacity(0.4);
    canvas.drawCircle(Offset(size.x * 0.3, size.y * 0.3), 1.5, shine);
  }
}
