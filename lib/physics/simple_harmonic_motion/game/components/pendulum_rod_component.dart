import 'dart:ui';
import 'package:flame/components.dart';

class PendulumRodComponent extends PositionComponent {
  final Paint _rodPaint = Paint()
    ..color = const Color(0xFF78909C)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.5;
  final Paint _pivotPaint = Paint()..color = const Color(0xFFB0BEC5);

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

    canvas.drawCircle(Offset(pivotX, pivotY), 6, _pivotPaint);
  }
}
