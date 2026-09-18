import 'dart:ui';

import 'base_optics_game.dart';
import 'painters.dart';
import 'sprites.dart';

enum LensType { convex, concave }

class ThinLensGame extends BaseOpticsGame {
  LensType type = LensType.convex;
  double focalLength = 75;
  double objectDistance = 180;
  double objectHeight = 70;
  ObjectSprite sprite = ObjectSprite.candle;

  double di = 0;
  double magnification = 0;
  String natureText = '—';
  bool atInfinity = false;

  @override
  Future<void> onLoad() async {
    preloadSprites([
      SpriteAssets.candle,
      SpriteAssets.pencil,
      SpriteAssets.pen,
      SpriteAssets.book,
    ]);
  }

  void setType(LensType t) {
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
    final lensX = gw * 0.56;
    final axisY = gh / 2;
    objectDistance = (lensX - x).clamp(40, 420).toDouble();
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
    final lensX = gw * 0.56;
    final isConvex = type == LensType.convex;
    final fSigned = isConvex ? focalLength : -focalLength;
    final doVal = objectDistance;
    final hoVal = objectHeight;

    _solve(fSigned, doVal);
    final hiVal = magnification * hoVal;

    final objX = lensX - doVal;
    final objTipY = axisY - hoVal;

    final f1X = lensX - fSigned;
    final f2X = lensX + fSigned;

    final axisPaint = Paint()
      ..color = const Color(0xFF475569)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(30, axisY), Offset(gw - 30, axisY), axisPaint);

