import 'package:flutter/painting.dart';
import 'package:flame/components.dart';

class MagnetComponent extends PositionComponent {
  final void Function()? onDragStartCallback;
  final void Function(double deltaY) onDragUpdateCallback;
  final void Function()? onDragEndCallback;

  bool _isDragging = false;

  MagnetComponent({
    this.onDragStartCallback,
    required this.onDragUpdateCallback,
    this.onDragEndCallback,
  }) {
    anchor = Anchor.center;
  }

  @override
  void render(Canvas canvas) {
    final w = size.x;
    final h = size.y;
    final poleW = w / 2;

    if (_isDragging) {
      canvas.drawRect(
        Rect.fromLTWH(-4, -4, w + 8, h + 8),
        Paint()
          ..color = const Color(0x44FFFFFF)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }

    final nRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, poleW, h),
      const Radius.circular(4),
    );
    final sRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(poleW, 0, poleW, h),
      const Radius.circular(4),
    );

    canvas.drawRRect(
      nRect,
      Paint()..color = const Color(0xFFE53935),
    );
    canvas.drawRRect(
      sRect,
      Paint()..color = const Color(0xFF1E88E5),
    );

    _drawLabel(canvas, 'N', Offset(poleW / 2, h / 2), 18);
    _drawLabel(canvas, 'S', Offset(poleW * 1.5, h / 2), 18);
  }

  void _drawLabel(Canvas canvas, String text, Offset center, double fontSize) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: const Color(0xFFFFFFFF),
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  void updateEmf(double emf) {}

  void setIsDragging(bool v) {
    _isDragging = v;
  }
}
