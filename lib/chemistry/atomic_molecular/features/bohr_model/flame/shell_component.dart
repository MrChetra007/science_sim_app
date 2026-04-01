import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ShellComponent extends PositionComponent {
  final int shellIndex;
  final int electronCount;
  final double radius;
  final Vector2 center;
  final Color color;

  bool _excited = false;
  double _exciteTimer = 0.0;
  List<double> _angles = [];

  ShellComponent({
    required this.shellIndex,
    required this.electronCount,
    required this.radius,
    required this.center,
    required this.color,
  }) {
    // Distribute electrons evenly around the circle
    _angles = List.generate(electronCount, (i) => (2 * pi * i) / electronCount);
  }

  // Speed varies by shell — inner shells orbit faster
  double get _orbitSpeed => pi * (0.6 / (shellIndex + 1));

  @override
  void update(double dt) {
    final speed = _excited ? _orbitSpeed * 4.0 : _orbitSpeed;
    for (int i = 0; i < _angles.length; i++) {
        _angles[i] += speed * dt;
    }

    if (_excited) {
      _exciteTimer -= dt;
      if (_exciteTimer <= 0) _excited = false;
    }
  }

  @override
  void render(Canvas canvas) {
    // Draw orbit ring
    final orbitPaint = Paint()
      ..color = color.withOpacity(_excited ? 0.4 : 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = _excited ? 1.5 : 1.0;

    if (!_excited) {
      canvas.drawCircle(center.toOffset(), radius, orbitPaint);
    } else {
      // Dashed orbit when excited
      _drawDashedCircle(canvas, center.toOffset(), radius, orbitPaint);
    }

    // Draw electrons
    for (final angle in _angles) {
      final ex = center.x + radius * cos(angle);
      final ey = center.y + radius * sin(angle);

      if (_excited) {
        // Excited glow
        final glowPaint = Paint()..color = color.withOpacity(0.2);
        canvas.drawCircle(Offset(ex, ey), 10, glowPaint);
      }

      final ePaint = Paint()..color = _excited ? color : color.withOpacity(0.9);
      canvas.drawCircle(Offset(ex, ey), _excited ? 6.0 : 5.0, ePaint);
    }
  }

  void triggerExcitation() {
    _excited = true;
    _exciteTimer = 3.0;
  }

  void _drawDashedCircle(Canvas canvas, Offset center, double r, Paint paint) {
    const dashCount = 32;
    for (int i = 0; i < dashCount; i++) {
      if (i % 2 == 0) continue;
      final startA = (2 * pi * i) / dashCount;
      final endA   = (2 * pi * (i + 1)) / dashCount;
      final path = Path()
        ..moveTo(center.dx + r * cos(startA), center.dy + r * sin(startA))
        ..arcTo(Rect.fromCircle(center: center, radius: r), startA, endA - startA, false);
      canvas.drawPath(path, paint);
    }
  }
}
