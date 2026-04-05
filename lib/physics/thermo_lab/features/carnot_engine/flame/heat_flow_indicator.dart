import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class HeatFlowIndicator extends PositionComponent with HasGameReference {
  final bool isIn; // true for Qin, false for Qout
  final Color color;
  double _opacity = 0.0;
  bool _active = false;

  HeatFlowIndicator({
    required this.isIn,
    required this.color,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  void setActive(bool active) => _active = active;

  @override
  void update(double dt) {
    super.update(dt);
    if (_active) {
      _opacity = (_opacity + dt * 2.0).clamp(0.0, 0.6);
    } else {
      _opacity = (_opacity - dt * 2.0).clamp(0.0, 0.6);
    }
  }

  @override
  void render(Canvas canvas) {
    if (_opacity <= 0) return;

    final paint = Paint()
      ..color = color.withValues(alpha: _opacity)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    final arrowH = size.y * 0.3;
    
    if (isIn) {
      // Arrow pointing IN (downwards)
      path.moveTo(size.x / 2, 0);
      path.lineTo(size.x / 2, size.y);
      path.lineTo(size.x / 2 - arrowH, size.y - arrowH);
      path.moveTo(size.x / 2, size.y);
      path.lineTo(size.x / 2 + arrowH, size.y - arrowH);
    } else {
      // Arrow pointing OUT (upwards)
      path.moveTo(size.x / 2, size.y);
      path.lineTo(size.x / 2, 0);
      path.lineTo(size.x / 2 - arrowH, arrowH);
      path.moveTo(size.x / 2, 0);
      path.lineTo(size.x / 2 + arrowH, arrowH);
    }

    canvas.drawPath(path, paint);
    
    // Label
    final textPainter = TextPainter(
      text: TextSpan(
        text: isIn ? 'Qin' : 'Qout',
        style: TextStyle(color: color.withValues(alpha: _opacity * 1.5), fontSize: 10, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    
    textPainter.paint(canvas, Offset(size.x / 2 + 10, size.y / 2 - 5));
  }
}
