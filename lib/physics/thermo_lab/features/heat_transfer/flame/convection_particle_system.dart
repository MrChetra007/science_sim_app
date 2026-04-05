import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/temp_colors.dart';

class ConvectionParticle extends PositionComponent {
  double temperature;
  final double _maxY;
  double _vy;
  final Random _random = Random();

  ConvectionParticle({
    required Vector2 position,
    required this.temperature,
    required double maxY,
  })  : _maxY = maxY,
        _vy = temperature > 100 ? -60.0 : 40.0,
        super(position: position);

  @override
  void update(double dt) {
    position.y += _vy * dt;

    // Add some horizontal jitter
    position.x += (_random.nextDouble() - 0.5) * 20 * dt;

    // Temperature change based on movement
    // Hot particles rise and slowly cool, cool particles sink and slowly heat
    if (_vy < 0) {
      temperature -= 15 * dt; // Cooling as it rises
      if (temperature < 60) _vy = 40.0;
    } else {
      temperature += 20 * dt; // Heating as it sinks (assuming bottom is heat source)
      if (temperature > 150) _vy = -80.0;
    }

    // Wrap around or bounce
    if (position.y < 0) {
      position.y = 0;
      _vy = 40.0;
    }
    if (position.y > _maxY) {
      position.y = _maxY;
      _vy = -80.0;
    }
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = TempColors.forTemp(temperature).withOpacity(0.8);
    canvas.drawCircle(Offset.zero, 6, paint);

    // Subtle glow
    final glow = Paint()
      ..color = TempColors.forTemp(temperature).withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(Offset.zero, 10, glow);
  }
}

class ConvectionParticleSystem extends Component with HasGameReference {
  final int count;
  final double areaWidth;
  final double areaHeight;

  ConvectionParticleSystem({
    required this.count,
    required this.areaWidth,
    required this.areaHeight,
  });

  @override
  Future<void> onLoad() async {
    final random = Random();
    for (int i = 0; i < count; i++) {
      add(
        ConvectionParticle(
          position: Vector2(
            random.nextDouble() * areaWidth,
            random.nextDouble() * areaHeight,
          ),
          temperature: 40.0 + random.nextDouble() * 160.0,
          maxY: areaHeight,
        ),
      );
    }
  }
}
