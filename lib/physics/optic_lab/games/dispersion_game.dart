import 'dart:math' as math;
import 'dart:ui';

import 'base_optics_game.dart';
import 'painters.dart';

class DispersionGame extends BaseOpticsGame {
  DispersionGame({required super.l10n});

  double apexAngle = 60; // degrees
  double beamYOffset = -10;
  double baseN = 1.54;

  double redN = 1.525;
  double greenN = 1.54;
  double violetN = 1.572;

  @override
  Future<void> onLoad() async {}

  void setApexAngle(double v) {
    apexAngle = v;
    uiChanged();
  }

  void setBeamYOffset(double v) {
    beamYOffset = v;
    uiChanged();
  }

  void setBaseN(double v) {
    baseN = v;
    uiChanged();
  }

  @override
  void renderScene(Canvas canvas) {
    clearCanvas(canvas);
    final cx = gw * 0.45;
    final cy = gh * 0.52;
    const prismSide = 240.0;
    final apexRad = degToRad(apexAngle);

    final halfApex = apexRad / 2;
    final top = Offset(cx, cy - (prismSide / 2) * math.cos(halfApex));
    final left = Offset(cx - prismSide / 2, cy + (prismSide / 2) * math.cos(halfApex));
    final right = Offset(cx + prismSide / 2, cy + (prismSide / 2) * math.cos(halfApex));

    final prismPath = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(left.dx, left.dy)
      ..lineTo(right.dx, right.dy)
      ..close();
    canvas.drawPath(
        prismPath, Paint()..color = const Color(0x1F38BDF8));
    canvas.drawPath(prismPath,
        Paint()
          ..color = const Color(0xFF38BDF8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5);

    const spectrum = <(String, double, Color, double)>[
      ('Red', 700.0, Color(0xFFEF4444), -0.015),
      ('Orange', 610.0, Color(0xFFF97316), -0.007),
      ('Yellow', 580.0, Color(0xFFEAB308), 0.000),
      ('Green', 530.0, Color(0xFF22C55E), 0.008),
      ('Blue', 470.0, Color(0xFF06B6D4), 0.018),
      ('Violet', 400.0, Color(0xFFA855F7), 0.032),
    ];

    final beamY = cy + beamYOffset;
    const beamStartX = 40.0;

    final face1Slope = (left.dy - top.dy) / (left.dx - top.dx);
    final face1Intercept = top.dy - face1Slope * top.dx;
    final hit1X = (beamY - face1Intercept) / face1Slope;
    final hit1Y = beamY;

    final beamPaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    canvas.drawLine(Offset(beamStartX, beamY), Offset(hit1X, hit1Y), beamPaint);
    paintText(canvas, l10n.opticWhiteLightBeam, beamStartX + 10, beamY - 10,
        const Color(0xFFFFFFFF),
        size: 12, bold: true);

    final face1Angle = math.atan2(left.dy - top.dy, left.dx - top.dx);
    final normal1 = face1Angle - math.pi / 2;
    final theta1 = normal1 - math.pi;
    final absTheta1 = theta1.abs();

    final face2Slope = (right.dy - top.dy) / (right.dx - top.dx);
    final face2Intercept = top.dy - face2Slope * top.dx;
    final face2Angle = math.atan2(right.dy - top.dy, right.dx - top.dx);
    final normal2 = face2Angle + math.pi / 2;

    for (final band in spectrum) {
      final n = baseN + band.$4;
      final sinTheta2 = math.sin(absTheta1) / n;
      final theta2 = math.asin(math.min(1.0, sinTheta2));
      final internalAngle =
          normal1 - math.pi + (theta1 > 0 ? -theta2 : theta2);

      final raySlope = math.tan(internalAngle);
      final hit2X = (hit1Y - raySlope * hit1X - face2Intercept) /
          (face2Slope - raySlope);
      final hit2Y = face2Slope * hit2X + face2Intercept;

      final internalPaint = Paint()
        ..color = band.$3
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawLine(Offset(hit1X, hit1Y), Offset(hit2X, hit2Y), internalPaint);

      final rayIncFace2 = internalAngle;
      final theta3 = normal2 - math.pi - rayIncFace2;
      final sinTheta4 = n * math.sin(theta3);
      if (sinTheta4.abs() <= 1.0) {
        final theta4 = math.asin(sinTheta4);
        final exitAngle = normal2 - math.pi - theta4;
        final screenX = gw - 40;
        final screenY = hit2Y + math.tan(exitAngle) * (screenX - hit2X);
        drawArrow(canvas, hit2X, hit2Y, screenX, screenY, band.$3,
            arrowSize: 7, width: 2.4);
      }
    }

    final screenPaint = Paint()
      ..color = const Color(0xFF64748B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    canvas.drawLine(Offset(gw - 40, cy - 140), Offset(gw - 40, cy + 140),
        screenPaint);
    paintText(canvas, l10n.opticScreenLabel, gw - 55, cy - 150, const Color(0xFF94A3B8),
        size: 11);

    redN = baseN - 0.015;
    greenN = baseN;
    violetN = baseN + 0.032;
  }

  @override
  String get headline => l10n.opticDispersionHeadline;

  @override
  List<(String, String)> get readoutRows => [
        (l10n.opticRedBand, 'n ≈ ${redN.toStringAsFixed(3)}'),
        (l10n.opticGreenBand, 'n ≈ ${greenN.toStringAsFixed(3)}'),
        (l10n.opticVioletBand, 'n ≈ ${violetN.toStringAsFixed(3)}'),
        (l10n.opticDispersionRow, l10n.opticDispersionSummary),
      ];
}