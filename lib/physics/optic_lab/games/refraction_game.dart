import 'dart:math' as math;
import 'dart:ui';

import 'base_optics_game.dart';
import 'painters.dart';

class RefractionGame extends BaseOpticsGame {
  double n1 = 1.0;
  double n2 = 1.52;
  double theta1 = 45; // degrees

  double theta2 = 0;
  double criticalAngle = 0;
  bool isTir = false;

  @override
  Future<void> onLoad() async {}

  void setN1(double v) {
    n1 = v;
    uiChanged();
  }

  void setN2(double v) {
    n2 = v;
    uiChanged();
  }

  void setTheta1(double v) {
    theta1 = v;
    uiChanged();
  }

  @override
  void startDrag(double x, double y) {
    updateDrag(x, y);
  }

  @override
  void updateDrag(double x, double y) {
    final cx = gw / 2;
    final rayLength = math.min(gw, gh) * 0.42;
    final ratio = ((cx - x) / rayLength).clamp(-1.0, 1.0);
    theta1 = radToDeg(math.asin(ratio)).clamp(0.0, 89.0).toDouble();
    uiChanged();
  }

  @override
  void renderScene(Canvas canvas) {
    clearCanvas(canvas);
    final cy = gh / 2;
    final cx = gw / 2;

    // Medium backgrounds
    canvas.drawRect(Rect.fromLTWH(0, 0, gw, cy),
        Paint()..color = const Color(0xFF0F172A));
    canvas.drawRect(Rect.fromLTWH(0, cy, gw, gh - cy),
        Paint()..color = const Color(0xFF1E293B));

    // Interface line
    canvas.drawLine(Offset(0, cy), Offset(gw, cy),
        Paint()
          ..color = const Color(0xFF38BDF8)
          ..strokeWidth = 2);

    paintText(canvas, 'Medium 1 (n₁ = ${n1.toStringAsFixed(3)})', 24, 34,
        const Color(0xFF94A3B8),
        size: 13, bold: true);
    paintText(canvas, 'Medium 2 (n₂ = ${n2.toStringAsFixed(3)})', 24, cy + 34,
        const Color(0xFF94A3B8),
        size: 13, bold: true);

    drawDashedLine(canvas, cx, 30, cx, gh - 30, const Color(0xFFCBD5E1),
        pattern: const [6, 6]);

    final theta1Rad = degToRad(theta1);
    final sinTheta2 = (n1 / n2) * math.sin(theta1Rad);
    isTir = sinTheta2 > 1.0;

    if (n1 > n2) {
      criticalAngle = radToDeg(math.asin(n2 / n1));
    } else {
      criticalAngle = 0; // n/a
    }

    final rayLength = math.min(gw, gh) * 0.42;
    final incX = cx - rayLength * math.sin(theta1Rad);
    final incY = cy - rayLength * math.cos(theta1Rad);

    drawArrow(canvas, incX, incY, cx, cy, const Color(0xFFFBBF24),
        arrowSize: 12, width: 3);

    // Laser emitter box
    canvas.drawRect(Rect.fromLTWH(incX - 12, incY - 8, 24, 16),
        Paint()..color = const Color(0xFFEAB308));
    paintText(canvas, 'LASER', incX - 15, incY + 4, const Color(0xFF000000),
        size: 9);
    paintText(canvas, 'Drag', incX - 10, incY + 18, const Color(0xFF94A3B8),
        size: 9);

    drawAngleArc(
      canvas,
      cx,
      cy,
      -math.pi / 2 - theta1Rad,
      -math.pi / 2,
      50,
      'θ₁=${theta1.toStringAsFixed(1)}°',
      const Color(0xFFFBBF24),
    );

    final refX = cx + rayLength * math.sin(theta1Rad);
    final refY = cy - rayLength * math.cos(theta1Rad);
    final refAlpha = isTir ? 1.0 : 0.35;
    final refColor = Color.fromRGBO(
      244,
      63,
      94,
      refAlpha,
    );
    drawArrow(canvas, cx, cy, refX, refY, refColor,
        arrowSize: 10, width: isTir ? 3.5 : 2);
    paintText(canvas, 'Reflected (θᵣ = ${theta1.toStringAsFixed(1)}°)',
        refX - 40, refY - 12, refColor,
        size: 11);

    if (!isTir) {
      final t2 = math.asin(sinTheta2);
      final t2Deg = radToDeg(t2);
      theta2 = t2Deg;
      final refrX = cx + rayLength * math.sin(t2);
      final refrY = cy + rayLength * math.cos(t2);
      drawArrow(canvas, cx, cy, refrX, refrY, const Color(0xFF38BDF8),
          arrowSize: 12, width: 3.5);
      drawAngleArc(canvas, cx, cy, math.pi / 2 - t2, math.pi / 2, 50,
          'θ₂=${t2Deg.toStringAsFixed(1)}°', const Color(0xFF38BDF8));
    } else {
      paintText(canvas, '⚡ Total Internal Reflection (θ₁ > θc)', cx + 30,
          cy - 40, const Color(0xFFF87171),
          size: 14, bold: true);
    }
  }

  @override
  String get headline => isTir ? '⚡ TOTAL INTERNAL REFLECTION' : 'Normal Refraction';

  @override
  List<(String, String)> get readoutRows => [
        ('Incident Angle (θ₁)', '${theta1.toStringAsFixed(1)}°'),
        ('Refracted Angle (θ₂)',
            isTir ? 'None (TIR)' : '${theta2.toStringAsFixed(1)}°'),
        ('Critical Angle (θc)',
            n1 > n2 ? '${criticalAngle.toStringAsFixed(1)}°' : 'None (n₁ ≤ n₂)'),
        ('Status', isTir ? '⚡ TOTAL INTERNAL REFLECTION' : 'Normal Refraction'),
      ];
}