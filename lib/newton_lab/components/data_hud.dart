import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'physics_body.dart';
import '../core/constants.dart';

class DataHUD extends PositionComponent {
  final PhysicsBody target;

  DataHUD({
    required this.target,
    super.position,
  });

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final String text = '''
v: ${target.velocity.length.toStringAsFixed(1)} m/s
a: ${target.acceleration.length.toStringAsFixed(1)} m/s²
F: ${target.netForce.length.toStringAsFixed(1)} N
    '''.trim();

    textPainter.text = TextSpan(
      text: text,
      style: const TextStyle(
        color: AppColors.primaryAccent,
        fontSize: 12,
        fontFamily: 'JetBrains Mono', // Monospaced font
        backgroundColor: Colors.black54, // Slight dark background for readability
      ),
    );

    textPainter.layout();
    textPainter.paint(canvas, Offset.zero);
  }
}
