import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';

class CoilComponent extends PositionComponent {
  int turns;
  double _animPhase = 0;
  double _emf = 0;

  CoilComponent({this.turns = 10}) {
    anchor = Anchor.center;
  }

  void tick(double dt, double emf) {
    _emf = emf;
    _animPhase += dt * emf.abs() * 4;
    if (_animPhase > pi * 2) _animPhase -= pi * 2;
  }

  @override
  void render(Canvas canvas) {
    final span = size.x;
    final loopH = size.y;
    const loopW = 14.0;
    final spacing = span / max(turns, 1);
    final startX = -span / 2;

    final backPaint = Paint()
      ..color = const Color(0xFF8B4513)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final frontPaint = Paint()
      ..color = const Color(0xFFD2691E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final glowColor = _emf > 0.01
        ? const Color(0x55FF1744)
        : (_emf < -0.01 ? const Color(0x552966FF) : null);

    for (int i = 0; i < turns; i++) {
      final cx = startX + i * spacing + spacing / 2;
      final rect = Rect.fromCenter(
        center: Offset(cx, 0),
        width: loopW,
        height: loopH,
      );

      canvas.drawArc(rect, pi, pi, false, backPaint);
      canvas.drawArc(rect, 0, pi, false, frontPaint);

      if (_emf.abs() > 0.01) {
        _drawCurrentDots(canvas, cx, rect);
      }
    }

    if (glowColor != null) {
      _drawCoilGlow(canvas, span, loopH, glowColor);
    }
  }

  void _drawCoilGlow(Canvas canvas, double span, double loopH, Color color) {
    final baseAlpha = color.a * 255;
    for (int i = 0; i < 3; i++) {
      final a = (baseAlpha * (0.3 - i * 0.08)).round().clamp(0, 255);
      final glowPaint = Paint()
        ..color = Color.fromARGB(a, color.r.toInt(), color.g.toInt(), color.b.toInt())
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8 + i * 6);

      final margin = span * 0.05;
      final glowRect = Rect.fromCenter(
        center: const Offset(0, 0),
        width: span + margin * 2,
        height: loopH + margin * 2,
      );
      canvas.drawOval(glowRect, glowPaint);
    }
  }

  void _drawCurrentDots(Canvas canvas, double cx, Rect rect) {
    final cw = _emf > 0;
    const count = 2;
    final rw = rect.width / 2;
    final rh = rect.height / 2;

    for (int j = 0; j < count; j++) {
      final offset = (j / count) * pi * 2;
      double angle = _animPhase + offset;
      if (!cw) angle = -angle;
      angle = angle % (pi * 2);

      final dotX = cx + rw * cos(angle);
      final dotY = rh * sin(angle);

      final dotAlpha = (_emf.abs() * 200).clamp(40, 220);
      final dotPaint = Paint()
        ..color = Color.fromARGB(dotAlpha.toInt(), 255, 202, 40)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(dotX, dotY), 2.5, dotPaint);
    }
  }
}
