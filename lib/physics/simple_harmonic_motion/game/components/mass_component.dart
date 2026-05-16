import 'dart:ui';
import 'package:flame/components.dart';

class MassComponent extends PositionComponent {
  final Paint _fillPaint = Paint()..color = const Color(0xFFFF6F00);
  final Paint _glowPaint = Paint()
    ..color = const Color(0xFFFF6F00).withValues(alpha: 0.3)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
  final Paint _borderPaint = Paint()
    ..color = const Color(0xFFFF8F00)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  double massValue = 0.5;
  double blockWidth = 80;
  double blockHeight = 40;
  double equilibriumY = 0.0;
  bool isGrabbed = false;
  double velocity = 0;
  List<Offset> trailDots = [];

  @override
  void render(Canvas canvas) {
    final cx = position.x;
    final cy = position.y;
    final speed = velocity.abs();
    final glowRadius = 8 + (speed * 30).clamp(0, 24).toDouble();

    _glowPaint.maskFilter = MaskFilter.blur(BlurStyle.normal, glowRadius);
    _glowPaint.color = const Color(0xFFFF6F00).withValues(alpha: (0.15 + speed * 2).clamp(0.15, 0.5).toDouble());

    canvas.drawCircle(Offset(cx, cy), blockWidth / 2, _glowPaint);

    for (final dot in trailDots) {
      canvas.drawCircle(dot, 2, Paint()..color = const Color(0xFFFF6F00).withValues(alpha: 0.3));
    }

    final rrect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cx, cy),
        width: blockWidth,
        height: blockHeight,
      ),
      const Radius.circular(8),
    );

    canvas.drawRRect(rrect, _fillPaint);

    if (isGrabbed) {
      canvas.drawRRect(rrect, _borderPaint);
    }

    final textStyle = TextStyle(
      color: const Color(0xFFFFFFFF),
      fontSize: 14,
    );
    final tp = ParagraphBuilder(ParagraphStyle(textAlign: TextAlign.center))
      ..pushStyle(textStyle)
      ..addText('${massValue.toStringAsFixed(1)} kg');
    final paragraph = tp.build()..layout(const ParagraphConstraints(width: 80));
    canvas.drawParagraph(
      paragraph,
      Offset(cx - blockWidth / 2, cy - 8),
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
