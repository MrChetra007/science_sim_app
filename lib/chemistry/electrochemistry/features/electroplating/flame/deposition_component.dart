import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart' show Colors;
import '../providers/electroplating_state.dart';
import '../../../core/theme/electrode_colors.dart';

class DepositionComponent extends PositionComponent {
  ElectroplatingState state;
  late final Paint _basePaint;
  late final Paint _platingPaint;

  DepositionComponent({
    required Vector2 position,
    required this.state,
  }) : super(position: position, size: Vector2(100, 100)) {
    _basePaint = Paint()
      ..color = const Color(0xFF555555) // Iron/Base metal
      ..style = PaintingStyle.fill;
    _platingPaint = Paint()
      ..style = PaintingStyle.fill;
  }

  void updateState(ElectroplatingState newState) {
    state = newState;
    _platingPaint.color = ElectrodeColors.metalFill[state.metal.symbol] ?? Colors.grey;
  }

  @override
  void render(Canvas canvas) {
    final Path path = _getObjectPath();
    
    // Draw base object
    canvas.drawPath(path, _basePaint);

    // Draw plating layer (alpha based on mass)
    // We simulate "thickness" by drawing the same path with a slightly larger stroke or opacity
    final double platingAlpha = (state.depositedMassMg / 50.0).clamp(0.0, 1.0);
    if (platingAlpha > 0) {
      canvas.drawPath(
        path,
        Paint()
          ..color = _platingPaint.color.withValues(alpha: platingAlpha)
          ..style = PaintingStyle.fill,
      );
      
      // Draw a subtle border to show thickness
      canvas.drawPath(
        path,
        Paint()
          ..color = _platingPaint.color.withValues(alpha: platingAlpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = (state.depositedMassMg / 20.0).clamp(0.5, 4.0),
      );
    }
  }

  Path _getObjectPath() {
    final path = Path();
    switch (state.target) {
      case PlatingObject.key:
        path.addOval(Rect.fromLTWH(0, 30, 40, 40)); // Key head
        path.addRect(Rect.fromLTWH(40, 45, 50, 10)); // Key shaft
        path.addRect(Rect.fromLTWH(70, 55, 5, 8));   // Tooth 1
        path.addRect(Rect.fromLTWH(80, 55, 5, 8));   // Tooth 2
        break;
      case PlatingObject.spoon:
        path.addOval(Rect.fromLTWH(0, 20, 50, 60)); // Spoon bowl
        path.addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(50, 45, 50, 10), 
          const Radius.circular(5),
        )); // Handle
        break;
      case PlatingObject.coin:
        path.addOval(Rect.fromLTWH(10, 10, 80, 80));
        break;
    }
    return path;
  }
}
