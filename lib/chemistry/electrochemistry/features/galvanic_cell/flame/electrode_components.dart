import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import '../../../core/constants/electrodes.dart';
import '../../../core/theme/electrode_colors.dart';
import '../../../core/theme/app_colors.dart';

class ElectrodeComponent extends PositionComponent {
  Electrode electrode;
  final bool isAnode;
  late final Paint _paint;
  late final Paint _borderPaint;

  ElectrodeComponent({
    required Vector2 position,
    required this.electrode,
    this.isAnode = true,
  }) : super(position: position, size: Vector2(30, 80)) {
    _paint = Paint()..color = ElectrodeColors.metalFill[electrode.symbol] ?? Colors.grey;
    _borderPaint = Paint()
      ..color = AppColors.borderDefault
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
  }

  void updateElectrode(Electrode newElectrode) {
    electrode = newElectrode;
    _paint.color = ElectrodeColors.metalFill[electrode.symbol] ?? Colors.grey;
  }

  @override
  void render(Canvas canvas) {
    // Electrode bar
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    canvas.drawRect(rect, _paint);
    canvas.drawRect(rect, _borderPaint);

    // Label
    final textPainter = TextPainter(
      text: TextSpan(
        text: electrode.symbol,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: 'JetBrains Mono',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    
    textPainter.paint(
      canvas, 
      Offset((size.x - textPainter.width) / 2, size.y + 5),
    );
  }

  Vector2 get wireConnectionPoint => position + Vector2(size.x / 2, 0);
}

class AnodeComponent extends ElectrodeComponent {
  AnodeComponent({required super.position, required super.electrode})
      : super(isAnode: true);
}

class CathodeComponent extends ElectrodeComponent {
  CathodeComponent({required super.position, required super.electrode})
      : super(isAnode: false);
}
