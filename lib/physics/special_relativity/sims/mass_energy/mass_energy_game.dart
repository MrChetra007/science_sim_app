import 'dart:math';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MassEnergyGame extends FlameGame {
  final double Function() getMass;
  final double Function() getBeta;
  final bool Function() getReactionTriggered;
  final double Function() getBurstProgress;
  final void Function(double dt) onTick;

  bool _alive = true;
  double _shakeDuration = 0.0;
  final Random _shakeRng = Random();
  List<double> _neutronAngles = [];
  bool _prevTriggered = false;

  MassEnergyGame({
    required this.getMass,
    required this.getBeta,
    required this.getReactionTriggered,
    required this.getBurstProgress,
    required this.onTick,
  });

  @override
  Color backgroundColor() => const Color(0xff0a0a1a);

  final List<Offset> _stars = [];
  final List<Offset> _nucleonOffsets = [];
  final List<Color> _nucleonColors = [];
  final Random _rng = Random();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    for (int i = 0; i < 40; i++) {
      _stars.add(Offset(
        _rng.nextDouble() * size.x,
        _rng.nextDouble() * size.y,
      ));
    }

    for (int i = 0; i < 24; i++) {
      final double r = _rng.nextDouble() * 22.0;
      final double theta = _rng.nextDouble() * 2 * pi;
      _nucleonOffsets.add(Offset(r * cos(theta), r * sin(theta)));
      _nucleonColors.add(
        _rng.nextBool()
            ? const Color(0xffff4444)
            : const Color(0xff4fc3f7),
      );
    }
  }

  @override
  void onRemove() {
    _alive = false;
    super.onRemove();
  }

  @override
  void update(double dt) {
    super.update(dt);

    final triggered = getReactionTriggered();

    // Screen shake
    if (_shakeDuration > 0) {
      final intensity = (_shakeDuration / 0.4) * 6.0;
      camera.viewfinder.position = Vector2(
        size.x / 2 + (_shakeRng.nextDouble() - 0.5) * intensity,
        size.y / 2 + (_shakeRng.nextDouble() - 0.5) * intensity,
      );
      _shakeDuration -= dt;
      if (_shakeDuration <= 0) {
        camera.viewfinder.position = Vector2(size.x / 2, size.y / 2);
      }
    }

    // Detect triggerFission to start shake + generate neutron angles
    if (triggered && !_prevTriggered) {
      _shakeDuration = 0.4;
      _neutronAngles = List.generate(6, (_) => _shakeRng.nextDouble() * 2 * pi);
    }
    _prevTriggered = triggered;

    Future(() {
      if (!_alive) return;
      onTick(dt);
    });
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw background stars
    final starPaint = Paint()..color = Colors.white.withOpacity(0.2);
    for (final star in _stars) {
      canvas.drawCircle(star, 1.0, starPaint);
    }

    final double width = size.x;
    final double height = size.y;
    final Offset center = Offset(width / 2, height * 0.45);

    final mass = getMass();
    final beta = getBeta();
    final triggered = getReactionTriggered();
    final progress = getBurstProgress();

    // Scale nucleus size slightly based on input mass
    final double massScale = 0.8 + (mass / 5.0) * 0.4;

    if (!triggered) {
      // Draw single nucleus at the center
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.scale(massScale);
      _drawNucleusCluster(canvas, _nucleonOffsets, _nucleonColors);
      canvas.restore();
    } else {
      // Draw split nucleus fragments moving apart horizontally
      final double splitDist = progress * width * 0.35;

      final leftOffsets = _nucleonOffsets.sublist(0, _nucleonOffsets.length ~/ 2);
      final rightOffsets = _nucleonOffsets.sublist(_nucleonOffsets.length ~/ 2);
      final leftColors = _nucleonColors.sublist(0, _nucleonColors.length ~/ 2);
      final rightColors = _nucleonColors.sublist(_nucleonColors.length ~/ 2);

      // Fragment glow trails (ghost copies behind each fragment)
      const ghostData = [(0.85, 0.4), (0.70, 0.25), (0.55, 0.12)];
      for (final (mult, op) in ghostData) {
        final ghostDist = splitDist * mult;
        canvas.save();
        canvas.translate(center.dx - ghostDist, center.dy);
        canvas.scale(massScale * 0.7);
        _drawNucleusCluster(canvas, leftOffsets, leftColors, opacity: op);
        canvas.restore();
        canvas.save();
        canvas.translate(center.dx + ghostDist, center.dy);
        canvas.scale(massScale * 0.7);
        _drawNucleusCluster(canvas, rightOffsets, rightColors, opacity: op);
        canvas.restore();
      }

      // Left Fragment
      canvas.save();
      canvas.translate(center.dx - splitDist, center.dy);
      canvas.scale(massScale * 0.7);
      _drawNucleusCluster(canvas, leftOffsets, leftColors);
      canvas.restore();

      // Right Fragment
      canvas.save();
      canvas.translate(center.dx + splitDist, center.dy);
      canvas.scale(massScale * 0.7);
      _drawNucleusCluster(canvas, rightOffsets, rightColors);
      canvas.restore();

      // Energy burst (triple rings + radial rays + sparkles)
      _drawEnergyBurst(canvas, center, progress, beta);

      // Free neutrons
      final neutronOpacity = (1.0 - progress).clamp(0.0, 1.0);
      if (_neutronAngles.isNotEmpty && neutronOpacity > 0) {
        final neutronDist = progress * width * 0.4;
        final neutronPaint = Paint()
          ..color = const Color(0xffb0bec5).withOpacity(neutronOpacity)
          ..style = PaintingStyle.fill;
        for (final angle in _neutronAngles) {
          canvas.drawCircle(
            center + Offset(cos(angle), sin(angle)) * neutronDist,
            4.0,
            neutronPaint,
          );
        }
      }

      // Screen flash (on top of everything)
      final flashOpacity = (1.0 - progress * 5.0).clamp(0.0, 1.0);
      if (flashOpacity > 0) {
        canvas.drawRect(
          size.toRect(),
          Paint()..color = Colors.white.withOpacity(flashOpacity),
        );
      }
    }
  }

  void _drawNucleusCluster(Canvas canvas, List<Offset> offsets, List<Color> colors, {double opacity = 1.0}) {
    for (int i = 0; i < offsets.length; i++) {
      final pos = offsets[i];
      final color = colors[i];
      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(pos, 6.0, paint);
      canvas.drawCircle(
        pos, 6.0,
        Paint()
          ..color = Colors.black45.withOpacity(opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0,
      );

      // Simple highlight for 3D sphere look
      canvas.drawCircle(
        pos - const Offset(2, 2),
        1.5,
        Paint()..color = Colors.white.withOpacity(0.6 * opacity),
      );
    }
  }

  void _drawEnergyBurst(Canvas canvas, Offset center, double progress, double beta) {
    final double maxRadius = size.x * 0.45;
    final double opacity = (1.0 - progress).clamp(0.0, 1.0);

    if (opacity <= 0.0) return;

    // Triple shockwave rings at different speeds
    final ringData = [
      (mult: 1.00, color: const Color(0xffffd700), width: 3.0),
      (mult: 0.75, color: const Color(0xffff9800), width: 2.0),
      (mult: 0.50, color: Colors.white,            width: 1.5),
    ];
    for (final (:mult, :color, :width) in ringData) {
      final r = progress * maxRadius * mult;
      canvas.drawCircle(
        center, r,
        Paint()
          ..color = color.withOpacity(opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = width,
      );
    }

    // Draw radial ray lines (energy photons)
    final rayPaint = Paint()
      ..color = const Color(0xffff9800).withOpacity(opacity * 0.8)
      ..strokeWidth = 2.0 + beta * 3.0
      ..strokeCap = StrokeCap.round;

    final radius = progress * maxRadius;
    const int rayCount = 12;
    for (int i = 0; i < rayCount; i++) {
      final double angle = i * 2 * pi / rayCount;
      final Offset start = center + Offset(cos(angle) * (radius * 0.3), sin(angle) * (radius * 0.3));
      final Offset end = center + Offset(cos(angle) * radius, sin(angle) * radius);
      canvas.drawLine(start, end, rayPaint);
    }

    // Sparkles
    final sparkPaint = Paint()
      ..color = Colors.white.withOpacity(opacity)
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 16; i++) {
      final double angle = (i * 3.14 / 8) + (progress * 0.5);
      final double dist = radius * (0.6 + 0.3 * sin(i));
      canvas.drawCircle(
        center + Offset(cos(angle) * dist, sin(angle) * dist),
        3.0 + beta * 2.0,
        sparkPaint,
      );
    }
  }
}
