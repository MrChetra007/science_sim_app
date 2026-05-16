import 'dart:ui';
import 'package:flame/components.dart';

class PendulumBobComponent extends PositionComponent {
  static const Color _red = Color(0xFFFF3B30);

  final Paint _glowPaint = Paint()
    ..color = _red.withValues(alpha: 0.25)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14);
  final Paint _shadowPaint = Paint()
    ..color = const Color(0x40000000)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

  double radius = 16.0;
  bool isGrabbed = false;
  double velocity = 0;
  List<Offset> trailDots = [];

  PendulumBobComponent() : super(anchor: Anchor.center);

  @override
  void render(Canvas canvas) {
    final r = radius;
    final speed = velocity.abs();
    final glowRadius = 6 + (speed * 30).clamp(0, 22).toDouble();

    _glowPaint.maskFilter = MaskFilter.blur(BlurStyle.normal, glowRadius);
    _glowPaint.color = _red.withValues(alpha: (0.12 + speed * 2).clamp(0.12, 0.5).toDouble());
    canvas.drawCircle(Offset.zero, r + 6, _glowPaint);

    for (final dot in trailDots) {
      canvas.drawCircle(dot - position.toOffset(), 2, Paint()..color = _red.withValues(alpha: 0.3));
    }

    canvas.drawCircle(const Offset(2, 3), r, _shadowPaint);
    canvas.drawCircle(Offset.zero, r, Paint()..color = _red);

    final highlightShader = Gradient.radial(
      Offset(-r * 0.3, -r * 0.3),
      r * 0.8,
      [const Color(0x66FFFFFF), const Color(0x00FFFFFF)],
    );
    canvas.drawCircle(Offset.zero, r, Paint()..shader = highlightShader);

    canvas.drawCircle(
      Offset.zero,
      r,
      Paint()
        ..color = const Color(0x44FFFFFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
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
