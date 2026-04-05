import 'dart:math';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'entropy_particle.dart';
import '../providers/entropy_provider.dart';

class EntropyGame extends FlameGame {
  final WidgetRef ref;
  final List<EntropyParticle> _redParticles = [];
  final List<EntropyParticle> _blueParticles = [];
  double _resetKey = 0.0;
  final Random _rnd = Random();

  // Local state for UI
  final ValueNotifier<double> entropyNotifier = ValueNotifier(0.0);

  EntropyGame(this.ref);

  @override
  Future<void> onLoad() async {
    _initExperiment();
  }

  void _initExperiment() {
    _redParticles.forEach((p) => p.removeFromParent());
    _blueParticles.forEach((p) => p.removeFromParent());
    _redParticles.clear();
    _blueParticles.clear();
    
    final settings = ref.read(entropyProvider);
    _resetKey = settings.resetCounter;

    final wallX = size.x / 2;
    const count = 30; // 30 of each color
    
    // Left: Red
    for (int i = 0; i < count; i++) {
        final p = EntropyParticle(
          position: Vector2(_rnd.nextDouble() * (wallX - 20) + 10, _rnd.nextDouble() * (size.y - 20) + 10),
          isRed: true,
          velocity: Vector2((_rnd.nextDouble() - 0.5) * 200, (_rnd.nextDouble() - 0.5) * 200),
        );
        _redParticles.add(p);
        add(p);
    }
    
    // Right: Blue
    for (int i = 0; i < count; i++) {
        final p = EntropyParticle(
          position: Vector2(wallX + 10 + _rnd.nextDouble() * (wallX - 20), _rnd.nextDouble() * (size.y - 20) + 10),
          isRed: false,
          velocity: Vector2((_rnd.nextDouble() - 0.5) * 200, (_rnd.nextDouble() - 0.5) * 200),
        );
        _blueParticles.add(p);
        add(p);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    final settings = ref.read(entropyProvider);

    if (settings.resetCounter != _resetKey) {
      _initExperiment();
      return;
    }

    final wallX = size.x / 2;

    // Handle Wall Collision
    if (!settings.wallRemoved) {
      for (var p in children.query<EntropyParticle>()) {
        p.handleWallCollision(wallX);
      }
    }

    // Calculate Entropy (Mixing Disorder)
    final redOnRight = _redParticles.where((p) => p.position.x > wallX).length;
    final totalRed = _redParticles.length;
    
    // Probability of a red particle being on the right
    final p = redOnRight / totalRed;
    
    // Shannon Entropy: -[p ln(p) + (1-p) ln(1-p)]
    // Peak is at p=0.5 (perfectly mixed)
    double entropy = 0.0;
    if (p > 0 && p < 1) {
      entropy = -(p * log(p) + (1 - p) * log(1 - p)) / log(2); // normalized to 1.0
    }
    
    entropyNotifier.value = entropy;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final settings = ref.read(entropyProvider);
    
    // Draw Chamber Background
    _drawContainer(canvas);

    // Draw the Wall (Partition)
    if (!settings.wallRemoved) {
      final wallPaint = Paint()
        ..color = Colors.white24
        ..strokeWidth = 4;
      canvas.drawLine(Offset(size.x / 2, 0), Offset(size.x / 2, size.y), wallPaint);
    }
  }

  void _drawContainer(Canvas canvas) {
     final containerPaint = Paint()
        ..color = Colors.white.withOpacity(0.05)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
     canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), containerPaint);
  }

  @override
  void onRemove() {
    entropyNotifier.dispose();
    super.onRemove();
  }
}
