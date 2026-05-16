import 'dart:ui';
import 'package:flame/components.dart';

class SpringComponent extends PositionComponent {
  final Paint _ceilingPaint = Paint()..color = const Color(0xFF37474F);
  final Paint _coilPaint = Paint()
    ..color = const Color(0xFF90A4AE)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3.0;

  double restLength = 300.0;
  double stretchedLength = 300.0;
  double ceilingY = 40.0;
  double centerX = 0.0;
  int coilCount = 12;
  double displacement = 0;

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(centerX - 60, ceilingY, 120, 16),
      _ceilingPaint,
    );

    final ratio = restLength > 0 ? stretchedLength / restLength : 1.0;
    _coilPaint.color = ratio > 1.05
        ? const Color(0xFFEF5350)
        : ratio < 0.95
            ? const Color(0xFF42A5F5)
            : const Color(0xFF90A4AE);

    final path = Path();
    final coils = coilCount;
    final pitch = stretchedLength / coils;
    final halfWidth = 30.0;

    path.moveTo(centerX, ceilingY + 16);

    for (int i = 0; i < coils; i++) {
      final y0 = ceilingY + 16 + i * pitch;
      final y1 = y0 + pitch;
      path.quadraticBezierTo(
        centerX + halfWidth,
        y0 + pitch * 0.25,
        centerX,
        y0 + pitch * 0.5,
      );
      path.quadraticBezierTo(
        centerX - halfWidth,
        y0 + pitch * 0.75,
        centerX,
        y1,
      );
    }

    canvas.drawPath(path, _coilPaint);
  }

  void updateStretch(double newLength) {
    stretchedLength = newLength;
  }
}
