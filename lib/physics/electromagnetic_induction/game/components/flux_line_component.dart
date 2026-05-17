import 'dart:ui';
import 'package:flame/components.dart';

class FluxLineComponent extends PositionComponent {
  double _flux = 0;
  double _magnetLocalY = 0;

  void updateFlux(double flux, double localMagnetY) {
    _flux = flux;
    _magnetLocalY = localMagnetY;
  }

  @override
  void render(Canvas canvas) {
    _drawFieldLines(canvas);
  }

  void _drawFieldLines(Canvas canvas) {
    final cx = size.x / 2;
    final cy = _magnetLocalY;
    const poleHalf = 50.0;
    final nY = cy - poleHalf;
    final sY = cy + poleHalf;
    final alpha = (_flux.abs() * 255).clamp(20, 220).toInt();

    if (alpha < 10) return;

    const lineDefs = [
      [0.0, 0.0, 0.0],
      [0.4, 0.5, 0.2],
      [0.9, 0.7, 0.4],
      [1.5, 0.8, 0.6],
      [2.2, 0.9, 0.8],
    ];

    for (final def in lineDefs) {
      final spread = def[0] * 50;
      final c1x = -spread;
      final c2x = -spread * 0.6;
      _drawOneLine(canvas, cx, nY, sY, c1x, c2x, alpha);
      if (def[0] > 0) {
        _drawOneLine(canvas, cx, nY, sY, -c1x, -c2x, alpha);
      }
    }

    final glowAlpha = (alpha * 0.5).toInt();
    for (final def in lineDefs) {
      final spread = def[0] * 50;
      final c1x = -spread;
      final c2x = -spread * 0.6;
      _drawOneLine(canvas, cx, nY, sY, c1x, c2x, glowAlpha, 4.0);
      if (def[0] > 0) {
        _drawOneLine(canvas, cx, nY, sY, -c1x, -c2x, glowAlpha, 4.0);
      }
    }
  }

  void _drawOneLine(
    Canvas canvas,
    double cx,
    double nY,
    double sY,
    double c1x,
    double c2x,
    int alpha, [
    double width = 2.0,
  ]) {
    final paint = Paint()
      ..color = Color.fromARGB(alpha.clamp(0, 255), 66, 165, 245)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    final path = Path()
      ..moveTo(cx + c1x * 0.1, nY)
      ..cubicTo(
        cx + c1x,
        nY + (sY - nY) * 0.25,
        cx + c2x,
        sY - (sY - nY) * 0.25,
        cx + c1x * 0.1,
        sY,
      );
    canvas.drawPath(path, paint);
  }
}
