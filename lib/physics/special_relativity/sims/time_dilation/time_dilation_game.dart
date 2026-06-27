import 'dart:math';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class TimeDilationGame extends FlameGame {
  final double Function() getBeta;
  final double Function() getGamma;
  final double Function() getProperTime;
  final double Function() getDilatedTime;
  final double Function() getPhotonPhase;
  final int Function() getRestBounces;
  final int Function() getMovingBounces;
  final void Function(double dt) onTick;

  bool _alive = true;

  TimeDilationGame({
    required this.getBeta,
    required this.getGamma,
    required this.getProperTime,
    required this.getDilatedTime,
    required this.getPhotonPhase,
    required this.getRestBounces,
    required this.getMovingBounces,
    required this.onTick,
  });

  @override
  Color backgroundColor() => const Color(0xff0a0a1a);

  final List<Offset> _stars = [];
  final Random _rng = Random();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    for (int i = 0; i < 60; i++) {
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
    Future(() {
      if (!_alive) return;
      onTick(dt);
    });
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw star field
    final starPaint = Paint()..color = Colors.white.withOpacity(0.3);
    for (final star in _stars) {
      canvas.drawCircle(star, 1.2, starPaint);
    }

    final double width = size.x;
    final double height = size.y;

    final double leftClockX = width * 0.28;
    final double rightClockX = width * 0.72;

    final double mirrorWidth = width * 0.35;
    final double mirrorHeight = 8.0;
    final double clockHeight = height * 0.55;

    final double topMirrorY = height * 0.15;
    final double bottomMirrorY = topMirrorY + clockHeight;

    final paintMirror = Paint()
      ..color = const Color(0xffc0c0c0)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    // Draw titles
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.0,
    );
    final textPainterRest = TextPainter(
      text: const TextSpan(text: 'OBSERVER (REST)', style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainterRest.paint(
      canvas,
      Offset(leftClockX - textPainterRest.width / 2, topMirrorY - 55),
    );

    final textPainterMoving = TextPainter(
      text: const TextSpan(text: 'SPACESHIP (MOVING)', style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainterMoving.paint(
      canvas,
      Offset(rightClockX - textPainterMoving.width / 2, topMirrorY - 55),
    );

    // Draw rest frame subtitle
    final subTextStyle = TextStyle(
      color: Colors.white.withOpacity(0.5),
      fontSize: 11,
      fontWeight: FontWeight.w500,
    );
    final subRest = TextPainter(
      text: TextSpan(text: 'Photon bounces straight', style: subTextStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    subRest.paint(
      canvas,
      Offset(leftClockX - subRest.width / 2, topMirrorY - 30),
    );

    final subMoving = TextPainter(
      text: TextSpan(text: 'Diagonal path observed', style: subTextStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    subMoving.paint(
      canvas,
      Offset(rightClockX - subMoving.width / 2, topMirrorY - 30),
    );

    // Bounce counter labels
    final bounceStyle = TextStyle(
      color: const Color(0xff00ff41),
      fontSize: 13,
      fontFamily: 'monospace',
      fontWeight: FontWeight.bold,
    );
    final restBounces = getRestBounces();
    final movingBounces = getMovingBounces();
    final bounceRest = TextPainter(
      text: TextSpan(text: "bounces: $restBounces", style: bounceStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    bounceRest.paint(
      canvas,
      Offset(leftClockX - bounceRest.width / 2, topMirrorY - 13),
    );
    final bounceMoving = TextPainter(
      text: TextSpan(text: "bounces: $movingBounces", style: bounceStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    bounceMoving.paint(
      canvas,
      Offset(rightClockX - bounceMoving.width / 2, topMirrorY - 13),
    );

    // Render mirrors for Left (Rest) Clock
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(leftClockX, topMirrorY), width: mirrorWidth, height: mirrorHeight),
        const Radius.circular(4),
      ),
      paintMirror,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(leftClockX, bottomMirrorY), width: mirrorWidth, height: mirrorHeight),
        const Radius.circular(4),
      ),
      paintMirror,
    );

    // Render mirrors for Right (Moving) Clock
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(rightClockX, topMirrorY), width: mirrorWidth, height: mirrorHeight),
        const Radius.circular(4),
      ),
      paintMirror,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(rightClockX, bottomMirrorY), width: mirrorWidth, height: mirrorHeight),
        const Radius.circular(4),
      ),
      paintMirror,
    );

    // Draw Light path guide lines
    final paintPathGuide = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Left Clock vertical line path
    canvas.drawLine(
      Offset(leftClockX, topMirrorY),
      Offset(leftClockX, bottomMirrorY),
      paintPathGuide,
    );

    // Right Clock diagonal paths based on beta
    final beta = getBeta();
    final double diagOffset = mirrorWidth * 0.45 * beta;

    final guidePath = Path()
      ..moveTo(rightClockX - diagOffset, topMirrorY)
      ..lineTo(rightClockX + diagOffset, bottomMirrorY)
      ..lineTo(rightClockX - diagOffset, topMirrorY);
    canvas.drawPath(guidePath, paintPathGuide);

    // Calculate Photon Y position for Rest clock (based on dilatedTime phase)
    final double dilatedTime = getDilatedTime();
    final double restPhase = (dilatedTime * 2.0) % 2.0;
    double restPhotonY;
    if (restPhase < 1.0) {
      restPhotonY = topMirrorY + restPhase * clockHeight;
    } else {
      restPhotonY = bottomMirrorY - (restPhase - 1.0) * clockHeight;
    }

    // Calculate Photon position for Moving clock (based on properTime phase)
    final double properTime = getProperTime();
    final double movingPhase = (properTime * 2.0) % 2.0;
    double movingPhotonY;
    double movingPhotonX;
    if (movingPhase < 1.0) {
      movingPhotonY = topMirrorY + movingPhase * clockHeight;
      movingPhotonX = rightClockX - diagOffset + (movingPhase * 2.0 * diagOffset);
    } else {
      movingPhotonY = bottomMirrorY - (movingPhase - 1.0) * clockHeight;
      movingPhotonX = rightClockX + diagOffset - ((movingPhase - 1.0) * 2.0 * diagOffset);
    }

    // Draw Photons (golden glowing circles)
    final paintPhoton = Paint()
      ..color = const Color(0xffffd700)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final paintPhotonCore = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Draw Rest photon
    canvas.drawCircle(Offset(leftClockX, restPhotonY), 8.0, paintPhoton);
    canvas.drawCircle(Offset(leftClockX, restPhotonY), 4.0, paintPhotonCore);

    // Draw Moving photon
    canvas.drawCircle(Offset(movingPhotonX, movingPhotonY), 8.0, paintPhoton);
    canvas.drawCircle(Offset(movingPhotonX, movingPhotonY), 4.0, paintPhotonCore);

    // Path length indicator labels (per bounce, in units of clockHeight = 1)
    final restPathUnits = 2.0;
    final double movingPathUnits;
    final double unitRatio;
    if (beta > 0.001) {
      final halfSpan = 2.0 * diagOffset / clockHeight;
      movingPathUnits = 2.0 * sqrt(1.0 + halfSpan * halfSpan);
      unitRatio = movingPathUnits / restPathUnits;
    } else {
      movingPathUnits = 2.0;
      unitRatio = 1.0;
    }
    final pathStyle = TextStyle(
      color: Colors.white.withOpacity(0.5),
      fontSize: 11,
      fontFamily: 'monospace',
    );
    final pathRest = TextPainter(
      text: TextSpan(
        text: "path: ${restPathUnits.toStringAsFixed(2)} L",
        style: pathStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    pathRest.paint(
      canvas,
      Offset(leftClockX - pathRest.width / 2, bottomMirrorY + 8),
    );
    final pathMovingLabel = TextPainter(
      text: TextSpan(
        text: "path: ${movingPathUnits.toStringAsFixed(2)} L",
        style: pathStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    pathMovingLabel.paint(
      canvas,
      Offset(rightClockX - pathMovingLabel.width / 2, bottomMirrorY + 8),
    );

    // Ratio label below path
    final ratioStyle = TextStyle(
      color: const Color(0xffff8c00).withOpacity(0.6),
      fontSize: 10,
      fontFamily: 'monospace',
    );
    final ratioLabel = TextPainter(
      text: TextSpan(
        text: "ratio: ${unitRatio.toStringAsFixed(3)}×",
        style: ratioStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    ratioLabel.paint(
      canvas,
      Offset(rightClockX - ratioLabel.width / 2, bottomMirrorY + 22),
    );

    // Path length proof dashed orange line (moving clock diagonal)
    if (beta > 0.05) {
      final proofPaint = Paint()
        ..color = const Color(0xffff8c00).withOpacity(0.35)
        ..style = PaintingStyle.fill;
      final diagonalPath = Path()
        ..moveTo(rightClockX - diagOffset, topMirrorY)
        ..lineTo(rightClockX + diagOffset, bottomMirrorY);
      final metric = diagonalPath.computeMetrics().first;
      for (double d = 0; d < metric.length; d += 10) {
        final tangent = metric.getTangentForOffset(d);
        if (tangent != null) {
          canvas.drawCircle(tangent.position, 2.0, proofPaint);
        }
      }

      // Midpoint measurement label
      final midpoint = metric.getTangentForOffset(metric.length / 2);
      if (midpoint != null) {
        final proofLabelStyle = TextStyle(
          color: const Color(0xffff8c00).withOpacity(0.5),
          fontSize: 9,
          fontFamily: 'monospace',
        );
        final proofLabel = TextPainter(
          text: TextSpan(
            text: "√(L² + (2d)²) = ${(movingPathUnits / 2).toStringAsFixed(3)} L",
            style: proofLabelStyle,
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        proofLabel.paint(
          canvas,
          Offset(
            midpoint.position.dx - proofLabel.width / 2 + 10,
            midpoint.position.dy - proofLabel.height / 2,
          ),
        );
      }
    }
  }
}
