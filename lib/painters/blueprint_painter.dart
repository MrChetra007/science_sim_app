import 'package:flutter/material.dart';
import 'dart:math';
import '../providers/wave_provider.dart';
import '../theme/wave_colors.dart';
import '../physics/wave_models.dart';

class BlueprintPainter extends CustomPainter {
  final WaveState state;
  final WaveAnnotationSet annotations;

  BlueprintPainter({required this.state})
    : annotations = WaveAnnotationSet.forMode(state.mode, state.waveType);

  // ─── Shared coordinate constants ─────────────────────────────────────────
  // ⚠️  MUST stay in sync with wave_painter.dart and oscilloscope_panel.dart.
  //     If numCycles or waveSpeedDivisor changes in the wave painter, update
  //     these values too or annotations will stop aligning with the wave.
  static const double _ampScale = 80.0;
  static const double _numCycles = 1.5; // cycles shown across canvas width
  static const double _waveSpeedDivisor =
      10.0; // wave painter divides speed by this

  /// Pixels per physical metre — matches wave painter coordinate system.
  static double _ppm(double width, double physWavelength) =>
      width / (physWavelength * _numCycles);

  /// Visual wavelength in pixels — one full cycle as drawn on screen.
  static double _visLam(double width, double physWavelength) =>
      physWavelength * _ppm(width, physWavelength); // == width / _numCycles

  // Fixed left anchor — never derived from currentTime.
  static double _lambdaAnchor(double width) => width * 0.08;

