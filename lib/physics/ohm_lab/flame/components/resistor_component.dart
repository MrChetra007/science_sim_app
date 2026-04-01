import 'dart:ui';
import 'package:flame/components.dart';

class ResistorComponent extends PositionComponent {
  ResistorComponent({
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size, anchor: Anchor.center);

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = const Color(0xFF00FF88)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    final stepX = size.x / 6;
    final centerY = size.y / 2;
    final amplitude = size.y / 2;

    path.moveTo(0, centerY);
    path.lineTo(stepX, centerY - amplitude);
    path.lineTo(stepX * 2, centerY + amplitude);
    path.lineTo(stepX * 3, centerY - amplitude);
    path.lineTo(stepX * 4, centerY + amplitude);
    path.lineTo(stepX * 5, centerY - amplitude);
    path.lineTo(size.x, centerY);

    canvas.drawPath(path, paint);

    // Glow
    final glowPaint = Paint()
      ..color = const Color(0xFF00FF88).withOpacity(0.3)
      ..strokeWidth = 8.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0)
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, glowPaint);
  }
}
