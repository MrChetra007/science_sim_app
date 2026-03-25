import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../ac_game.dart';

class PhasorComponent extends Component with HasGameReference<ACGame> {
  Vector2 size = Vector2.zero();
  Vector2 position = Vector2.zero();

  final Paint circlePaint = Paint()
    ..color = Colors.white10
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;

  final Paint vPhasorPaint = Paint()
    ..color = Colors.amber
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3.0;

  final Paint iPhasorPaint = Paint()
    ..color = Colors.cyan
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  final Paint projectionPaint = Paint()
    ..color = Colors.white24
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(position.x, position.y);

    final cx = size.x / 2;
    final cy = size.y / 2;
    final radius = math.min(cx, cy) * 0.8;

    final state = game.provider.state;
    
    // Voltage Phasor Angle
    final vAngle = state.omega * state.time - math.pi / 2;
    // Current Phasor Angle (shifted by phi)
    final iAngle = vAngle - state.phi;

    // Radius for Current depends on I_rms relative to V_rms or just fixed ratio for vis
    final vRadius = radius;
    final iRadius = radius * 0.7; // Smaller for distinction

    // Draw reference circle
    canvas.drawCircle(Offset(cx, cy), radius, circlePaint);
    
    // Draw axes
    canvas.drawLine(Offset(cx - radius, cy), Offset(cx + radius, cy), circlePaint);
    canvas.drawLine(Offset(cx, cy - radius), Offset(cx, cy + radius), circlePaint);

    // Draw Current Phasor (I)
    _drawPhasor(canvas, cx, cy, iRadius, iAngle, iPhasorPaint, Colors.cyan);

    // Draw Voltage Phasor (V)
    _drawPhasor(canvas, cx, cy, vRadius, vAngle, vPhasorPaint, Colors.amber);

    // Draw Phase Angle Label if significant
    if (state.phi.abs() > 0.01) {
        final phiDeg = state.phi * 180 / math.pi;
        _drawText(canvas, "φ = ${phiDeg.toStringAsFixed(1)}°", Offset(cx + 10, cy + 10), const TextStyle(color: Colors.white60, fontSize: 10));
    }

    canvas.restore();
  }

  void _drawPhasor(Canvas canvas, double cx, double cy, double r, double angle, Paint paint, Color color) {
    final tipX = cx + r * math.cos(angle);
    final tipY = cy + r * math.sin(angle);

    // Projections
    canvas.drawLine(Offset(tipX, tipY), Offset(cx, tipY), projectionPaint);
    canvas.drawLine(Offset(tipX, tipY), Offset(tipX, cy), projectionPaint);

    // Main line
    canvas.drawLine(Offset(cx, cy), Offset(tipX, tipY), paint);
    
    // Tip dot
    canvas.drawCircle(Offset(tipX, tipY), 4, Paint()..color = color);
  }

  void _drawText(Canvas canvas, String text, Offset offset, TextStyle style) {
    final tp = TextPainter(text: TextSpan(text: text, style: style), textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, offset);
  }
}
