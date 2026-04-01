import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart' show Colors;
import '../providers/electroplating_state.dart';
import 'deposition_component.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/electrode_colors.dart';

class ElectroplatingGame extends FlameGame {
  ElectroplatingState state;
  DepositionComponent? target;
  final List<_IonParticle> _ions = [];
  double _spawnTimer = 0.0;

  ElectroplatingGame({required this.state});

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    target = DepositionComponent(
      position: Vector2(size.x * 0.6, size.y * 0.45),
      state: state,
    );
    if (target != null) {
      await add(target!);
    }
  }

  void updateState(ElectroplatingState newState) {
    state = newState;
    target?.updateState(state);
    if (!state.isPlating) {
      _ions.clear();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!state.isPlating || state.currentAmps <= 0) return;

    _spawnTimer += dt;
    final interval = (1.5 / (state.currentAmps + 0.1)).clamp(0.1, 0.8);
    
    if (_spawnTimer >= interval) {
      _spawnTimer = 0;
      _spawnIons();
    }

    for (final b in _ions) {
      b.update(dt);
    }
    _ions.removeWhere((b) => b.isDead);
  }

  void _spawnIons() {
    final startX = size.x * 0.25;
    final startY = size.y * 0.5;
    final endX = size.x * 0.65;
    final endY = size.y * 0.55;
    
    _ions.add(_IonParticle(
      from: Vector2(startX, startY),
      to: Vector2(endX, endY),
      color: ElectrodeColors.metalFill[state.metal.symbol] ?? Colors.grey,
    ));
  }

  @override
  void render(Canvas canvas) {
    _drawSetup(canvas);
    for (final b in _ions) {
      b.render(canvas);
    }
    super.render(canvas);
  }

  void _drawSetup(Canvas canvas) {
    final paint = Paint()
      ..color = AppColors.borderDefault.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Draw Solution Tank
    final tankRect = Rect.fromLTWH(size.x * 0.1, size.y * 0.4, size.x * 0.8, size.y * 0.5);
    canvas.drawRect(tankRect, paint);
    
    // Draw Solution
    final solutionPaint = Paint()..color = const Color(0xFF1E88E5).withValues(alpha: 0.2); // Blue solution (Cu or generic)
    canvas.drawRect(Rect.fromLTWH(size.x * 0.1, size.y * 0.5, size.x * 0.8, size.y * 0.4), solutionPaint);

    // Draw Source Anode (Pure Metal)
    final anodePaint = Paint()..color = ElectrodeColors.metalFill[state.metal.symbol] ?? Colors.grey;
    canvas.drawRect(Rect.fromLTWH(size.x * 0.2, size.y * 0.45, 20, size.y * 0.4), anodePaint);

    // Power Lines
    final powerPaint = Paint()
      ..color = AppColors.accentElectric.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final wirePath = Path()
      ..moveTo(size.x * 0.21, size.y * 0.45)
      ..lineTo(size.x * 0.21, size.y * 0.25)
      ..lineTo(size.x * 0.65, size.y * 0.25)
      ..lineTo(size.x * 0.65, size.y * 0.45);
    canvas.drawPath(wirePath, powerPaint);
  }
}

class _IonParticle {
  Vector2 pos;
  final Vector2 to;
  final Color color;
  double _progress = 0.0;

  _IonParticle({required Vector2 from, required this.to, required this.color}) : pos = from;

  bool get isDead => _progress >= 1.0;

  void update(double dt) {
    _progress = (_progress + dt * 0.5).clamp(0.0, 1.0);
    pos.setFrom(pos + (to - pos) * (dt * 0.8));
  }

  void render(Canvas canvas) {
    final opacity = (1.0 - _progress).clamp(0.0, 1.0);
    canvas.drawCircle(
      pos.toOffset(),
      3.0,
      Paint()..color = color.withValues(alpha: opacity),
    );
  }
}
