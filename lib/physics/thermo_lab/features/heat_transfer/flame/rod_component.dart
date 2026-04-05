import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/temp_colors.dart';

class RodComponent extends PositionComponent with HasGameReference {
  late List<double> temps;

  RodComponent({required int segments, super.size, super.position}) {
    temps = List.filled(segments, 25.0);
  }

  @override
  void render(Canvas canvas) {
    if (temps.isEmpty) return;

    final segmentWidth = size.x / temps.length;
    for (int i = 0; i < temps.length; i++) {
      final color = TempColors.forTemp(temps[i]);
      final paint = Paint()..color = color;
      canvas.drawRect(
        Rect.fromLTWH(i * segmentWidth, 0, segmentWidth, size.y),
        paint,
      );
    }

    // Draw segment dividers
    final divider = Paint()
      ..color = AppColors.bgDeep.withOpacity(0.3)
      ..strokeWidth = 1;
    for (int i = 1; i < temps.length; i++) {
      canvas.drawLine(
        Offset(i * segmentWidth, 0),
        Offset(i * segmentWidth, size.y),
        divider,
      );
    }

    // Draw border
    final border = Paint()
      ..color = AppColors.borderDefault
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(size.toRect(), border);
  }

  void tickConduction(double dt, double heatSourceTemp, double conductivity) {
    // Heat first segment from source
    temps[0] += (heatSourceTemp - temps[0]) * conductivity * dt * 0.005;

    // Propagation logic moved here from Riverpod
    for (int i = 1; i < temps.length; i++) {
      final delta = temps[i - 1] - temps[i];
      temps[i] += delta * conductivity * dt * 0.002;
    }
  }

  void reset() {
    temps.fillRange(0, temps.length, 25.0);
  }
}
