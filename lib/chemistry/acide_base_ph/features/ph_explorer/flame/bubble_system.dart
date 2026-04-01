import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'beaker_game.dart';

class Bubble extends PositionComponent {
  final double radius;
  double _opacity = 0.6;
  final double riseSpeed;

  Bubble({required Vector2 position, required this.radius})
      : riseSpeed = 20 + Random().nextDouble() * 40,
        super(position: position);

  @override
  void update(double dt) {
    super.update(dt);
    position.y -= riseSpeed * dt;
    _opacity -= dt * 0.4;
    if (_opacity <= 0) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(_opacity.clamp(0.0, 1.0))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(Offset.zero, radius, paint);
  }
}

class BubbleSystem extends Component with HasGameRef<BeakerGame> {
  double _ph = 7.0;
  double _spawnTimer = 0;
  final Random _random = Random();

  @override
  void update(double dt) {
    super.update(dt);
    
    // Bubble intensity: more active at extreme acid (<2) or basic (>12)
    final intensity = (_ph < 2 || _ph > 12)
        ? 1.0
        : (_ph < 4 || _ph > 10)
            ? 0.4
            : 0.0;
            
    if (intensity == 0) return;

    _spawnTimer += dt;
    if (_spawnTimer > (0.3 / intensity)) {
      _spawnTimer = 0;
      _spawnBubble();
    }
  }

  void _spawnBubble() {
    final x = 8.0 + _random.nextDouble() * 164;
    final y = 150.0 + _random.nextDouble() * 60;
    gameRef.add(Bubble(
      position: Vector2(x, y),
      radius: 2 + _random.nextDouble() * 6,
    ));
  }

  void updatePH(double ph) => _ph = ph;
}
