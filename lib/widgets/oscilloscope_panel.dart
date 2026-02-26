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

  static const double _numCycles = 1.5;
  static const double _waveSpeedDivisor = 10.0;

  TechnicalBlueprintPainter({required this.state});

  // ── Pre-compute shared values once per paint ──
  double _visualAmplitude() => state.amplitude * 15;

  double _wavelength() => state.waveSpeed / state.frequency;

  @override
  void paint(Canvas canvas, Size size) {
    _drawGrid(canvas, size);
    _drawWaveTrace(canvas, size);
    _drawAmplitudeAnnotations(canvas, size);
    _drawPeriodAnnotations(canvas, size);
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
  void _drawWaveTrace(Canvas canvas, Size size) {
    final Path path = Path();
    final centerY = size.height / 2;
    final double visualAmp = _visualAmplitude();
    final double wavelength = _wavelength();
    final double pixelsPerMeter = size.width / (wavelength * _numCycles);

    for (double x = 0; x <= size.width; x++) {
      final physicalX = x / pixelsPerMeter;
      final y = WaveSolver.calculateDisplacement(
        amplitude: visualAmp,
        frequency: state.frequency,
        waveSpeed: state.waveSpeed / _waveSpeedDivisor,
        x: physicalX,
        t: state.currentTime,
        isDampingEnabled: state.isDampingEnabled,
      );

      if (x == 0)
        path.moveTo(x, centerY - y);
      else
        path.lineTo(x, centerY - y);
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
  // AMPLITUDE ANNOTATIONS (+A / −A / 2A)
  // ─────────────────────────────────────────────────────────────
  void _drawAmplitudeAnnotations(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final visualAmp = _visualAmplitude();
    final bracketX = size.width - 40;

    final dashPaint = Paint()
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.2)
      ..strokeWidth = 1.0;

    // +A / -A Dashed lines
    _drawDashedLine(
      canvas,
      Offset(0, centerY - visualAmp),
      Offset(bracketX, centerY - visualAmp),
      dashPaint,
    );
    _drawDashedLine(
      canvas,
      Offset(0, centerY + visualAmp),
      Offset(bracketX, centerY + visualAmp),
      dashPaint,
    );

    final annotationColor = const Color(0xFF00E5FF);
    _drawText(
      canvas,
      "+A",
      Offset(5, centerY - visualAmp - 12),
      TextStyle(color: annotationColor, fontSize: 8),
    );
    _drawText(
      canvas,
      "−A",
      Offset(5, centerY + visualAmp + 2),
      TextStyle(color: annotationColor, fontSize: 8),
    );

    // 2A Vertical Bracket
    final bracketPaint = Paint()
      ..color = annotationColor
      ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(bracketX, centerY - visualAmp),
      Offset(bracketX, centerY + visualAmp),
      bracketPaint,
    );
    canvas.drawLine(
      Offset(bracketX - 5, centerY - visualAmp),
      Offset(bracketX + 5, centerY - visualAmp),
      bracketPaint,
    );
    canvas.drawLine(
      Offset(bracketX - 5, centerY + visualAmp),
      Offset(bracketX + 5, centerY + visualAmp),
      bracketPaint,
    );

    _drawText(
      canvas,
      "2A",
      Offset(bracketX + 8, centerY - 7),
      TextStyle(
        color: annotationColor,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // PERIOD ANNOTATIONS (T and f)
  // ─────────────────────────────────────────────────────────────
  void _drawPeriodAnnotations(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final visualAmp = _visualAmplitude();
    final bracketY = centerY + visualAmp + 30;

    // Period T on an oscilloscope is temporal, but visualized here as one cycle of the trace
    final wavelength = _wavelength();
    final pixelsPerMeter = size.width / (wavelength * _numCycles);
    final periodInPixels = wavelength * pixelsPerMeter;

    final double startX = size.width * 0.15;
    final double endX = startX + periodInPixels;

    if (endX > size.width - 20) return;

    final tPaint = Paint()
      ..color = const Color(0xFF00E5FF)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // T Bracket
    canvas.drawLine(
      Offset(startX, bracketY - 5),
      Offset(startX, bracketY + 5),
      tPaint,
    );
    canvas.drawLine(Offset(startX, bracketY), Offset(endX, bracketY), tPaint);
    canvas.drawLine(
      Offset(endX, bracketY - 5),
      Offset(endX, bracketY + 5),
      tPaint,
    );

    // arrows inside bracket
    _drawSmallHorizontalArrowHead(
      canvas,
      Offset(startX, bracketY),
      true,
      tPaint,
    );
    _drawSmallHorizontalArrowHead(
      canvas,
      Offset(endX, bracketY),
      false,
      tPaint,
    );

    final midX = startX + (endX - startX) / 2;
    _drawText(
      canvas,
      "T",
      Offset(midX - 5, bracketY - 18),
      const TextStyle(
        color: Color(0xFF00E5FF),
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );

    // f = 1/T derivation
    final fText = "f = 1/T = ${state.frequency.toStringAsFixed(1)} Hz";
    _drawText(
      canvas,
      fText,
      Offset(midX - 40, bracketY + 12),
      const TextStyle(
        color: Color(0xFF00E5FF),
        fontSize: 9,
        fontFamily: 'monospace',
      ),
    );

    _drawText(
      canvas,
      "~~~ one cycle ~~~",
      Offset(midX - 45, centerY - visualAmp - 20),
      TextStyle(
        color: Colors.white.withValues(alpha: 0.3),
        fontSize: 8,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────────────────────
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
