import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import '../../../core/models/vsepr_shape.dart';
import '../../../core/theme/app_colors.dart';

class GeometryPainter extends CustomPainter {
  final VseprShape shape;
  final Matrix4 rotation;
  final double scale;

  const GeometryPainter({
    required this.shape,
    required this.rotation,
    required this.scale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Transform all bond directions
    final List<_ProjectedPoint> projectedBonds = shape.bondDirections.map((dir) {
      final dir4 = Vector4(dir.x * scale, dir.y * scale, dir.z * scale, 0);
      final rotated = rotation.transform(dir4);
      return _ProjectedPoint(
        pos: Offset(center.dx + rotated.x, center.dy - rotated.y),
        depth: rotated.z,
        isLonePair: false,
      );
    }).toList();

    // Transform all lone pair directions
    final List<_ProjectedPoint> projectedLonePairs = (shape.lonePairDirections ?? []).map((dir) {
      final dir4 = Vector4(dir.x * scale * 0.9, dir.y * scale * 0.9, dir.z * scale * 0.9, 0);
      final rotated = rotation.transform(dir4);
      return _ProjectedPoint(
        pos: Offset(center.dx + rotated.x, center.dy - rotated.y),
        depth: rotated.z,
        isLonePair: true,
      );
    }).toList();

    final allPoints = [...projectedBonds, ...projectedLonePairs];
    allPoints.sort((a, b) => a.depth.compareTo(b.depth));

    // Draw central atom shadow
    canvas.drawCircle(center + const Offset(2, 2), 22, Paint()..color = Colors.black26..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));

    // Draw bonds and lone pairs
    for (final point in allPoints) {
      if (point.isLonePair) {
        _drawLonePairCloud(canvas, center, point.pos);
      } else {
        _drawBondStick(canvas, center, point.pos);
      }
    }

    // Draw terminal atoms for bonds
    for (final point in projectedBonds) {
        _drawTerminalAtom(canvas, point.pos);
    }

    // Draw central atom
    _drawCentralAtom(canvas, center);
  }

  void _drawBondStick(Canvas canvas, Offset start, Offset end) {
    final paint = Paint()
      ..color = AppColors.borderAccent.withOpacity(0.6)
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(start, end, paint);
  }

  void _drawTerminalAtom(Canvas canvas, Offset pos) {
    final paint = Paint()..color = AppColors.orbitalS;
    canvas.drawCircle(pos, 14, paint);

    // Highlight
    final highlight = Paint()..color = Colors.white.withOpacity(0.3);
    canvas.drawCircle(pos - const Offset(4, 4), 5, highlight);
  }

  void _drawLonePairCloud(Canvas canvas, Offset center, Offset pos) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [AppColors.orbitalP.withOpacity(0.4), AppColors.orbitalP.withOpacity(0.0)],
      ).createShader(Rect.fromCircle(center: pos, radius: 30));
    
    // Draw an elongated cloud towards the center
    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    final angle = atan2(pos.dy - center.dy, pos.dx - center.dx);
    canvas.rotate(angle + pi / 2);
    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: 35, height: 50), paint);
    canvas.restore();

    // Lone pair dots
    final dotPaint = Paint()..color = AppColors.orbitalP.withOpacity(0.8);
    canvas.drawCircle(pos + const Offset(-6, 0), 3, dotPaint);
    canvas.drawCircle(pos + const Offset(6, 0), 3, dotPaint);
  }

  void _drawCentralAtom(Canvas canvas, Offset center) {
    final paint = Paint()..color = AppColors.bgHighlight;
    canvas.drawCircle(center, 22, paint);

    final borderPaint = Paint()
      ..color = AppColors.orbitalP.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, 22, borderPaint);

    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'A',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, center - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  @override
  bool shouldRepaint(GeometryPainter old) => old.rotation != rotation || old.shape != shape;
}

class _ProjectedPoint {
  final Offset pos;
  final double depth;
  final bool isLonePair;
  _ProjectedPoint({required this.pos, required this.depth, required this.isLonePair});
}
