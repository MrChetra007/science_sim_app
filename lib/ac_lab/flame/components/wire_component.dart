import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../ac_game.dart';

class WireComponent extends Component with HasGameReference<ACGame> {
  Vector2 size = Vector2.zero();
  Vector2 position = Vector2.zero();

  final List<ElectronParticle> electrons = [];
  static const int electronCount = 20;

  @override
  Future<void> onLoad() async {
    for (int i = 0; i < electronCount; i++) {
      electrons.add(ElectronParticle(
        baseX: i / electronCount,
        phase: math.Random().nextDouble() * math.pi * 2,
      ));
    }
  }

  double lastVt = 0;
  double flashIntensity = 0;

  @override
  void update(double dt) {
    final state = game.provider.state;
    // Detect zero-crossing (sign change)
    if (lastVt.sign != state.vt.sign && lastVt != 0) {
        flashIntensity = 1.0;
        game.provider.triggerZeroCrossingHaptic();
    }
    lastVt = state.vt;

    if (flashIntensity > 0) {
        flashIntensity -= dt * 5; // Fade out quickly
        if (flashIntensity < 0) flashIntensity = 0;
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(position.x, position.y);

    final wirePaint = Paint()
      ..color = const Color(0xFF1E3A55)
      ..style = PaintingStyle.fill;
    
    // Draw wire body
    final wireRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(size.x * 0.1, size.y * 0.4, size.x * 0.8, size.y * 0.2),
        const Radius.circular(8),
    );
    canvas.drawRRect(wireRect, wirePaint);

    // Draw zero-crossing flash
    if (flashIntensity > 0) {
        final flashPaint = Paint()
          ..color = Colors.white.withValues(alpha: flashIntensity * 0.4)
          ..style = PaintingStyle.fill;
        canvas.drawRRect(wireRect, flashPaint);
    }

    // Draw electrons
    final state = game.provider.state;
    final electronPaint = Paint()..color = Colors.cyan;
    final glowPaint = Paint()
      ..color = Colors.cyan.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    for (final e in electrons) {
      // Calculate oscillation displacement
      final amplitude = size.x * 0.05 * state.brightness;
      final dx = amplitude * math.sin(state.omega * state.time + e.phase);
      final x = size.x * 0.1 + (size.x * 0.8 * e.baseX) + dx;
      final y = size.y * 0.5;

      canvas.drawCircle(Offset(x, y), 5, glowPaint);
      canvas.drawCircle(Offset(x, y), 3, electronPaint);
    }

    canvas.restore();
  }
}

class ElectronParticle {
  final double baseX;
  final double phase;
  ElectronParticle({required this.baseX, required this.phase});
}
