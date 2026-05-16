import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';

class VectorArrowComponent extends PositionComponent {
  bool visible = true;

  double velocity = 0;
  double acceleration = 0;
  double force = 0;
  double arrowScale = 50.0;

  @override
  void render(Canvas canvas) {
    if (!visible) return;

    final cx = position.x;
    final cy = position.y;

    if (velocity.abs() > 0.01) {
      _drawArrow(canvas, cx, cy, 0, -velocity * arrowScale, const Color(0xFFFFA000), 'v');
    }
    if (acceleration.abs() > 0.01) {
      _drawArrow(canvas, cx, cy, 0, -acceleration * arrowScale, const Color(0xFF00E5FF), 'a');
    }
    if (force.abs() > 0.01) {
      _drawArrow(canvas, cx, cy, 0, -force * arrowScale, const Color(0xFFFF0000), 'F');
    }
  }

  void _drawArrow(Canvas canvas, double x, double y, double dx, double dy, Color color, String label) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final endX = x + dx;
    final endY = y + dy;
    canvas.drawLine(Offset(x, y), Offset(endX, endY), paint);

    final angle = atan2(dy, dx);
    const arrowSize = 8.0;
    canvas.drawPath(
      Path()
        ..moveTo(endX, endY)
        ..lineTo(endX - arrowSize * cos(angle - pi / 6), endY - arrowSize * sin(angle - pi / 6))
        ..moveTo(endX, endY)
        ..lineTo(endX - arrowSize * cos(angle + pi / 6), endY - arrowSize * sin(angle + pi / 6)),
      paint,
    );

    canvas.drawCircle(Offset(x, y), 2, Paint()..color = color);
  }
}
