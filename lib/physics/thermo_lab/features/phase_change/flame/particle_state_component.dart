import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../providers/phase_provider.dart';
import '../../../core/theme/temp_colors.dart';

class ParticleStateComponent extends PositionComponent with HasGameReference {
  Vector2 velocity = Vector2.zero();
  Vector2 homePosition;
  double temperature;
  PhysicalState phase;
  final Random _rnd = Random();

  ParticleStateComponent({
    required this.homePosition,
    required this.temperature,
    required this.phase,
  }) : super(position: Vector2.copy(homePosition), size: Vector2.all(8));

  @override
  void update(double dt) {
    super.update(dt);
    
    switch (phase) {
      case PhysicalState.solid:
      case PhysicalState.melting:
        // Vibrate around lattice position (Solid behavior)
        final intensity = (temperature + 273) * 0.05; // speed up vibration as it warms
        position = homePosition + Vector2(
          (_rnd.nextDouble() - 0.5) * intensity,
          (_rnd.nextDouble() - 0.5) * intensity,
        );
        break;
        
      case PhysicalState.liquid:
        // Slow Brownian motion in bottom half
        if (velocity.isZero()) {
          velocity = Vector2(_rnd.nextDouble() - 0.5, _rnd.nextDouble() - 0.5) * 60;
        }
        position += velocity * dt;
        _bounce(dt, game.size.y * 0.8, game.size.y);
        break;
        
      case PhysicalState.boiling:
      case PhysicalState.gas:
        // Free rapid motion
        if (velocity.length < 150) {
          velocity = Vector2(_rnd.nextDouble() - 0.5, _rnd.nextDouble() - 0.5) * 300;
        }
        position += velocity * dt;
        _bounce(dt, 0.0, game.size.y);
        break;
    }
  }

  void _bounce(double dt, double minY, double maxY) {
    if (position.x < 10) velocity.x = velocity.x.abs();
    if (position.x > game.size.x - 10) velocity.x = -velocity.x.abs();
    if (position.y < minY) velocity.y = velocity.y.abs();
    if (position.y > maxY - 10) velocity.y = -velocity.y.abs();
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = TempColors.forTemp(temperature).withValues(alpha: 0.8);
    canvas.drawCircle(Offset.zero, 3, paint);
  }
}
