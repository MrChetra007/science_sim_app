import 'dart:math' as math;
import 'dart:ui';

import 'base_optics_game.dart';
import 'painters.dart';
import 'sprites.dart';

enum MirrorType { concave, convex }

class CurvedMirrorGame extends BaseOpticsGame {
  MirrorType type = MirrorType.concave;
  double focalLength = 100;
  double objectDistance = 210;
  double objectHeight = 70;
  ObjectSprite sprite = ObjectSprite.candle;

  double di = 0;
  double magnification = 0;
  String natureText = '—';
  bool atInfinity = false;

  @override
  Future<void> onLoad() async {
    preloadSprites([
      SpriteAssets.mirrorConcave,
      SpriteAssets.mirrorConvex,
      SpriteAssets.candle,
      SpriteAssets.pencil,
      SpriteAssets.pen,
      SpriteAssets.book,
    ]);
  }

  void setType(MirrorType t) {
    type = t;
    uiChanged();
  }

  void setFocalLength(double v) {
    focalLength = v;
    uiChanged();
  }

  void setObjectDistance(double v) {
    objectDistance = v;
    uiChanged();
  }

  void setObjectHeight(double v) {
    objectHeight = v;
    uiChanged();
  }

  void setSprite(ObjectSprite s) {
    sprite = s;
    uiChanged();
  }

  @override
  void updateDrag(double x, double y) {
    final vertexX = gw * 0.66;
    final axisY = gh / 2;
    objectDistance = (vertexX - x).clamp(40, 420).toDouble();
    objectHeight = (axisY - y).clamp(20, 110).toDouble();
    uiChanged();
  }

  void _solve(double fSigned, double doPx) {
    final denom = doPx - fSigned;
    if (denom.abs() < 0.001) {
      atInfinity = true;
      di = 0;
      magnification = 0;
    } else {
      atInfinity = false;
      di = fSigned * doPx / denom;
      magnification = -di / doPx;
    }
  }

  @override
  void renderScene(Canvas canvas) {
    clearCanvas(canvas);
    final axisY = gh / 2;
    final vertexX = gw * 0.66;
    final isConcave = type == MirrorType.concave;
    final fSigned = isConcave ? focalLength : -focalLength;
    final doVal = objectDistance;
    final hoVal = objectHeight;

    _solve(fSigned, doVal);
    final hiVal = magnification * hoVal;

    final objX = vertexX - doVal;
    final objTipY = axisY - hoVal;
    final fX = vertexX - fSigned;
    final cX = vertexX - 2 * fSigned;

    // Optical principal axis
    final axisPaint = Paint()
      ..color = const Color(0xFF475569)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(30, axisY), Offset(gw - 30, axisY), axisPaint);

