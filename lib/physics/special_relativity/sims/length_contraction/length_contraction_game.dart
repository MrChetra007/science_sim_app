import 'dart:math';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class LengthContractionGame extends FlameGame {
  final double Function() getBeta;
  final double Function() getGamma;
  final double Function() getShipX;
  final bool Function() getIsRunning;
  final void Function(double dt, double width) onTick;

  bool _alive = true;

  LengthContractionGame({
    required this.getBeta,
    required this.getGamma,
    required this.getShipX,
    required this.getIsRunning,
    required this.onTick,
  });

  @override
  Color backgroundColor() => const Color(0xff0a0a1a);

  final List<Offset> _stars = [];
  final Random _rng = Random();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    for (int i = 0; i < 50; i++) {
      _stars.add(Offset(
        _rng.nextDouble() * size.x,
        _rng.nextDouble() * size.y,
      ));
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
    final w = size.x;
    Future(() {
      if (!_alive) return;
      onTick(dt, w);
    });
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw background stars
    final starPaint = Paint()..color = Colors.white.withOpacity(0.25);
    for (final star in _stars) {
      canvas.drawCircle(star, 1.0, starPaint);
    }

    final double width = size.x;
    final double height = size.y;

    final beta = getBeta();
    final gamma = getGamma();
    final isRunning = getIsRunning();

    // Spaceship design dimensions
    final double restShipWidth = 160.0;
    final double contractedShipWidth = restShipWidth / gamma;
    final double shipHeight = 50.0;
    final double shipY = height * 0.40;

    final shipX = getShipX();

    // Render motion-blur trails (only when running)
    if (isRunning && beta > 0.05) {
      final int trailCount = 5;
      final double trailSpacing = (beta * 40.0) + 10.0;
      for (int i = 1; i <= trailCount; i++) {
        final double opacity = 0.25 * (1.0 - (i / (trailCount + 1)));
        final double offsetShipX = shipX - (i * trailSpacing);

        canvas.save();
        canvas.translate(offsetShipX, shipY);
        _drawSpaceshipShape(canvas, contractedShipWidth, shipHeight, opacity);
        canvas.restore();
      }
    }

    // Render primary spaceship
    canvas.save();
    canvas.translate(shipX, shipY);
    _drawSpaceshipShape(canvas, contractedShipWidth, shipHeight, 1.0);
    // Draw dynamic engine flame
    if (isRunning) {
      _drawEngineFlame(canvas, contractedShipWidth, shipHeight, beta);
    }
    canvas.restore();

    // Draw reference rest length ruler (L0 = 100m)
    final double rulerY = height * 0.72;
    final double rulerLeft = width * 0.15;
    final double rulerRight = width * 0.85;
    final double rulerWidth = rulerRight - rulerLeft;

    _drawRuler(
      canvas,
      rulerLeft,
      rulerY,
      rulerWidth,
      "Rest Length (L₀) = 100m",
      const Color(0xff4fc3f7).withOpacity(0.25),
      showTicks: true,
    );

    // Draw contracted length ruler (L' = L0/gamma)
    final double contractedRulerWidth = rulerWidth / gamma;
    final double contractedRulerLeft = rulerLeft + (rulerWidth - contractedRulerWidth) / 2;
    _drawRuler(
      canvas,
      contractedRulerLeft,
      rulerY + 45.0,
      contractedRulerWidth,
      "Contracted Length (L') = ${(100.0 / gamma).toStringAsFixed(1)}m",
      const Color(0xff00ff41),
      showTicks: false,
    );
  }

  void _drawSpaceshipShape(Canvas canvas, double w, double h, double opacity) {
    final Path shipPath = Path()
      ..moveTo(-w / 2, -h * 0.15)
      ..lineTo(-w / 2, h * 0.15)
      ..lineTo(-w * 0.35, h * 0.45)
      ..lineTo(w * 0.25, h * 0.45)
      ..lineTo(w / 2, 0.0) // nose cone
      ..lineTo(w * 0.25, -h * 0.45)
      ..lineTo(-w * 0.35, -h * 0.45)
      ..close();

    final shipPaint = Paint()
      ..color = const Color(0xff4fc3f7).withOpacity(0.8 * opacity)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawPath(shipPath, shipPaint);
    canvas.drawPath(shipPath, borderPaint);

    // Draw cockpit window
    final Path cockpitPath = Path()
      ..moveTo(w * 0.15, -h * 0.15)
      ..lineTo(w * 0.35, 0.0)
      ..lineTo(w * 0.15, h * 0.15)
      ..close();
    canvas.drawPath(
      cockpitPath,
      Paint()
        ..color = const Color(0xffffffff).withOpacity(0.9 * opacity)
        ..style = PaintingStyle.fill,
    );
  }

  void _drawEngineFlame(Canvas canvas, double w, double h, double beta) {
    final rand = Random();
    final flameLength = (w * 0.25) + rand.nextDouble() * (w * 0.15) * (1.0 + beta);
    final flamePath = Path()
      ..moveTo(-w / 2, -h * 0.1)
      ..lineTo(-w / 2 - flameLength, 0.0)
      ..lineTo(-w / 2, h * 0.1)
      ..close();

    canvas.drawPath(
      flamePath,
      Paint()
        ..color = const Color(0xffff9800).withOpacity(0.8)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
  }

  void _drawRuler(
    Canvas canvas,
    double x,
    double y,
    double w,
    String label,
    Color color, {
    required bool showTicks,
  }) {
    final paintLine = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Draw main horizontal line
    canvas.drawLine(Offset(x, y), Offset(x + w, y), paintLine);

    // Draw brackets at the ends
    canvas.drawLine(Offset(x, y - 8.0), Offset(x, y + 8.0), paintLine);
    canvas.drawLine(Offset(x + w, y - 8.0), Offset(x + w, y + 8.0), paintLine);

    if (showTicks) {
      final tickPaint = Paint()
        ..color = color.withOpacity(0.4)
        ..strokeWidth = 1.0;
      for (int i = 1; i < 10; i++) {
        final double tx = x + (w * i / 10);
        canvas.drawLine(Offset(tx, y - 5.0), Offset(tx, y + 5.0), tickPaint);
      }
    }

    // Draw Text label
    final textStyle = TextStyle(
      color: color,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );
    final textPainter = TextPainter(
      text: TextSpan(text: label, style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(x + w / 2 - textPainter.width / 2, y - 22.0),
    );
  }
}
