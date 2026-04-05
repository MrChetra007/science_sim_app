import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/temp_colors.dart';

class RadiationParticle extends PositionComponent {
  final Vector2 velocity;
  final double lifeTime;
  double age = 0;
  final double temperature;

  RadiationParticle({
    required Vector2 position,
    required this.velocity,
    required this.lifeTime,
    required this.temperature,
  }) : super(position: position, size: Vector2.all(4));

  @override
  void update(double dt) {
    super.update(dt);
    age += dt;
    position += velocity * dt;
    if (age >= lifeTime) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final opacity = (1.0 - (age / lifeTime)).clamp(0.0, 1.0);
    final paint = Paint()..color = TempColors.forTemp(temperature).withOpacity(opacity);
    canvas.drawCircle(Offset.zero, 2, paint);
  }
}

class RadiationParticleSystem extends Component with HasGameReference {
  final Vector2 sourcePosition;
  final Random _random = Random();
  double _timer = 0;
  double _intensity;
  double _temperature;

  RadiationParticleSystem({
    required this.sourcePosition,
    required double temperature,
    required double intensity,
  })  : _temperature = temperature,
        _intensity = intensity;

  @override
  void update(double dt) {
    super.update(dt);
    _timer += dt;
    if (_timer > (0.1 / _intensity).clamp(0.01, 0.1)) {
      _timer = 0;
      _spawnParticle();
    }
  }

  void updateIntensity(double d) {
    _intensity = (1.0 - d).clamp(0.1, 1.0);
  }

  void updateTemp(double t) {
    _temperature = t;
  }

  void _spawnParticle() {
    final angle = (_random.nextDouble() - 0.5) * pi * 0.5 - (pi / 2);
    final velocity =
        Vector2(cos(angle), sin(angle)) * (100 + _random.nextDouble() * 50);

    add(RadiationParticle(
      position: sourcePosition.clone(),
      velocity: velocity,
      lifeTime: 1.5 * _intensity,
      temperature: _temperature,
    ));
  }
}
