import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../ac_game.dart';

class TransformerComponent extends Component with HasGameReference<ACGame> {
  Vector2 size = Vector2.zero();
  Vector2 position = Vector2.zero();

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(position.x, position.y);

    final p = game.provider;
    final state = p.state;
    
    // 1. Draw Iron Core (Magnetic Path)
    _drawCore(canvas);

    // 2. Draw Primary Coil (Input)
    _drawCoil(
      canvas, 
      Offset(size.x * 0.25, size.y * 0.3), 
      size.x * 0.1, 
      p.primaryTurns, 
      Colors.amber,
      state.vt / p.state.vp // Intensity based on voltage
    );

    // 3. Draw Secondary Coil (Output)
    _drawCoil(
      canvas, 
      Offset(size.x * 0.75, size.y * 0.3), 
      size.x * 0.1, 
      p.secondaryTurns, 
      Colors.cyan,
      (state.vt * p.turnsRatio) / p.secondaryVp // Intensity based on secondary voltage
    );

    // 4. Draw Magnetic Flux (Pulsing center lines)
    _drawFlux(canvas, state.vt / p.state.vp);

    canvas.restore();
  }

  void _drawCore(Canvas canvas) {
    final corePaint = Paint()
      ..color = const Color(0xFF2C3E50)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25.0;
    
    final coreRect = Rect.fromLTWH(
      size.x * 0.2, 
      size.y * 0.2, 
      size.x * 0.6, 
      size.y * 0.6
    );
    canvas.drawRect(coreRect, corePaint);
    
    // Add some metallic texture/lines
    final detailPaint = Paint()..color = Colors.white10..strokeWidth = 1;
    canvas.drawRect(coreRect.deflate(5), detailPaint);
  }

  void _drawCoil(Canvas canvas, Offset top, double width, int turns, Color color, double intensity) {
    final coilPaint = Paint()
      ..color = color.withValues(alpha: 0.3 + 0.7 * intensity.abs())
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final numWindings = (turns / 10).clamp(5, 40).toInt();
    final step = (size.y * 0.4) / numWindings;

    for (int i = 0; i < numWindings; i++) {
        final y = top.dy + (i * step);
        final path = Path()
          ..moveTo(top.dx - width / 2, y)
          ..quadraticBezierTo(top.dx + width / 2, y + step/2, top.dx - width / 2, y + step);
        canvas.drawPath(path, coilPaint);
    }
  }

  void _drawFlux(Canvas canvas, double intensity) {
    final fluxPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1 + 0.3 * intensity.abs())
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    
    final fluxRect = Rect.fromLTWH(
      size.x * 0.25, 
      size.y * 0.25, 
      size.x * 0.5, 
      size.y * 0.5
    );
    
    // Draw pulsing loop
    canvas.drawRect(fluxRect, fluxPaint);
  }
}
