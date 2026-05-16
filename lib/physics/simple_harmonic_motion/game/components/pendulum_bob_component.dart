import 'dart:ui';
import 'package:flame/components.dart';

class PendulumBobComponent extends PositionComponent {
  final Paint _fillPaint = Paint()..color = const Color(0xFF00E5FF);
  final Paint _glowPaint = Paint()
    ..color = const Color(0xFF00E5FF).withValues(alpha: 0.25)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14);

  double radius = 20.0;
  bool isGrabbed = false;
  double velocity = 0;
  List<Offset> trailDots = [];

  @override
  void render(Canvas canvas) {
    final cx = position.x;
    final cy = position.y;
    final speed = velocity.abs();
    final glowRadius = 8 + (speed * 30).clamp(0, 28).toDouble();

    _glowPaint.maskFilter = MaskFilter.blur(BlurStyle.normal, glowRadius);
    _glowPaint.color = const Color(0xFF00E5FF).withValues(alpha: (0.12 + speed * 2).clamp(0.12, 0.5).toDouble());

    canvas.drawCircle(Offset(cx, cy), radius + 8, _glowPaint);

    for (final dot in trailDots) {
      canvas.drawCircle(dot, 2, Paint()..color = const Color(0xFF00E5FF).withValues(alpha: 0.3));
    }

    canvas.drawCircle(Offset(cx, cy), radius, _fillPaint);
  }

  void updateTrail(double newVelocity, Offset newPos) {
    velocity = newVelocity;
    final speed = velocity.abs();
    if (speed > 0.05) {
      trailDots.add(newPos);
      if (trailDots.length > 8) trailDots.removeAt(0);
    } else {
      if (trailDots.isNotEmpty) trailDots.removeAt(0);
    }
  }
}
