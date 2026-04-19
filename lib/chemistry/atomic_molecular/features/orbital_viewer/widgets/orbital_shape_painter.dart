import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/models/orbital_model.dart';
import '../../../core/theme/app_colors.dart';

class OrbitalPainter extends CustomPainter {
  final OrbitalType type;
  final Color color;
  final double phase; // animation phase 0..2pi

  const OrbitalPainter({
    required this.type,
    required this.color,
    required this.phase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final scale = size.width * 0.4;

    switch (type) {
      case OrbitalType.s:
        _drawSOrbital(canvas, cx, cy, scale);
        break;
      case OrbitalType.px:
        _drawPOrbital(canvas, cx, cy, scale, axis: 'x');
        break;
      case OrbitalType.py:
        _drawPOrbital(canvas, cx, cy, scale, axis: 'y');
        break;
      case OrbitalType.pz:
        _drawPOrbital(canvas, cx, cy, scale, axis: 'z');
        break;
      case OrbitalType.dxy:
        _drawDOrbital(canvas, cx, cy, scale, rotated: true);
        break;
      case OrbitalType.dx2y2:
        _drawDOrbital(canvas, cx, cy, scale, rotated: false);
        break;
      case OrbitalType.dz2:
        _drawDZ2Orbital(canvas, cx, cy, scale);
        break;
      default:
        _drawSOrbital(canvas, cx, cy, scale);
    }
  }

  void _drawSOrbital(Canvas canvas, double cx, double cy, double scale) {
    final pulse = scale * (1.0 + 0.05 * sin(phase));
    
    final fill = Paint()
      ..shader = RadialGradient(
        colors: [color.withOpacity(0.4), color.withOpacity(0.0)],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: pulse));
    
    final border = Paint()
      ..color = color.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    canvas.drawCircle(Offset(cx, cy), pulse, fill);
    canvas.drawCircle(Offset(cx, cy), pulse, border);
  }

  void _drawPOrbital(Canvas canvas, double cx, double cy, double scale, {required String axis}) {
    final lobeR = scale * 0.7;
    final offset = lobeR * 0.85;

    canvas.save();
    canvas.translate(cx, cy);
    if (axis == 'x') canvas.rotate(pi / 2);
    if (axis == 'z') canvas.rotate(pi / 4); // stylized projection

    // Upper/Right lobe (Positive phase)
    _drawLobe(canvas, Offset(0, -offset), lobeR, color.withOpacity(0.4), true);
    // Lower/Left lobe (Negative phase)
    _drawLobe(canvas, Offset(0, offset), lobeR, color.withOpacity(0.15), false);

    canvas.restore();
    
    // Nodal line
    final nodePaint = Paint()..color = AppColors.textHint..strokeWidth = 1.0;
    if (axis == 'y') canvas.drawLine(Offset(cx - scale, cy), Offset(cx + scale, cy), nodePaint);
    if (axis == 'x') canvas.drawLine(Offset(cx, cy - scale), Offset(cx, cy + scale), nodePaint);
  }

  void _drawDOrbital(Canvas canvas, double cx, double cy, double scale, {required bool rotated}) {
    final lobeR = scale * 0.6;
    final angle = rotated ? pi / 4 : 0.0;

    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(angle);

    for (int i = 0; i < 4; i++) {
        final rot = (i * pi / 2);
        canvas.save();
        canvas.rotate(rot);
        final isPositive = i % 2 == 0;
        _drawLobe(canvas, Offset(0, -scale * 0.7), lobeR, 
            isPositive ? color.withOpacity(0.4) : color.withOpacity(0.15), isPositive);
        canvas.restore();
    }
    canvas.restore();
  }

  void _drawDZ2Orbital(Canvas canvas, double cx, double cy, double scale) {
    final lobeR = scale * 0.65;
    
    // Lobes along Z axis (Vertical in 2D)
    _drawLobe(canvas, Offset(cx, cy - scale * 0.7), lobeR * 0.9, color.withOpacity(0.4), true);
    _drawLobe(canvas, Offset(cx, cy + scale * 0.7), lobeR * 0.9, color.withOpacity(0.4), true);

    // Torus (donut) in the middle
    final torusPaint = Paint()
      ..color = color.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = scale * 0.18;
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: scale * 1.4, height: scale * 0.4), torusPaint);
    
    final torusBorder = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: scale * 1.4, height: scale * 0.4), torusBorder);
  }

  void _drawLobe(Canvas canvas, Offset pos, double r, Color c, bool solid) {
    final paint = Paint()..color = c;
    final rect = Rect.fromCenter(center: pos, width: r, height: r * 1.5);
    canvas.drawOval(rect, paint);
    
    final border = Paint()
      ..color = color.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = solid ? 1.5 : 1.0;
    
    if (!solid) {
       // Dashed border logic could go here, or just a thinner line
       border.strokeWidth = 0.8;
       border.color = color.withOpacity(0.4);
    }
    canvas.drawOval(rect, border);
  }

  @override
  bool shouldRepaint(OrbitalPainter old) => old.phase != phase || old.type != type;
}
