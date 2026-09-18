import 'dart:math' as math;
import 'dart:ui';

import 'base_optics_game.dart';
import 'painters.dart';
import 'sprites.dart';

class PlaneMirrorGame extends BaseOpticsGame {
  PlaneMirrorGame({required super.l10n});

  double sourceX = 180;
  double sourceY = 180;
  double mirrorAngle = 90; // degrees
  double incidentAngle = 35; // degrees
  ObjectSprite sprite = ObjectSprite.arrow;

  double thetaI = 35;
  double thetaR = 35;

  @override
  Future<void> onLoad() async {
    preloadSprites([
      SpriteAssets.mirrorStrip,
      SpriteAssets.candle,
      SpriteAssets.pencil,
      SpriteAssets.pen,
      SpriteAssets.book,
    ]);
  }

  void setMirrorAngle(double v) {
    mirrorAngle = v;
    uiChanged();
  }

  void setLightAngle(double v) {
    incidentAngle = v;
    final cx = gw / 2;
    final cy = gh / 2;
    final rad = degToRad(v + 180);
    sourceX = cx + 220 * math.cos(rad);
    sourceY = cy - 220 * math.sin(rad);
    uiChanged();
  }

  void setSprite(ObjectSprite s) {
    sprite = s;
    uiChanged();
  }

  @override
  void updateDrag(double x, double y) {
    sourceX = x.clamp(30, gw - 30).toDouble();
    sourceY = y.clamp(30, gh - 30).toDouble();
    uiChanged();
  }

