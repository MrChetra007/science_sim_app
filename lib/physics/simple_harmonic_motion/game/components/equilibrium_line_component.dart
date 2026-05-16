import 'dart:ui';
import 'package:flame/components.dart';

class EquilibriumLineComponent extends PositionComponent {
  final Paint _linePaint = Paint()
    ..color = const Color(0xFF546E7A)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;

  double leftPad = 0;

  @override
  void render(Canvas canvas) {
    final w = size.x;
    final cy = size.y / 2;
    final dashWidth = 8.0;
    final dashSpace = 6.0;
    double startX = 16;

    while (startX < w - 16) {
      canvas.drawLine(
        Offset(startX, cy),
        Offset((startX + dashWidth).clamp(16, w - 16), cy),
        _linePaint,
      );
      startX += dashWidth + dashSpace;
    }
  }
}
