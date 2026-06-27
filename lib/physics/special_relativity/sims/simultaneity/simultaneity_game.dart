import 'dart:math';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class SimultaneityGame extends FlameGame {
  final double Function() getBeta;
  final double Function() getTrainX;
  final bool Function() getStrikeTriggered;
  final double Function() getWavefrontARadius;
  final double Function() getWavefrontBRadius;
  final double Function() getElapsed;
  final double? Function() getTrainTimeB;
  final void Function(double dt, double width) onTick;

  bool _alive = true;
  double _trainFlashTimer = 0.0;

  SimultaneityGame({
    required this.getBeta,
    required this.getTrainX,
    required this.getStrikeTriggered,
    required this.getWavefrontARadius,
    required this.getWavefrontBRadius,
    required this.getElapsed,
    required this.getTrainTimeB,
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
      // Flash detection: trigger when trainTimeB first becomes non-null
      if (getStrikeTriggered() && getTrainTimeB() != null && _trainFlashTimer == 0.0) {
        _trainFlashTimer = 0.3;
      }
      // Reset flash when simulation resets
      if (!getStrikeTriggered()) {
        _trainFlashTimer = 0.0;
      }
      // Tick down flash timer
      if (_trainFlashTimer > 0.0) {
        _trainFlashTimer -= dt;
        if (_trainFlashTimer < 0.0) _trainFlashTimer = 0.0;
      }
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

    final beta = getBeta();
    final isTriggered = getStrikeTriggered();
    final elapsed = getElapsed();

    // Constant speed parameters
    const double cSpeed = 220.0;
    final double strikeDist = width * 0.25;
    final double center = width / 2;

    // Platform view layout
    final double platViewY = height * 0.28;
    // Train view layout
    final double trainViewY = height * 0.72;

    // Draw divider line
    canvas.drawLine(
      Offset(0, height / 2),
      Offset(width, height / 2),
      Paint()
        ..color = const Color(0xff4fc3f7).withOpacity(0.2)
        ..strokeWidth = 2.0,
    );

    // DRAW PLATFORM VIEW (TOP HALF)
    _drawFrameTitle(canvas, "PLATFORM OBSERVER FRAME", 30.0);
    _drawTracks(canvas, platViewY, width);

    // Draw Platform Observer (stationary)
    _drawObserver(canvas, Offset(center, platViewY + 30.0), const Color(0xff4fc3f7), "Platform Observer");

    // Draw moving train in platform view
    final double trainWidth = width * 0.50;
    final double trainHeight = 35.0;
    final double trainY = platViewY - 15.0;
    double trainX = center;

    if (isTriggered) {
      final double vSpeed = cSpeed * beta;
      trainX = center + vSpeed * elapsed;
    } else {
      trainX = center; // Align at start
    }

    _drawTrain(canvas, Offset(trainX, trainY), trainWidth, trainHeight, "Train Observer");

    // Expand wavefronts in platform view
    if (isTriggered) {
      final double strikeA_X = center - strikeDist;
      final double strikeB_X = center + strikeDist;

      final double radA = getWavefrontARadius();
      final double radB = getWavefrontBRadius();

      // Draw wavefront circles
      _drawWavefront(canvas, Offset(strikeA_X, trainY), radA, const Color(0xffffd700));
      _drawWavefront(canvas, Offset(strikeB_X, trainY), radB, const Color(0xff00ff41));

      // Draw lightning strike bolts initially
      if (elapsed < 0.15) {
        _drawLightningBolt(canvas, Offset(strikeA_X, trainY));
        _drawLightningBolt(canvas, Offset(strikeB_X, trainY));
      }
    }

    // DRAW TRAIN VIEW (BOTTOM HALF)
    _drawFrameTitle(canvas, "TRAIN OBSERVER FRAME (REST FRAME)", height / 2 + 30.0);
    // Draw moving tracks (sleepers moving left to show train frame movement)
    _drawMovingTracks(canvas, trainViewY, width, beta, elapsed, isTriggered);

    // Train is stationary in the center in its own frame
    final double trainViewTrainX = center;
    final double trainViewTrainY = trainViewY - 15.0;
    _drawTrain(canvas, Offset(trainViewTrainX, trainViewTrainY), trainWidth, trainHeight, "Train Observer");

    // Platform observer moves left in the train frame
    double platObsX = center;
    if (isTriggered) {
      final double vSpeed = cSpeed * beta;
      platObsX = center - vSpeed * elapsed;
    }
    _drawObserver(canvas, Offset(platObsX, trainViewY + 30.0), const Color(0xff4fc3f7).withOpacity(0.7), "Platform Observer");

    // Expand wavefronts in train view
    if (isTriggered) {
      // In the train frame, the front strike B happens at the front corner of the train,
      // and wavefront B starts expanding immediately at t = 0.
      final double trainFrontX = trainViewTrainX + trainWidth / 2;
      final double trainBackX = trainViewTrainX - trainWidth / 2;

      final double radB = cSpeed * elapsed;

      // Wavefront A is delayed in the train frame due to relativity of simultaneity
      // Delay t_delay = 2 * L * beta / (c * (1 - beta^2))
      final double L = trainWidth / 2;
      final double delay = (2.0 * L * beta) / (cSpeed * (1.0 - beta * beta));

      double radA = 0.0;
      if (elapsed > delay) {
        radA = cSpeed * (elapsed - delay);
      }

      // Draw wavefront B
      _drawWavefront(canvas, Offset(trainFrontX, trainViewTrainY), radB, const Color(0xff00ff41));
      // Draw wavefront A (delayed)
      if (radA > 0.0) {
        _drawWavefront(canvas, Offset(trainBackX, trainViewTrainY), radA, const Color(0xffffd700));
      }

      // Lightning bolts
      if (elapsed < 0.15) {
        _drawLightningBolt(canvas, Offset(trainFrontX, trainViewTrainY));
      }
      if (elapsed >= delay && elapsed < delay + 0.15) {
        _drawLightningBolt(canvas, Offset(trainBackX, trainViewTrainY));
      }
    }

    // Train flash overlay (gold flash when front wavefront B arrives)
    if (_trainFlashTimer > 0.0) {
      final progress = 1.0 - (_trainFlashTimer / 0.3);
      final opacity = (1.0 - (progress * 5.0)).clamp(0.0, 1.0);
      canvas.drawRect(
        Rect.fromLTWH(0.0, height / 2, width, height / 2),
        Paint()
          ..color = const Color(0xffffd700).withOpacity(opacity * 0.2),
      );
    }
  }

  void _drawFrameTitle(Canvas canvas, String title, double y) {
    final textStyle = TextStyle(
      color: Colors.white.withOpacity(0.7),
      fontSize: 14,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5,
    );
    final textPainter = TextPainter(
      text: TextSpan(text: title, style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset(16.0, y));
  }

  void _drawTracks(Canvas canvas, double y, double width) {
    final paintTrack = Paint()
      ..color = Colors.white24
      ..strokeWidth = 2.0;
    canvas.drawLine(Offset(0, y), Offset(width, y), paintTrack);
    // sleepers
    for (double x = 0; x < width; x += 30) {
      canvas.drawLine(Offset(x, y - 4), Offset(x, y + 4), paintTrack);
    }
  }

  void _drawMovingTracks(Canvas canvas, double y, double width, double beta, double elapsed, bool isTriggered) {
    final paintTrack = Paint()
      ..color = Colors.white24
      ..strokeWidth = 2.0;
    canvas.drawLine(Offset(0, y), Offset(width, y), paintTrack);

    // Offset sleepers leftward based on speed and time
    const double cSpeed = 220.0;
    final double vSpeed = cSpeed * beta;
    final double offset = isTriggered ? (vSpeed * elapsed) % 30.0 : 0.0;

    for (double x = -offset; x < width; x += 30) {
      if (x >= 0) {
        canvas.drawLine(Offset(x, y - 4), Offset(x, y + 4), paintTrack);
      }
    }
  }

  void _drawObserver(Canvas canvas, Offset pos, Color color, String name) {
    // Head
    canvas.drawCircle(pos - const Offset(0, 12), 6.0, Paint()..color = color);
    // Body
    canvas.drawLine(pos - const Offset(0, 6), pos + const Offset(0, 8), Paint()..color = color..strokeWidth = 2.0);
    // Arms
    canvas.drawLine(pos - const Offset(6, 2), pos + const Offset(6, -2), Paint()..color = color..strokeWidth = 1.5);
    // Legs
    canvas.drawLine(pos + const Offset(0, 8), pos + const Offset(-4, 16), Paint()..color = color..strokeWidth = 1.5);
    canvas.drawLine(pos + const Offset(0, 8), pos + const Offset(4, 16), Paint()..color = color..strokeWidth = 1.5);
  }

  void _drawTrain(Canvas canvas, Offset center, double w, double h, String label) {
    final rectPaint = Paint()
      ..color = const Color(0xff1f2d3d)
      ..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = const Color(0xff4fc3f7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw main train box
    final rect = Rect.fromCenter(center: center, width: w, height: h);
    canvas.drawRect(rect, rectPaint);
    canvas.drawRect(rect, borderPaint);

    // Draw windows
    final windowPaint = Paint()..color = const Color(0xff4fc3f7).withOpacity(0.3);
    for (int i = -3; i <= 3; i++) {
      if (i != 0) {
        final double wx = center.dx + (i * w * 0.12);
        canvas.drawRect(
          Rect.fromCenter(center: Offset(wx, center.dy), width: w * 0.08, height: h * 0.4),
          windowPaint,
        );
      }
    }

    // Draw train observer inside the train
    _drawObserver(canvas, Offset(center.dx, center.dy + 2), const Color(0xffffffd700), label);
  }

  void _drawWavefront(Canvas canvas, Offset source, double radius, Color color) {
    canvas.drawCircle(
      source,
      radius,
      Paint()
        ..color = color.withOpacity(0.12)
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      source,
      radius,
      Paint()
        ..color = color.withOpacity(0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  void _drawLightningBolt(Canvas canvas, Offset target) {
    final paint = Paint()
      ..color = const Color(0xffffffff)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    final path = Path()
      ..moveTo(target.dx - 10, target.dy - 60)
      ..lineTo(target.dx + 5, target.dy - 35)
      ..lineTo(target.dx - 5, target.dy - 35)
      ..lineTo(target.dx, target.dy);

    canvas.drawPath(path, paint);

    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xffffd700)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
  }
}
