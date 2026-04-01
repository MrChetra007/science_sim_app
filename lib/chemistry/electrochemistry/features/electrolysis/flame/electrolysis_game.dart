import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import '../providers/electrolysis_state.dart';
import 'bubble_component.dart';
import '../../../core/theme/app_colors.dart';

class ElectrolysisGame extends FlameGame {
  ElectrolysisState state;
  final List<BubbleComponent> _bubbles = [];
  double _spawnTimer = 0.0;

  ElectrolysisGame({required this.state});

  @override
  Color backgroundColor() => Colors.transparent;

  void updateState(ElectrolysisState newState) {
    state = newState;
    if (!state.isReacting) {
      _bubbles.clear();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!state.isReacting) return;

    _spawnTimer += dt;
    // Spawn rate scales with applied voltage
    final interval = (0.5 / (state.appliedVoltage - state.electrolyte.thresholdVoltage + 0.1)).clamp(0.05, 0.4);
    
    if (_spawnTimer >= interval) {
      _spawnTimer = 0;
      _spawnBubbles();
    }

    for (final b in _bubbles) {
      b.update(dt);
    }
    _bubbles.removeWhere((b) => b.isDead);
  }

  void _spawnBubbles() {
    final rand = math.Random();
    
    // Anode Bubbles
    if (state.electrolyte.anodeGasColor != Colors.transparent) {
      _bubbles.add(BubbleComponent(
        position: Vector2(size.x * 0.25 + (rand.nextDouble() * 20 - 10), size.y * 0.7),
        color: state.electrolyte.anodeGasColor,
        speed: 30.0 + rand.nextDouble() * 20,
      ));
    }

    // Cathode Bubbles
    if (state.electrolyte.cathodeGasColor != Colors.transparent) {
      _bubbles.add(BubbleComponent(
        position: Vector2(size.x * 0.75 + (rand.nextDouble() * 20 - 10), size.y * 0.7),
        color: state.electrolyte.cathodeGasColor,
        speed: 30.0 + rand.nextDouble() * 20,
      ));
      // Stoichiometry: produce more H2 than O2 if applicable
      if (state.electrolyte.formula == 'H₂O') {
        _bubbles.add(BubbleComponent(
          position: Vector2(size.x * 0.75 + (rand.nextDouble() * 20 - 10), size.y * 0.8),
          color: state.electrolyte.cathodeGasColor,
          speed: 25.0 + rand.nextDouble() * 30,
        ));
      }
    }
  }

  @override
  void render(Canvas canvas) {
    _drawSetup(canvas);
    for (final b in _bubbles) {
      b.render(canvas);
    }
    super.render(canvas);
  }

  void _drawSetup(Canvas canvas) {
    final paint = Paint()
      ..color = AppColors.borderDefault.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Draw Beaker
    final beakerRect = Rect.fromLTWH(size.x * 0.1, size.y * 0.4, size.x * 0.8, size.y * 0.5);
    canvas.drawRect(beakerRect, paint);
    
    // Draw Solution
    final solutionPaint = Paint()..color = state.electrolyte.solutionColor.withValues(alpha: 0.4);
    canvas.drawRect(Rect.fromLTWH(size.x * 0.1, size.y * 0.5, size.x * 0.8, size.y * 0.4), solutionPaint);

    // Draw Electrodes
    final electrodePaint = Paint()..color = const Color(0xFF666666);
    canvas.drawRect(Rect.fromLTWH(size.x * 0.22, size.y * 0.45, 20, size.y * 0.4), electrodePaint); // Anode
    canvas.drawRect(Rect.fromLTWH(size.x * 0.72, size.y * 0.45, 20, size.y * 0.4), electrodePaint); // Cathode

    // Draw Labels
    _drawLabel(canvas, '+ ANODE', Vector2(size.x * 0.22, size.y * 0.4), AppColors.accentAmber);
    _drawLabel(canvas, '− CATHODE', Vector2(size.x * 0.72, size.y * 0.4), AppColors.accentGreen);
  }

  void _drawLabel(Canvas canvas, String text, Vector2 pos, Color color) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, pos.toOffset());
  }
}
