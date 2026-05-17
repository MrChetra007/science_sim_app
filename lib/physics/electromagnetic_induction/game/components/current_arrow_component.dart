import 'dart:math' as math;
import 'dart:ui';
import 'package:flame/components.dart';

class CurrentArrowComponent extends PositionComponent {
  double _emf = 0;

  CurrentArrowComponent() {
    anchor = Anchor.center;
  }

  void updateEMF(double emf) {
    _emf = emf;
  }

  @override
  void render(Canvas canvas) {
    if (_emf.abs() < 0.01) return;

    final opacity = (_emf.abs() * 0.3).clamp(0.2, 1.0);
    final cw = _emf > 0;

    final paint = Paint()
      ..color = Color.fromRGBO(255, 193, 7, opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    const r = 24.0;
    const pi = math.pi;

    final topPath = Path();
    if (cw) {
      topPath.addArc(
        Rect.fromCircle(center: Offset(-8, -size.y / 2 - 10), radius: r),
        0,
        1.5 * pi,
      );
    } else {
      topPath.addArc(
        Rect.fromCircle(center: Offset(8, -size.y / 2 - 10), radius: r),
        pi,
        1.5 * pi,
      );
    }
    canvas.drawPath(topPath, paint);

    final bottomPath = Path();
    if (cw) {
      bottomPath.addArc(
        Rect.fromCircle(center: Offset(8, size.y / 2 + 10), radius: r),
        pi,
        1.5 * pi,
      );
    } else {
      bottomPath.addArc(
        Rect.fromCircle(center: Offset(-8, size.y / 2 + 10), radius: r),
        0,
        1.5 * pi,
      );
    }
    canvas.drawPath(bottomPath, paint);
  }
}
