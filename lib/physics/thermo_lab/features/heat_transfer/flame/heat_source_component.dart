import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/temp_colors.dart';

class HeatSourceComponent extends PositionComponent with HasGameReference {
  double temperature;
  final Random _random = Random();

  HeatSourceComponent({
    required this.temperature,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = TempColors.forTemp(temperature)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    // Dynamic flame effect
    for (int i = 0; i < 5; i++) {
        final xOffset = (_random.nextDouble() - 0.5) * 10;
        final yOffset = -_random.nextDouble() * 20;
        canvas.drawCircle(
          Offset(size.x / 2 + xOffset, size.y / 2 + yOffset),
          12 + _random.nextDouble() * 10,
          paint..color = TempColors.forTemp(temperature).withOpacity(0.4),
        );
    }

    // Base of the heater
    final basePaint = Paint()..color = Colors.grey[800]!;
    canvas.drawRect(
      Rect.fromLTWH(0, size.y - 10, size.x, 10),
      basePaint,
    );
  }

  void updateTemp(double newTemp) {
    temperature = newTemp;
  }
}
