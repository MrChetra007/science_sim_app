import 'dart:ui';
import 'package:flame/components.dart';

class PendulumRodComponent extends PositionComponent {
  final Paint _rodPaint = Paint()
    ..color = const Color(0xFF78909C)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.5;
  final Paint _pivotOuterPaint = Paint()..color = const Color(0xFF546E7A);
  final Paint _pivotInnerPaint = Paint()..color = const Color(0xFFCFD8DC);
  final Paint _pivotHighlightPaint = Paint()..color = const Color(0x55FFFFFF);

  double pivotX = 0.0;
  double pivotY = 60.0;
  double bobX = 0.0;
  double bobY = 300.0;

  @override
  void render(Canvas canvas) {
    canvas.drawLine(
      Offset(pivotX, pivotY),
      Offset(bobX, bobY),
      _rodPaint,
    );

    canvas.drawCircle(Offset(pivotX, pivotY), 7, _pivotOuterPaint);
    canvas.drawCircle(Offset(pivotX, pivotY), 5, _pivotInnerPaint);
    canvas.drawCircle(Offset(pivotX - 1.5, pivotY - 1.5), 2, _pivotHighlightPaint);
  }
}
