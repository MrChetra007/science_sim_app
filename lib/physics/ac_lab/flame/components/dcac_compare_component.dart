import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../ac_game.dart';

class DCAcCompareComponent extends Component with HasGameReference<ACGame> {
  Vector2 size = Vector2.zero();
  Vector2 position = Vector2.zero();

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(position.x, position.y);

    final midX = size.x / 2;
    final midY = size.y / 2;
    final paintDC = Paint()..color = Colors.green..strokeWidth = 2..style = PaintingStyle.stroke;
    final paintAC = Paint()..color = Colors.amber..strokeWidth = 2..style = PaintingStyle.stroke;
    final labelStyle = const TextStyle(color: Colors.white60, fontSize: 10);
    
    // Draw divider
    canvas.drawLine(Offset(midX, 0), Offset(midX, size.y), Paint()..color = Colors.white10);

    // DC Side (Left)
    canvas.drawLine(Offset(size.x * 0.1, midY), Offset(size.x * 0.4, midY), paintDC);
    _drawText(canvas, "DC", Offset(size.x * 0.1, 10), labelStyle);

    // AC Side (Right)
    final acPath = Path();
    for (double i = 0; i < size.x * 0.4; i++) {
        double x = midX + size.x * 0.05 + i;
        double y = midY + (size.y * 0.2) * math.sin(i * 0.1);
        if (i == 0) {
          acPath.moveTo(x, y);
        } else {
          acPath.lineTo(x, y);
        }
    }
    canvas.drawPath(acPath, paintAC);
    _drawText(canvas, "AC", Offset(midX + size.x * 0.1, 10), labelStyle);

    canvas.restore();
  }

  void _drawText(Canvas canvas, String text, Offset offset, TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, offset);
  }
}