    // Curved mirror
    final mirrorR = 2 * focalLength;
    final arcSpanAngle =
        math.asin((125 / mirrorR).clamp(-1.0, 1.0));
    final curveSprite =
        isConcave ? sprites.get(SpriteAssets.mirrorConcave) : sprites.get(SpriteAssets.mirrorConvex);
    if (curveSprite != null) {
      const span = 125.0;
      final imgH = (2 * span) / 0.9;
      final imgW = imgH * curveSprite.width / curveSprite.height;
      canvas.save();
      canvas.translate(vertexX, axisY);
      drawImageRect(canvas, curveSprite,
          Rect.fromCenter(center: Offset.zero, width: imgW, height: imgH));
      canvas.restore();
    } else {
      final mirrorPaint = Paint()
        ..color = const Color(0xFF94A3B8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5;
      canvas.drawArc(
        Rect.fromCircle(
            center: Offset(isConcave ? vertexX - mirrorR : vertexX + mirrorR, axisY),
            radius: mirrorR),
        isConcave ? -arcSpanAngle : math.pi - arcSpanAngle,
        isConcave ? 2 * arcSpanAngle : 2 * arcSpanAngle,
        false,
        mirrorPaint,
      );
    }

    drawFocalMarker(canvas, fX, axisY, 'F');
    drawFocalMarker(canvas, cX, axisY, 'C');
    drawFocalMarker(canvas, vertexX, axisY, 'V');

    final objImg = objectImage(sprite);
    if (objImg != null) {
      drawSpriteObject(canvas, objImg, objX, axisY, objTipY,
          label: 'Object (Drag tip)');
    } else {
      drawObjectArrow(canvas, objX, axisY, objTipY, const Color(0xFFFACC15),
          'Object (Drag tip)');
    }

    if (!atInfinity) {
      final imgX = vertexX - di;
      final imgTipY = axisY - hiVal;

      // RAY 1: parallel -> through F
      final rayPaint = Paint()
        ..color = const Color(0xFF38BDF8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      final ray1 = Path()
        ..moveTo(objX, objTipY)
        ..lineTo(vertexX, objTipY);
      canvas.drawPath(ray1, rayPaint);

      if (isConcave) {
        final ray1Slope = (axisY - objTipY) / (fX - vertexX);
        const endX = 40.0;
        final endY = objTipY + ray1Slope * (endX - vertexX);
        drawArrow(canvas, vertexX, objTipY, endX, endY, const Color(0xFF38BDF8),
            arrowSize: 8);
        if (di < 0) {
          drawDashedLine(canvas, vertexX, objTipY, imgX, imgTipY,
              const Color(0xFF38BDF8),
              width: 1.5);
        }
      } else {
        final slope = (objTipY - axisY) / (vertexX - fX);
        const endX = 40.0;
        final endY = objTipY - slope * (vertexX - endX);
        drawArrow(canvas, vertexX, objTipY, endX, endY, const Color(0xFF38BDF8),
            arrowSize: 8);
        drawDashedLine(canvas, vertexX, objTipY, fX, axisY,
            const Color(0xFF38BDF8),
            width: 1.5);
      }

      // RAY 2: through C
      if (isConcave) {
        final slopeC = (objTipY - axisY) / (objX - cX);
        final hitX = vertexX;
        final hitY = axisY + slopeC * (hitX - cX);
        drawArrow(canvas, objX, objTipY, hitX, hitY, const Color(0xFF10B981),
            arrowSize: 8);
        drawArrow(canvas, hitX, hitY, 40, axisY + slopeC * (40 - cX),
            const Color(0xFF10B981),
            arrowSize: 8);
        if (di < 0) {
          drawDashedLine(canvas, hitX, hitY, imgX, imgTipY,
              const Color(0xFF10B981),
              width: 1.5);
        }
      } else {
        final slopeC = (axisY - objTipY) / (cX - objX);
        final hitY = objTipY + slopeC * (vertexX - objX);
        drawArrow(canvas, objX, objTipY, vertexX, hitY, const Color(0xFF10B981),
            arrowSize: 8);
        drawArrow(
            canvas,
            vertexX,
            hitY,
            40,
            hitY - slopeC * (vertexX - 40),
            const Color(0xFF10B981),
            arrowSize: 8);
        drawDashedLine(canvas, vertexX, hitY, cX, axisY, const Color(0xFF10B981),
            width: 1.5);
      }

      // RAY 3: toward F -> parallel
      if (isConcave && (objX - fX).abs() > 4) {
        final slopeF = (axisY - objTipY) / (fX - objX);
        final hitY = objTipY + slopeF * (vertexX - objX);
        drawArrow(canvas, objX, objTipY, vertexX, hitY, const Color(0xFFF43F5E),
            arrowSize: 8);
        drawArrow(canvas, vertexX, hitY, 40, hitY, const Color(0xFFF43F5E),
            arrowSize: 8);
        if (di < 0) {
          drawDashedLine(canvas, vertexX, hitY, imgX, hitY,
              const Color(0xFFF43F5E),
              width: 1.5);
        }
      }

      // Image
      final isVirtual = di < 0;
      final imgColor = isVirtual ? const Color(0xFFEC4899) : const Color(0xFF06B6D4);
      if (objImg != null) {
        drawSpriteImage(canvas, objImg, imgX, axisY, imgTipY, imgColor,
            isVirtual: isVirtual, flipX: true);
      } else {
        drawImageArrow(canvas, imgX, axisY, imgTipY, imgColor,
            isVirtual ? 'Virtual Image' : 'Real Image',
            isDashed: isVirtual);
      }
    }

    if (atInfinity) {
      natureText = 'At Infinity (No image formed)';
    } else {
      final typeStr = di > 0 ? 'Real' : 'Virtual';
      final orientStr = magnification > 0 ? 'Upright' : 'Inverted';
      final sizeStr = magnification.abs() > 1.02
          ? 'Magnified'
          : magnification.abs() < 0.98
              ? 'Diminished'
              : 'Same size';
      natureText = '$typeStr, $orientStr, $sizeStr';
    }
  }

  @override
  String get headline => natureText;

  @override
  List<(String, String)> get readoutRows => [
        ('Focal Length (f)',
            '${type == MirrorType.concave ? '+' : '-'}${focalLength.toStringAsFixed(0)} px'),
        ('Image Distance (di)',
            atInfinity ? '∞ (Parallel)' : '${di.toStringAsFixed(1)} px'),
        ('Magnification (m)', atInfinity ? '—' : magnification.toStringAsFixed(2)),
        ('Image Nature', natureText),
      ];
}