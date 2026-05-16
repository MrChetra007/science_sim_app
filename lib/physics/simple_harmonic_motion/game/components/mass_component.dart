import 'dart:ui';
import 'package:flame/components.dart';

class MassComponent extends PositionComponent {
  static const Color _red = Color(0xFFFF3B30);
  static const Color _redDark = Color(0xFFCC2F26);

  final Paint _fillPaint = Paint()..color = _red;
  final Paint _glowPaint = Paint()
    ..color = _red.withValues(alpha: 0.3)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
  final Paint _shadowPaint = Paint()
    ..color = const Color(0x40000000)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

  double massValue = 0.5;
  double blockWidth = 50;
  double blockHeight = 50;
  bool isGrabbed = false;
  double velocity = 0;
  List<Offset> trailDots = [];

  MassComponent() : super(anchor: Anchor.center);

  @override
  void render(Canvas canvas) {
    final bw = blockWidth;
    final bh = blockHeight;
    final speed = velocity.abs();
    final glowRadius = 8 + (speed * 30).clamp(0, 24).toDouble();

    _glowPaint.maskFilter = MaskFilter.blur(BlurStyle.normal, glowRadius);
    _glowPaint.color = _red.withValues(alpha: (0.15 + speed * 2).clamp(0.15, 0.5).toDouble());
    canvas.drawCircle(Offset.zero, bw * 0.6, _glowPaint);

    for (final dot in trailDots) {
      canvas.drawCircle(dot - position.toOffset(), 2, Paint()..color = _red.withValues(alpha: 0.3));
    }

    final rect = Rect.fromCenter(center: Offset.zero, width: bw, height: bh);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(6));

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.shift(const Offset(2, 3)), const Radius.circular(6)),
      _shadowPaint,
    );

    canvas.drawRRect(rrect, _fillPaint);

    final edgeRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(bw * 0.15, bh * 0.35, bw * 0.4, bh * 0.4),
      const Radius.circular(3),
    );
    canvas.drawRRect(edgeRect, Paint()..color = _redDark.withValues(alpha: 0.35));

    final highlightShader = Gradient.linear(
      Offset(-bw * 0.35, -bh * 0.35),
      Offset(bw * 0.3, bh * 0.3),
      [const Color(0x55FFFFFF), const Color(0x00FFFFFF)],
    );
    canvas.drawRRect(rrect, Paint()..shader = highlightShader);

    canvas.drawRRect(
      rrect,
      Paint()
        ..color = const Color(0x66FFFFFF)
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