  @override
  void renderScene(Canvas canvas) {
    clearCanvas(canvas);
    final cx = gw / 2;
    final cy = gh / 2;
    final mirrorLength = math.min(gw, gh) * 0.58;
    final mirrorRad = degToRad(mirrorAngle);

    final mx1 = cx - (mirrorLength / 2) * math.cos(mirrorRad);
    final my1 = cy - (mirrorLength / 2) * math.sin(mirrorRad);
    final mx2 = cx + (mirrorLength / 2) * math.cos(mirrorRad);
    final my2 = cy + (mirrorLength / 2) * math.sin(mirrorRad);
    final normalAngle = mirrorRad + math.pi / 2;

    final strip = sprites.get(SpriteAssets.mirrorStrip);
    if (strip != null) {
      final imgH = mirrorLength;
      final imgW = imgH * strip.width / strip.height;
      canvas.save();
      canvas.translate(cx, cy);
      canvas.rotate(mirrorRad - math.pi / 2);
      drawImageRect(canvas, strip,
          Rect.fromCenter(center: Offset.zero, width: imgW, height: imgH));
      canvas.restore();
    } else {
      final line = Paint()
        ..color = const Color(0xFF94A3B8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6;
      canvas.drawLine(Offset(mx1, my1), Offset(mx2, my2), line);
      final hatchLen = 9.0;
      final hatch = Paint()
        ..color = const Color(0xFF475569)
        ..strokeWidth = 1;
      const steps = 24;
      for (var i = 0; i <= steps; i++) {
        final px = mx1 + (mx2 - mx1) * i / steps;
        final py = my1 + (my2 - my1) * i / steps;
        canvas.drawLine(Offset(px, py),
            Offset(px + hatchLen * math.cos(normalAngle),
                py + hatchLen * math.sin(normalAngle)),
            hatch);
      }
    }

    // Normal line
    drawDashedLine(
        canvas,
        cx - 180 * math.cos(normalAngle),
        cy - 180 * math.sin(normalAngle),
        cx + 180 * math.cos(normalAngle),
        cy + 180 * math.sin(normalAngle),
        const Color(0xFFCBD5E1),
        pattern: const [6, 6]);

    final sx = sourceX;
    final sy = sourceY;
    final incDx = cx - sx;
    final incDy = cy - sy;
    final incAngle = math.atan2(incDy, incDx);

    final nFront = normalAngle - math.pi;
    var thetaIX = (incAngle - nFront).abs();
    while (thetaIX > math.pi) {
      thetaIX = (thetaIX - 2 * math.pi).abs();
    }
    if (thetaIX > math.pi / 2) thetaIX = math.pi - thetaIX;
    final thetaIDeg = radToDeg(thetaIX);
    final thetaRDeg = thetaIDeg;

    final normUx = math.cos(nFront);
    final normUy = math.sin(nFront);
    final incLen = math.sqrt(incDx * incDx + incDy * incDy);
    final rayUx = incDx / incLen;
    final rayUy = incDy / incLen;
    final dot = rayUx * normUx + rayUy * normUy;
    final refUx = rayUx - 2 * dot * normUx;
    final refUy = rayUy - 2 * dot * normUy;

    const rayDist = 260.0;
    final rx = cx + refUx * rayDist;
    final ry = cy + refUy * rayDist;

    drawArrow(canvas, sx, sy, cx, cy, const Color(0xFFFBBF24),
        arrowSize: 12, width: 2.5);
    drawArrow(canvas, cx, cy, rx, ry, const Color(0xFF38BDF8),
        arrowSize: 12, width: 2.5);

    final vx = cx - refUx * rayDist * 0.85;
    final vy = cy - refUy * rayDist * 0.85;
    drawDashedLine(canvas, cx, cy, vx, vy, const Color(0xFFA855F7),
        pattern: const [4, 4]);

    final perpDist = (sx - cx) * normUx + (sy - cy) * normUy;
    final imageX = sx - 2 * perpDist * normUx;
    final imageY = sy - 2 * perpDist * normUy;
    drawDashedLine(canvas, sx, sy, imageX, imageY, const Color(0xFF64748B),
        pattern: const [3, 4]);

    final objImg = objectImage(sprite);
    if (objImg != null) {
      const objH = 56.0;
      final objW = objH * objImg.width / objImg.height;
      drawImageRect(canvas, objImg,
          Rect.fromCenter(center: Offset(sx, sy), width: objW, height: objH));
      canvas.drawCircle(Offset(sx, sy), 5, Paint()..color = const Color(0xFFFFFFFF));
      paintText(canvas, l10n.opticObjectDrag, sx - 38, sy - objH / 2 - 6,
          const Color(0xFFFACC15),
          size: 12);

      final imgH = 28.0;
      final imgW = imgH * objImg.width / objImg.height;
      canvas.save();
      canvas.translate(imageX, imageY);
      canvas.scale(-1, 1);
      drawImageRect(
          canvas,
          objImg,
          Rect.fromCenter(
              center: Offset.zero, width: imgW, height: imgH),
          alpha: 0.55);
      canvas.restore();
      paintText(canvas, l10n.opticVirtualImageLabel, imageX + 12, imageY + 4,
          const Color(0xFFCBD5E1),
          size: 11);
    } else {
      canvas.drawCircle(Offset(imageX, imageY), 8,
          Paint()..color = const Color(0x66A855F7));
      canvas.drawCircle(Offset(imageX, imageY), 8,
          Paint()..color = const Color(0xFFA855F7)..style = PaintingStyle.stroke);
      paintText(canvas, l10n.opticVirtualSourceLabel, imageX + 12, imageY + 4,
          const Color(0xFFCBD5E1),
          size: 11);

      canvas.drawCircle(Offset(sx, sy), 8, Paint()..color = const Color(0xFFF59E0B));
      canvas.drawCircle(Offset(sx, sy), 8,
          Paint()..color = const Color(0xFFFFFFFF)..style = PaintingStyle.stroke
            ..strokeWidth = 2);
      paintText(canvas, l10n.opticLightSourceDrag, sx - 45, sy - 14,
          const Color(0xFFCBD5E1),
          size: 11);
    }

    drawAngleArc(canvas, cx, cy, nFront, incAngle, 45,
        'θi = ${thetaIDeg.toStringAsFixed(1)}°', const Color(0xFFFBBF24));
    final refAngle = math.atan2(refUy, refUx);
    drawAngleArc(canvas, cx, cy, refAngle, nFront, 45,
        'θr = ${thetaRDeg.toStringAsFixed(1)}°', const Color(0xFF38BDF8));

    thetaI = thetaIDeg;
    thetaR = thetaRDeg;
  }

  @override
  String get headline =>
      'θi = ${thetaI.toStringAsFixed(1)}°   θr = ${thetaR.toStringAsFixed(1)}°';

  @override
  List<(String, String)> get readoutRows => [
        (l10n.opticAngleIncidenceRow, '${thetaI.toStringAsFixed(1)}°'),
        (l10n.opticAngleReflectionRow, '${thetaR.toStringAsFixed(1)}°'),
        (l10n.opticLawRow, 'θi = θr'),
      ];
}