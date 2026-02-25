import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/wave_provider.dart';
import '../physics/wave_solver.dart';

class OscilloscopePanel extends ConsumerWidget {
  const OscilloscopePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(waveProvider);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF020810),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF00E5FF).withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CustomPaint(
          painter: TechnicalBlueprintPainter(state: state),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class TechnicalBlueprintPainter extends CustomPainter {
  final WaveState state;

  // ── Shared layout constants ──
  static const double _numCycles = 1.5;
  static const double _bracketRightMargin = 20.0;
  static const double _waveSpeedDivisor = 10.0;

  TechnicalBlueprintPainter({required this.state});

  // ── Pre-compute shared values once per paint ──
  double _visualAmplitude() => state.amplitude * 15;

  double _wavelength() => state.waveSpeed / state.frequency;

  double _pixelsPerMeter(double width) => width / (_wavelength() * _numCycles);

  double _visualWavelength(double width) =>
      _wavelength() * _pixelsPerMeter(width);

  /// Find first crest X using the SAME waveSpeed divisor as _drawWaveTrace.
  /// Previously this was inconsistent — now both use waveSpeed / _waveSpeedDivisor.
  double _findFirstCrestX(Size size) {
    final ppm = _pixelsPerMeter(size.width);
    final searchRange = (_visualWavelength(size.width) + 20).clamp(
      0.0,
      size.width,
    );

    double firstCrestX = 0;
    double maxDisplacement = -double.infinity;

    for (double x = 0; x <= searchRange; x++) {
      final physicalX = x / ppm;
      final y = WaveSolver.calculateDisplacement(
        amplitude: 1.0,
        frequency: state.frequency,
        waveSpeed: state.waveSpeed / _waveSpeedDivisor, // ✅ consistent
        x: physicalX,
        t: state.currentTime,
        isDampingEnabled: state.isDampingEnabled,
      );
      if (y > maxDisplacement) {
        maxDisplacement = y;
        firstCrestX = x;
      }
    }
    return firstCrestX;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Pre-compute shared layout values once — avoids duplicate O(width) loops.
    final double visualAmplitude = _visualAmplitude();
    final double pixelsPerMeter = _pixelsPerMeter(size.width);
    final double visualWavelength = _visualWavelength(size.width);
    final double crestX = _findFirstCrestX(size);

    _drawGrid(canvas, size);
    _drawWaveTrace(canvas, size, pixelsPerMeter);
    _drawAmplitudeAnnotations(canvas, size, visualAmplitude);
    _drawWavelengthAnnotations(
      canvas,
      size,
      visualAmplitude,
      visualWavelength,
      crestX,
    );
    _drawVelocityAnnotations(canvas, size);
    _drawBadges(canvas, size, visualWavelength, crestX);
  }

  // ─────────────────────────────────────────────────────────────
  // GRID
  // ─────────────────────────────────────────────────────────────
  void _drawGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1.0;

    const double step = 20.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final axisPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      axisPaint,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // WAVE TRACE
  // ─────────────────────────────────────────────────────────────
  void _drawWaveTrace(Canvas canvas, Size size, double pixelsPerMeter) {
    final path = Path();
    final centerY = size.height / 2;
    final double visualAmp = _visualAmplitude();

    for (double x = 0; x <= size.width; x++) {
      final physicalX = x / pixelsPerMeter;
      final y = WaveSolver.calculateDisplacement(
        amplitude: visualAmp,
        frequency: state.frequency,
        waveSpeed: state.waveSpeed / _waveSpeedDivisor, // consistent divisor
        x: physicalX,
        t: state.currentTime,
        isDampingEnabled: state.isDampingEnabled,
      );

      if (x == 0) {
        path.moveTo(x, centerY - y);
      } else {
        path.lineTo(x, centerY - y);
      }
    }

    // Glow pass
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF00E5FF).withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0),
    );
    // Solid pass
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF00E5FF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // AMPLITUDE ANNOTATIONS  (+A / −A / 2A bracket)
  // ─────────────────────────────────────────────────────────────
  void _drawAmplitudeAnnotations(
    Canvas canvas,
    Size size,
    double visualAmplitude,
  ) {
    final centerY = size.height / 2;
    final double bracketX = size.width - _bracketRightMargin;

    // Dashed ±A reference lines — stop at bracket, not full width
    final dashPaint = Paint()
      ..color = Colors.greenAccent.withValues(alpha: 0.4)
      ..strokeWidth = 1.0;

    _drawDashedLine(
      canvas,
      Offset(0, centerY - visualAmplitude),
      Offset(bracketX, centerY - visualAmplitude), // ✅ ends at bracket
      dashPaint,
    );
    _drawDashedLine(
      canvas,
      Offset(0, centerY + visualAmplitude),
      Offset(bracketX, centerY + visualAmplitude), // ✅ ends at bracket
      dashPaint,
    );

    // Right-side vertical bracket
    final bracketPaint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 1.5;

    canvas.drawLine(
      Offset(bracketX, centerY - visualAmplitude),
      Offset(bracketX, centerY + visualAmplitude),
      bracketPaint,
    );
    _drawSmallArrowHead(
      canvas,
      Offset(bracketX, centerY - visualAmplitude),
      true,
      bracketPaint,
    );
    _drawSmallArrowHead(
      canvas,
      Offset(bracketX, centerY + visualAmplitude),
      false,
      bracketPaint,
    );

    // 2A label beside bracket midpoint
    _drawText(
      canvas,
      "2A",
      Offset(bracketX + 5, centerY - 8),
      const TextStyle(
        color: Colors.greenAccent,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    );

    // ±A and 0 labels on the left
    final labelStyle = TextStyle(
      color: Colors.greenAccent.withValues(alpha: 0.6),
      fontSize: 8,
    );
    _drawText(
      canvas,
      "+A",
      Offset(5, centerY - visualAmplitude - 12),
      labelStyle,
    );
    _drawText(canvas, "0", Offset(5, centerY - 5), labelStyle);
    _drawText(
      canvas,
      "−A",
      Offset(5, centerY + visualAmplitude + 2),
      labelStyle,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // WAVELENGTH ANNOTATIONS  (λ bracket below wave)
  // ─────────────────────────────────────────────────────────────
  void _drawWavelengthAnnotations(
    Canvas canvas,
    Size size,
    double visualAmplitude,
    double visualWavelength,
    double crestX,
  ) {
    final centerY = size.height / 2;
    final startX = crestX;
    final endX = startX + visualWavelength;
    final lineY = centerY + visualAmplitude + 25;

    if (startX >= size.width || endX >= size.width) return;

    // Vertical guide lines from crests down to bracket
    final guidePaint = Paint()
      ..color = Colors.pinkAccent.withValues(alpha: 0.3)
      ..strokeWidth = 1.0;
    _drawDashedLine(
      canvas,
      Offset(startX, centerY - visualAmplitude),
      Offset(startX, lineY),
      guidePaint,
    );
    _drawDashedLine(
      canvas,
      Offset(endX, centerY - visualAmplitude),
      Offset(endX, lineY),
      guidePaint,
    );

    // Horizontal bracket line — separate paint instance, no mutation
    final bracketPaint = Paint()
      ..color = Colors.pinkAccent
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(startX, lineY), Offset(endX, lineY), bracketPaint);

    _drawSmallHorizontalArrowHead(
      canvas,
      Offset(startX, lineY),
      true,
      bracketPaint,
    );
    _drawSmallHorizontalArrowHead(
      canvas,
      Offset(endX, lineY),
      false,
      bracketPaint,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // VELOCITY ARROW
  // ─────────────────────────────────────────────────────────────
  void _drawVelocityAnnotations(Canvas canvas, Size size) {
    final vPaint = Paint()
      ..color = Colors.orangeAccent
      ..strokeWidth = 2.0;

    const double arrowY = 25.0;
    const double arrowLen = 70.0;
    final double startX = size.width * 0.45;

    canvas.drawLine(
      Offset(startX, arrowY),
      Offset(startX + arrowLen, arrowY),
      vPaint,
    );
    _drawSmallHorizontalArrowHead(
      canvas,
      Offset(startX + arrowLen, arrowY),
      false,
      vPaint,
    );

    _drawText(
      canvas,
      "v",
      Offset(startX - 15, arrowY - 8),
      const TextStyle(
        color: Colors.orangeAccent,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // BADGES  (small labelled chips)
  // ─────────────────────────────────────────────────────────────
  void _drawBadges(
    Canvas canvas,
    Size size,
    double visualWavelength,
    double crestX,
  ) {
    // A — top-left
    _drawBadge(canvas, "A", const Offset(15, 15), Colors.greenAccent);

    // λ — centred above the bracket
    _drawBadge(
      canvas,
      "λ",
      Offset(crestX + visualWavelength / 2 - 10, size.height - 45),
      Colors.pinkAccent,
    );

    // v → — top-right
    _drawBadge(canvas, "v →", Offset(size.width - 55, 15), Colors.orangeAccent);

    // T = 1/f — bottom-right
    _drawBadge(
      canvas,
      "T = 1/f",
      Offset(size.width - 75, size.height - 40),
      Colors.amberAccent,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────────────────────
  void _drawBadge(Canvas canvas, String label, Offset position, Color color) {
    final textStyle = TextStyle(
      color: color,
      fontSize: 9,
      fontWeight: FontWeight.bold,
    );
    final tp = TextPainter(
      text: TextSpan(text: label, style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    const padding = EdgeInsets.symmetric(horizontal: 5, vertical: 2);
    final rect = Rect.fromLTWH(
      position.dx,
      position.dy,
      tp.width + padding.horizontal,
      tp.height + padding.vertical,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(3)),
      Paint()
        ..color = color.withValues(alpha: 0.1)
        ..style = PaintingStyle.fill,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(3)),
      Paint()
        ..color = color.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    tp.paint(
      canvas,
      Offset(position.dx + padding.left, position.dy + padding.top),
    );
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const double dashWidth = 3.0;
    const double dashSpace = 3.0;
    final double distance = (p2 - p1).distance;
    if (distance == 0) return;
    final double dx = (p2.dx - p1.dx) / distance;
    final double dy = (p2.dy - p1.dy) / distance;
    double d = 0;
    while (d < distance) {
      final double end = (d + dashWidth).clamp(0.0, distance);
      canvas.drawLine(
        Offset(p1.dx + dx * d, p1.dy + dy * d),
        Offset(p1.dx + dx * end, p1.dy + dy * end),
        paint,
      );
      d += dashWidth + dashSpace;
    }
  }

  void _drawSmallArrowHead(Canvas canvas, Offset tip, bool isTop, Paint paint) {
    const double s = 4.0;
    final double dy = isTop ? s : -s;
    canvas.drawLine(tip, Offset(tip.dx - s, tip.dy + dy), paint);
    canvas.drawLine(tip, Offset(tip.dx + s, tip.dy + dy), paint);
  }

  void _drawSmallHorizontalArrowHead(
    Canvas canvas,
    Offset tip,
    bool isLeft,
    Paint paint,
  ) {
    const double s = 4.0;
    final double dx = isLeft ? s : -s;
    canvas.drawLine(tip, Offset(tip.dx + dx, tip.dy - s), paint);
    canvas.drawLine(tip, Offset(tip.dx + dx, tip.dy + s), paint);
  }

  void _drawText(Canvas canvas, String text, Offset position, TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, position);
  }

  // ─────────────────────────────────────────────────────────────
  // REPAINT  — ✅ includes currentTime and isDampingEnabled
  // Previously the wave appeared frozen because these were missing
  // ─────────────────────────────────────────────────────────────
  @override
  bool shouldRepaint(covariant TechnicalBlueprintPainter oldDelegate) {
    final o = oldDelegate.state;
    final n = state;
    return o.amplitude != n.amplitude ||
        o.frequency != n.frequency ||
        o.waveSpeed != n.waveSpeed ||
        o.currentTime != n.currentTime || // ✅ animation repaints
        o.isDampingEnabled != n.isDampingEnabled; // ✅ damping toggle repaints
  }
}
