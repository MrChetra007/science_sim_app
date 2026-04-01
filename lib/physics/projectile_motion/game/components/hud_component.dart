import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import '../projectile_game.dart';

/// Heads-Up Display — shows gravity, planet, object info on the canvas.
class HudComponent extends Component {
  final ProjectileGame game;
  HudComponent({required this.game});

  @override
  void render(Canvas canvas) {
    _drawTopLeft(canvas);
    _drawTopRight(canvas);
  }

  void _drawTopLeft(Canvas canvas) {
    // Planet / gravity info
    final gravText = 'g = ${game.gravityValue.toStringAsFixed(2)} m/s²';
    final planetText = game.planetName;

    _drawPill(canvas, 12, 12, '$planetText  $gravText', const Color(0xFF00BCD4),
        const Color(0xFF0A2535));
  }

  void _drawTopRight(Canvas canvas) {
    final w = game.size.x;
    final objText = game.objectName;
    final massText = 'mass: ${game.objectMass.toStringAsFixed(2)} kg';

    _drawPillRight(canvas, w - 12, 12, '$objText  $massText',
        const Color(0xFFFFD740), const Color(0xFF29200A));
  }

  void _drawPill(Canvas canvas, double x, double y, String text,
      Color textColor, Color bgColor) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final pad = 8.0;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(x, y, tp.width + pad * 2, tp.height + pad),
      const Radius.circular(20),
    );
    canvas.drawRRect(rect, Paint()..color = bgColor);
    canvas.drawRRect(
        rect,
        Paint()
          ..color = textColor.withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1);
    tp.paint(canvas, Offset(x + pad, y + pad / 2));
  }

  void _drawPillRight(Canvas canvas, double rightEdge, double y, String text,
      Color textColor, Color bgColor) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    const pad = 8.0;
    final x = rightEdge - tp.width - pad * 2;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(x, y, tp.width + pad * 2, tp.height + pad),
      const Radius.circular(20),
    );
    canvas.drawRRect(rect, Paint()..color = bgColor);
    canvas.drawRRect(
        rect,
        Paint()
          ..color = textColor.withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1);
    tp.paint(canvas, Offset(x + pad, y + pad / 2));
  }
}
