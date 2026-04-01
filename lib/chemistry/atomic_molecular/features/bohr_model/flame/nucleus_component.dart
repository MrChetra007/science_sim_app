import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../../core/models/element.dart';
import '../../../core/theme/app_colors.dart';

class NucleusComponent extends PositionComponent {
  final ChemElement element;

  NucleusComponent({required this.element, required Vector2 position})
      : super(position: position);

  double _pulsePhase = 0.0;

  @override
  void update(double dt) {
    _pulsePhase += dt * 1.8;
  }

  @override
  void render(Canvas canvas) {
    // Size based on atomic number
    final baseRadius = 14.0 + element.atomicNumber * 0.4;
    final pulse = sin(_pulsePhase) * 1.5;

    // Outer glow ring
    final glowPaint = Paint()
      ..color = AppColors.orbitalS.withOpacity(0.12)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, baseRadius + pulse + 10, glowPaint);

    // Nucleus fill
    final nucleusPaint = Paint()
      ..color = AppColors.bgElevated
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, baseRadius + pulse, nucleusPaint);

    // Nucleus border
    final borderPaint = Paint()
      ..color = AppColors.orbitalS.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(Offset.zero, baseRadius + pulse, borderPaint);

    // Element symbol
    final textPainter = TextPainter(
      text: TextSpan(
        text: element.symbol,
        style: TextStyle(
          fontSize: baseRadius * 0.75 + 4,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );

    // Atomic number (superscript top-right)
    final numPainter = TextPainter(
      text: TextSpan(
        text: '${element.atomicNumber}',
        style: const TextStyle(fontSize: 10, color: AppColors.orbitalS, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    numPainter.paint(canvas, Offset(baseRadius * 0.5, -baseRadius * 1.1));
  }
}