    // Lens symbol
    canvas.drawLine(Offset(lensX, axisY - 170), Offset(lensX, axisY + 170),
        Paint()
          ..color = const Color(0xFF38BDF8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3);
    const tipLen = 14.0;
    if (isConvex) {
      drawArrow(canvas, lensX, axisY - 150, lensX, axisY - 170,
          const Color(0xFF38BDF8),
          arrowSize: tipLen, width: 3);
      drawArrow(canvas, lensX, axisY + 150, lensX, axisY + 170,
          const Color(0xFF38BDF8),
          arrowSize: tipLen, width: 3);
    } else {
      drawArrow(canvas, lensX, axisY - 170, lensX, axisY - 150,
          const Color(0xFF38BDF8),
          arrowSize: tipLen, width: 3);
      drawArrow(canvas, lensX, axisY + 170, lensX, axisY + 150,
          const Color(0xFF38BDF8),
          arrowSize: tipLen, width: 3);
    }

    drawFocalMarker(canvas, f1X, axisY, isConvex ? 'F₁' : 'F₂');
    drawFocalMarker(canvas, f2X, axisY, isConvex ? 'F₂' : 'F₁');
    drawFocalMarker(canvas, lensX, axisY, 'O');

    final objImg = objectImage(sprite);
    if (objImg != null) {
      drawSpriteObject(canvas, objImg, objX, axisY, objTipY,
          label: 'Object (Drag)');
    } else {
      drawObjectArrow(canvas, objX, axisY, objTipY, const Color(0xFFFACC15),
          'Object (Drag)');
    }

    if (!atInfinity) {
      final imgX = lensX + di;
      final imgTipY = axisY - hiVal;

      // RAY 1: parallel -> through rear focus
      final rayPaint = Paint()
        ..color = const Color(0xFF38BDF8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawLine(Offset(objX, objTipY), Offset(lensX, objTipY), rayPaint);

      if (isConvex) {
        final slope1 = (axisY - objTipY) / (f2X - lensX);
        final rightX = gw - 40;
        final rightY = objTipY + slope1 * (rightX - lensX);
        drawArrow(canvas, lensX, objTipY, rightX, rightY,
            const Color(0xFF38BDF8),
            arrowSize: 8);
        if (di < 0) {
          drawDashedLine(canvas, lensX, objTipY, imgX, imgTipY,
              const Color(0xFF38BDF8),
              width: 1.5);
        }
      } else {
        final slope1 = (objTipY - axisY) / (lensX - f2X);
        final rightX = gw - 40;
        final rightY = objTipY + slope1 * (rightX - lensX);
        drawArrow(canvas, lensX, objTipY, rightX, rightY,
            const Color(0xFF38BDF8),
            arrowSize: 8);
        drawDashedLine(canvas, lensX, objTipY, f2X, axisY,
            const Color(0xFF38BDF8),
            width: 1.5);
      }

      // RAY 2: through optical center
      final slope2 = (axisY - objTipY) / (lensX - objX);
      final endR2X = gw - 40;
      final endR2Y = axisY + slope2 * (endR2X - lensX);
      drawArrow(canvas, objX, objTipY, endR2X, endR2Y, const Color(0xFF10B981),
          arrowSize: 8);
      if (di < 0) {
        drawDashedLine(canvas, objX, objTipY, imgX, imgTipY,
            const Color(0xFF10B981),
            width: 1.5);
      }

      // RAY 3: through front focus -> parallel
      if (isConvex && (objX - f1X).abs() > 4) {
        final slope3 = (axisY - objTipY) / (f1X - objX);
        final hitY = objTipY + slope3 * (lensX - objX);
        drawArrow(canvas, objX, objTipY, lensX, hitY, const Color(0xFFF43F5E),
            arrowSize: 8);
        drawArrow(canvas, lensX, hitY, gw - 40, hitY, const Color(0xFFF43F5E),
            arrowSize: 8);
        if (di < 0) {
          drawDashedLine(canvas, lensX, hitY, imgX, imgTipY,
              const Color(0xFFF43F5E),
              width: 1.5);
        }
      } else if (!isConvex) {
        final slope3 = (axisY - objTipY) / (f1X - objX);
        final hitY = objTipY + slope3 * (lensX - objX);
        drawArrow(canvas, objX, objTipY, lensX, hitY, const Color(0xFFF43F5E),
            arrowSize: 8);
        drawArrow(canvas, lensX, hitY, gw - 40, hitY, const Color(0xFFF43F5E),
            arrowSize: 8);
        drawDashedLine(canvas, lensX, hitY, f1X, axisY,
            const Color(0xFFF43F5E),
            width: 1.5);
        drawDashedLine(canvas, lensX, hitY, imgX, imgTipY,
            const Color(0xFFF43F5E),
            width: 1.5);
      }

      final isVirtual = di < 0;
      final imgColor = isVirtual ? const Color(0xFFEC4899) : const Color(0xFF06B6D4);
      if (objImg != null) {
        drawSpriteImage(canvas, objImg, imgX, axisY, imgTipY, imgColor,
            isVirtual: isVirtual);
      } else {
        drawImageArrow(canvas, imgX, axisY, imgTipY, imgColor,
            isVirtual ? 'Virtual Image' : 'Real Image',
            isDashed: isVirtual);
      }
    }

    if (atInfinity) {
      natureText = 'Rays parallel (No image)';
    } else {
      final vStr = di > 0 ? 'Real' : 'Virtual';
      final oStr = magnification > 0 ? 'Upright' : 'Inverted';
      final sStr = magnification.abs() > 1.02
          ? 'Magnified'
          : magnification.abs() < 0.98
              ? 'Diminished'
              : 'Same size';
      natureText = '$vStr, $oStr, $sStr';
    }
  }

  @override
  String get headline => natureText;

  @override
  List<(String, String)> get readoutRows => [
        ('Focal Length (f)',
            '${type == LensType.convex ? '+' : '-'}${focalLength.toStringAsFixed(0)} px'),
        ('Image Distance (di)',
            atInfinity ? '∞ (At Infinity)' : '${di.toStringAsFixed(1)} px'),
        ('Magnification (m)', atInfinity ? '—' : magnification.toStringAsFixed(2)),
        ('Image Nature', natureText),
      ];
}