  @override
  void paint(Canvas canvas, Size size) {
    if (!state.showBlueprint) return;

    // 1. Global common annotations
    if (annotations.showAmplitude) _drawAmplitudeBracket(canvas, size);

    // Wavelength — skip modes that draw their own custom λ logic
    if (annotations.showWavelength &&
        state.mode != WaveMode.doppler &&
        state.waveType != WaveType.longitudinal) {
      _drawWavelengthBracket(canvas, size);
    }

    if (annotations.showVelocity) _drawVelocityArrow(canvas, size);

    // 2. Mode-specific annotations
    switch (state.mode) {
      case WaveMode.standing:
        _drawNodes(canvas, size);
        break;
      case WaveMode.interference:
        _drawInterferenceZones(canvas, size);
        break;
      case WaveMode.doppler:
        _drawDopplerAnnotations(canvas, size);
        break;
      case WaveMode.travelling:
        _drawPulseIndicator(canvas, size);
        break;
      case WaveMode.simulation:
        if (state.waveType == WaveType.longitudinal) {
          _drawLongitudinalZones(canvas, size);
        }
        break;
    }

    _drawModeBadge(canvas, size);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // MODE BADGE
  // ─────────────────────────────────────────────────────────────────────────
  void _drawModeBadge(Canvas canvas, Size size) {
    final modeName = state.mode.name.toUpperCase();
    _draw3PartLabel(
      canvas,
      const Offset(20, 20),
      'MODE',
      modeName,
      state.waveType == WaveType.transverse
          ? 'Transverse Wave'
          : 'Longitudinal Wave',
      WaveColors.primary,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // AMPLITUDE BRACKET  (+A / −A on right edge, label inside canvas)
  //
  // ✅ FIX: Label was at x+10 — off the right edge of the canvas, clipping
  //         the text. Now placed LEFT of the bracket line so it's always
  //         visible. Added dashed ±A reference lines and inline labels.
  // ─────────────────────────────────────────────────────────────────────────
  void _drawAmplitudeBracket(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = WaveColors.amplitude
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final centerY = size.height / 2;
    final double visualAmplitude = state.amplitude * _ampScale;
    // ✅ 28px from right — ticks stay on-screen
    final double bracketX = size.width - 28;

    // Dashed ±A reference lines
    final dashPaint = Paint()
      ..color = WaveColors.amplitude.withValues(alpha: 0.3)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    _drawDashedLine(
      canvas,
      Offset(0, centerY - visualAmplitude),
      Offset(bracketX, centerY - visualAmplitude),
      dashPaint,
    );
    _drawDashedLine(
      canvas,
      Offset(0, centerY + visualAmplitude),
      Offset(bracketX, centerY + visualAmplitude),
      dashPaint,
    );

    // Bracket
    canvas.drawLine(
      Offset(bracketX - 5, centerY - visualAmplitude),
      Offset(bracketX + 5, centerY - visualAmplitude),
      paint,
    );
    canvas.drawLine(
      Offset(bracketX, centerY - visualAmplitude),
      Offset(bracketX, centerY + visualAmplitude),
      paint,
    );
    canvas.drawLine(
      Offset(bracketX - 5, centerY + visualAmplitude),
      Offset(bracketX + 5, centerY + visualAmplitude),
      paint,
    );

    // ✅ Label left of bracket — never clips
    _draw3PartLabel(
      canvas,
      Offset(bracketX - 72, centerY - 12),
      'A',
      '${state.amplitude.toStringAsFixed(1)} m',
      'Amplitude',
      WaveColors.amplitude,
    );

    // +A / 0 / −A inline left-edge labels
    _drawHUDText(
      canvas,
      Offset(6, centerY - visualAmplitude - 14),
      '+A',
      WaveColors.amplitude,
      9,
    );
    _drawHUDText(
      canvas,
      Offset(6, centerY - 5),
      '0',
      WaveColors.amplitude.withValues(alpha: 0.35),
      9,
    );
    _drawHUDText(
      canvas,
      Offset(6, centerY + visualAmplitude + 4),
      '−A',
      WaveColors.amplitude.withValues(alpha: 0.6),
      9,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // WAVELENGTH BRACKET
  //
  // ✅ FIX 1: Fixed anchor — never derived from currentTime (was sliding).
  // ✅ FIX 2: When λ is wider than canvas (e.g. v=300 m/s), the old code
  //           silently returned, showing NOTHING. Now falls back to a visible
  //           badge + partial arrow so λ is always communicated to the user.
  // ─────────────────────────────────────────────────────────────────────────
  void _drawWavelengthBracket(Canvas canvas, Size size) {
    if (state.waveType == WaveType.longitudinal) return;

    final centerY = size.height / 2;
    final double visualAmplitude = state.amplitude * _ampScale;
    final double physWavelength = state.waveSpeed / state.frequency;
    final double visualWavelength = _visLam(size.width, physWavelength);

    // Fixed anchor — never depends on currentTime
    final double startX = _lambdaAnchor(size.width);
    final double endX = startX + visualWavelength;
    final double bracketY = centerY + visualAmplitude + 40;

    final paint = Paint()
      ..color = WaveColors.wavelength
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final dashPaint = Paint()
      ..color = WaveColors.wavelength.withValues(alpha: 0.3)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    if (endX <= size.width - 20) {
      // ── Normal case: full bracket fits ──
      _drawDashedLine(
        canvas,
        Offset(startX, centerY - visualAmplitude),
        Offset(startX, bracketY),
        dashPaint,
      );
      _drawDashedLine(
        canvas,
        Offset(endX, centerY - visualAmplitude),
        Offset(endX, bracketY),
        dashPaint,
      );

      canvas.drawLine(
        Offset(startX, bracketY - 5),
        Offset(startX, bracketY + 5),
        paint,
      );
      canvas.drawLine(Offset(startX, bracketY), Offset(endX, bracketY), paint);
      canvas.drawLine(
        Offset(endX, bracketY - 5),
        Offset(endX, bracketY + 5),
        paint,
      );

      _draw3PartLabel(
        canvas,
        Offset(startX + (endX - startX) / 2, bracketY + 15),
        'λ',
        '${physWavelength.toStringAsFixed(1)} m',
        'Wavelength',
        WaveColors.wavelength,
        isCentered: true,
      );
    } else {
      // ── ✅ Fallback: λ wider than canvas — draw partial arrow + badge ──
      // Left anchor tick
      canvas.drawLine(
        Offset(startX, bracketY - 5),
        Offset(startX, bracketY + 5),
        paint,
      );
      // Partial line with open arrowhead pointing right (continues off-screen)
      final double arrowEndX = size.width - 16;
      canvas.drawLine(
        Offset(startX, bracketY),
        Offset(arrowEndX, bracketY),
        paint,
      );
      // Open arrowhead
      canvas.drawLine(
        Offset(arrowEndX - 8, bracketY - 5),
        Offset(arrowEndX, bracketY),
        paint,
      );
      canvas.drawLine(
        Offset(arrowEndX - 8, bracketY + 5),
        Offset(arrowEndX, bracketY),
        paint,
      );

      // Dashed guide from anchor down
      _drawDashedLine(
        canvas,
        Offset(startX, centerY - visualAmplitude),
        Offset(startX, bracketY),
        dashPaint,
      );

      // Value badge centred in the visible partial bracket
      final double badgeCx = startX + (arrowEndX - startX) / 2;
      _draw3PartLabel(
        canvas,
        Offset(badgeCx, bracketY + 15),
        'λ',
        '${physWavelength.toStringAsFixed(1)} m',
        'Wavelength  (> canvas)',
        WaveColors.wavelength,
        isCentered: true,
      );
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // VELOCITY ARROW
  //
  // ✅ FIX: Position is now derived from size so it never goes off-canvas.
  // ─────────────────────────────────────────────────────────────────────────
  void _drawVelocityArrow(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = WaveColors.speed
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    // ✅ Relative positioning — safe on all screen sizes
    final double arrowY = max(36.0, size.height * 0.12);
    final double startX = size.width * 0.06;
    final double endX = size.width * 0.22;

    canvas.drawLine(Offset(startX, arrowY), Offset(endX, arrowY), paint);

    // Arrowhead
    final path = Path()
      ..moveTo(endX - 10, arrowY - 5)
      ..lineTo(endX, arrowY)
      ..lineTo(endX - 10, arrowY + 5);
    canvas.drawPath(path, paint);

    _draw3PartLabel(
      canvas,
      Offset(startX, arrowY - 28),
      'v',
      '${state.waveSpeed.toInt()} m/s',
      'Wave Speed',
      WaveColors.speed,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // STANDING WAVE — Nodes & Antinodes
  //
  // ✅ FIX: withOpacity → withValues(alpha:) to avoid deprecation warning.
  // ─────────────────────────────────────────────────────────────────────────
  void _drawNodes(Canvas canvas, Size size) {
    final nodePaint = Paint()
      ..color = WaveColors.harmonic
      ..style = PaintingStyle.fill;
    final antinodePaint = Paint()
      ..color = WaveColors.amplitude
          .withValues(alpha: 0.5) // ✅
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final centerY = size.height / 2;

    for (int i = 0; i <= state.harmonic; i++) {
      final x = (i / state.harmonic) * size.width;

      // Node dot
      canvas.drawCircle(Offset(x, centerY), 4, nodePaint);
      _drawHUDText(
        canvas,
        Offset(x - 5, centerY + 10),
        'N',
        WaveColors.harmonic,
        10,
      );

      // Antinode circle (between nodes)
      if (i < state.harmonic) {
        final ax = ((i + 0.5) / state.harmonic) * size.width;
        canvas.drawCircle(Offset(ax, centerY), 12, antinodePaint);
        _drawHUDText(
          canvas,
          Offset(ax - 8, centerY - 25),
          'AN',
          WaveColors.amplitude,
          10,
        );
      }
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // INTERFERENCE ZONES
  // ─────────────────────────────────────────────────────────────────────────
  void _drawInterferenceZones(Canvas canvas, Size size) {
    _draw3PartLabel(
      canvas,
      Offset(size.width * 0.4, 40),
      'Δφ',
      '${(state.phaseDifference / pi).toStringAsFixed(2)}π',
      'Phase Difference',
      WaveColors.phase,
      isCentered: true,
    );

    final double physWavelength = state.waveSpeed / state.frequency;
    final double visualWavelength = _visLam(size.width, physWavelength);

    final constPaint = Paint()
      ..color = WaveColors.constructive
          .withValues(alpha: 0.05) // ✅
      ..style = PaintingStyle.fill;
    final destPaint = Paint()
      ..color = WaveColors.destructive
          .withValues(alpha: 0.05) // ✅
      ..style = PaintingStyle.fill;

    for (double x = 0; x < size.width; x += visualWavelength) {
      canvas.drawRect(Rect.fromLTWH(x - 10, 0, 20, size.height), constPaint);
      _drawHUDText(
        canvas,
        Offset(x - 5, size.height - 100),
        '+',
        WaveColors.constructive,
        14,
      );

      final rx = x + visualWavelength / 2;
      canvas.drawRect(Rect.fromLTWH(rx - 10, 0, 20, size.height), destPaint);
      _drawHUDText(
        canvas,
        Offset(rx - 5, size.height - 100),
        '-',
        WaveColors.destructive,
        14,
      );
    }

    if (annotations.showResultantA) {
      final double resA = state.amplitude + state.secondaryAmplitude;
      _draw3PartLabel(
        canvas,
        Offset(size.width - 120, size.height * 0.8),
        'A_res',
        '${resA.toStringAsFixed(1)} m',
        'Resultant Amplitude',
        WaveColors.amplitude,
      );
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // DOPPLER ANNOTATIONS
  //
  // ✅ FIX: Bracket directions were REVERSED.
  //   - Compressed λ (approach) is AHEAD of source = RIGHT side of center
  //   - Stretched λ  (receding) is BEHIND source   = LEFT  side of center
  //   The old code placed them the wrong way around.
  // ─────────────────────────────────────────────────────────────────────────
  void _drawDopplerAnnotations(Canvas canvas, Size size) {
    final double v = state.waveSpeed;
    final double vs = state.sourceVelocity;
    final double f = state.frequency;

    final double lambdaComp = (v - vs) / f; // compressed  (approach, right)
    final double lambdaStretch = (v + vs) / f; // stretched   (receding, left)
    final double fObsApproach = f * (v / (v - vs));
    final double fObsRecede = f * (v / (v + vs));

    final centerY = size.height / 2;
    final centerX = size.width / 2;

    // Scale factor: map physical meters to pixels
    final double scale = (size.width / 4) / 100.0;

    // ✅ Compressed λ → RIGHT of center (approach side)
    final double visLamComp = lambdaComp * scale;
    _drawBracket(
      canvas,
      Offset(centerX + 20, centerY + 80), // ✅ starts right of center
      visLamComp,
      'λ_comp',
      WaveColors.wavelength,
    );

    // ✅ Stretched λ → LEFT of center (receding side)
    final double visLamStretch = lambdaStretch * scale;
    _drawBracket(
      canvas,
      Offset(
        centerX - visLamStretch - 20,
        centerY + 80,
      ), // ✅ ends left of center
      visLamStretch,
      'λ_stretch',
      WaveColors.wavelength,
    );

    // f_obs labels: approaching on RIGHT, receding on LEFT
    _draw3PartLabel(
      canvas,
      Offset(size.width - 150, size.height * 0.8), // ✅ right side
      'f_obs',
      '${fObsApproach.toInt()} Hz',
      'Approaching',
      WaveColors.frequency,
    );
    _draw3PartLabel(
      canvas,
      Offset(50, size.height * 0.8), // ✅ left side
      'f_obs',
      '${fObsRecede.toInt()} Hz',
      'Receding',
      WaveColors.frequency,
    );

    // Source velocity arrow
    final arrowPaint = Paint()
      ..color = WaveColors.speed
      ..strokeWidth = 3.0;
    final double arrowLen = vs * 1.5;
    canvas.drawLine(
      Offset(centerX, 100),
      Offset(centerX + arrowLen, 100),
      arrowPaint,
    );
    _draw3PartLabel(
      canvas,
      Offset(centerX - 40, 60),
      'v_s',
      '${vs.toInt()} m/s',
      'Source Velocity',
      WaveColors.speed,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // TRAVELLING WAVE — Animated pulse dot with ghost trail
  //
  // ✅ FIX: Ghost modulo now safe for negative values in Dart.
  //   Dart's % operator returns negative results for negative left operands,
  //   unlike many other languages. Fixed with: ((x % n) + n) % n pattern.
  // ─────────────────────────────────────────────────────────────────────────
  void _drawPulseIndicator(Canvas canvas, Size size) {
    final double t = (state.currentTime * 2) % 1.0;

    // Match position to _drawVelocityArrow
    final double arrowY = max(36.0, size.height * 0.12);
    final double startX = size.width * 0.06;
    final double endX = size.width * 0.22;

    final pulsePaint = Paint()
      ..color = WaveColors.speed
      ..style = PaintingStyle.fill;

    // Ghost trail
    for (int i = 4; i >= 1; i--) {
      // ✅ Safe modulo for negative values
      final double ghostT = ((t - i * 0.05) % 1.0 + 1.0) % 1.0;
      final double gx = startX + (endX - startX) * ghostT;
      canvas.drawCircle(
        Offset(gx, arrowY),
        (4 - i).toDouble(),
        Paint()
          ..color = pulsePaint.color
              .withValues(alpha: 0.5 / i) // ✅
          ..style = PaintingStyle.fill,
      );
    }

    // Main pulse
    final double pulseX = startX + (endX - startX) * t;
    canvas.drawCircle(Offset(pulseX, arrowY), 4, pulsePaint);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // LONGITUDINAL ZONES — C / R labels + fixed λ bracket
  // ─────────────────────────────────────────────────────────────────────────
  void _drawLongitudinalZones(Canvas canvas, Size size) {
    final double physWavelength = state.waveSpeed / state.frequency;
    final double visualWavelength = _visLam(size.width, physWavelength);
    // C/R labels scroll with the wave — this is correct behaviour
    final double timeOffset =
        (state.currentTime * (state.waveSpeed / _waveSpeedDivisor)) *
        _ppm(size.width, physWavelength) %
        visualWavelength;

    for (double x = -visualWavelength; x < size.width; x += visualWavelength) {
      final cx = x + timeOffset;
      if (cx > 0 && cx < size.width) {
        _drawHUDText(
          canvas,
          Offset(cx, size.height / 2 - 40),
          'C',
          WaveColors.primary,
          14,
        );
        _drawHUDText(
          canvas,
          Offset(cx + visualWavelength / 2, size.height / 2 - 40),
          'R',
          Colors.white38,
          14,
        );
      }
    }

    // λ bracket — fixed at anchor, not time-based
    final paint = Paint()
      ..color = WaveColors.wavelength
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    final centerY = size.height / 2 + 60;
    final double startX = _lambdaAnchor(size.width); // ✅ fixed anchor
    final double endX = startX + visualWavelength;

    if (endX < size.width - 20) {
      canvas.drawLine(
        Offset(startX, centerY - 5),
        Offset(startX, centerY + 5),
        paint,
      );
      canvas.drawLine(Offset(startX, centerY), Offset(endX, centerY), paint);
      canvas.drawLine(
        Offset(endX, centerY - 5),
        Offset(endX, centerY + 5),
        paint,
      );
      _draw3PartLabel(
        canvas,
        Offset(startX + visualWavelength / 2, centerY + 10),
        'λ',
        '${(state.waveSpeed / state.frequency).toStringAsFixed(1)}m',
        'Wavelength',
        WaveColors.wavelength,
        isCentered: true,
      );
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────────────────────────────────
  void _drawBracket(
    Canvas canvas,
    Offset position,
    double width,
    String label,
    Color color,
  ) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(position.dx, position.dy - 5),
      Offset(position.dx, position.dy + 5),
      paint,
    );
    canvas.drawLine(
      Offset(position.dx, position.dy),
      Offset(position.dx + width, position.dy),
      paint,
    );
    canvas.drawLine(
      Offset(position.dx + width, position.dy - 5),
      Offset(position.dx + width, position.dy + 5),
      paint,
    );
    _drawHUDText(
      canvas,
      Offset(position.dx + width / 2 - 15, position.dy + 10),
      label,
      color,
      9,
    );
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const double dashW = 3.0, dashGap = 3.0;
    final double dist = (p2 - p1).distance;
    if (dist == 0) return;
    final double dx = (p2.dx - p1.dx) / dist;
    final double dy = (p2.dy - p1.dy) / dist;
    double d = 0;
    while (d < dist) {
      final double end = (d + dashW).clamp(0.0, dist);
      canvas.drawLine(
        Offset(p1.dx + dx * d, p1.dy + dy * d),
        Offset(p1.dx + dx * end, p1.dy + dy * end),
        paint,
      );
      d += dashW + dashGap;
    }
  }

  void _drawHUDText(
    Canvas canvas,
    Offset position,
    String text,
    Color color,
    double fontSize,
  ) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, position);
  }

  void _draw3PartLabel(
    Canvas canvas,
    Offset position,
    String symbol,
    String value,
    String fullName,
    Color accentColor, {
    bool isCentered = false,
  }) {
    final tp = TextPainter(textDirection: TextDirection.ltr);

    // Symbol + value line
    tp.text = TextSpan(
      children: [
        TextSpan(
          text: '$symbol  ',
          style: TextStyle(
            color: accentColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: 'monospace',
          ),
        ),
        TextSpan(
          text: value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
    tp.layout();
    final double x = isCentered ? position.dx - tp.width / 2 : position.dx;
    tp.paint(canvas, Offset(x, position.dy));

    // Full name sub-label
    tp.text = TextSpan(
      text: fullName.toUpperCase(),
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.4), // ✅
        fontSize: 8,
        letterSpacing: 1.0,
      ),
    );
    tp.layout();
    tp.paint(canvas, Offset(x, position.dy + 16));

    // ✅ FIX: Accent line width matches first-line text width, not hardcoded 40px
    final linePaint = Paint()
      ..color = accentColor
          .withValues(alpha: 0.5) // ✅
      ..strokeWidth = 1.0;
    // Re-measure just the first line to get accurate width
    final firstLineTp = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: '$symbol  $value',
        style: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
      ),
    )..layout();
    canvas.drawLine(
      Offset(x, position.dy - 2),
      Offset(x + firstLineTp.width, position.dy - 2), // ✅ dynamic width
      linePaint,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // REPAINT
  //
  // ✅ FIX: Was `=> true` — caused full repaint every frame even when idle.
  //   Now compares the fields that actually affect the painted output.
  // ─────────────────────────────────────────────────────────────────────────
  @override
  bool shouldRepaint(covariant BlueprintPainter oldDelegate) {
    final o = oldDelegate.state;
    final n = state;
    return o.amplitude != n.amplitude ||
        o.frequency != n.frequency ||
        o.waveSpeed != n.waveSpeed ||
        o.currentTime != n.currentTime ||
        o.mode != n.mode ||
        o.waveType != n.waveType ||
        o.harmonic != n.harmonic ||
        o.phaseDifference != n.phaseDifference ||
        o.sourceVelocity != n.sourceVelocity ||
        o.secondaryAmplitude != n.secondaryAmplitude ||
        o.showBlueprint != n.showBlueprint;
  }
}
