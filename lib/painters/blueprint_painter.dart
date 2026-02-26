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

  @override
  void paint(Canvas canvas, Size size) {
    if (!state.showBlueprint) return;

    // 1. Global common annotations
    if (annotations.showAmplitude) _drawAmplitudeBracket(canvas, size);

    // Wavelength (skip for longitudinal and Doppler as they have custom logic)
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

  void _drawAmplitudeBracket(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = WaveColors.amplitude
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final centerY = size.height / 2;
    final double visualAmplitude = state.amplitude * 80;
    final double x = size.width - 40;

    canvas.drawLine(
      Offset(x - 5, centerY - visualAmplitude),
      Offset(x + 5, centerY - visualAmplitude),
      paint,
    );
    canvas.drawLine(
      Offset(x, centerY - visualAmplitude),
      Offset(x, centerY + visualAmplitude),
      paint,
    );
    canvas.drawLine(
      Offset(x - 5, centerY + visualAmplitude),
      Offset(x + 5, centerY + visualAmplitude),
      paint,
    );

    _draw3PartLabel(
      canvas,
      Offset(x + 10, centerY),
      'A',
      '${state.amplitude.toStringAsFixed(1)} m',
      'Amplitude',
      WaveColors.amplitude,
    );
  }

  void _drawWavelengthBracket(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = WaveColors.wavelength
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final centerY = size.height / 2 + 100;
    final double wavelength = (state.waveSpeed / 10) / state.frequency;
    final double visualWavelength = (wavelength / 10) * size.width;

    final double startX = size.width * 0.1;
    final double endX = startX + visualWavelength;

    if (endX > size.width) return;

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
      Offset(startX + (endX - startX) / 2, centerY + 15),
      'λ',
      '${(state.waveSpeed / state.frequency).toStringAsFixed(1)} m',
      'Wavelength',
      WaveColors.wavelength,
      isCentered: true,
    );
  }

  void _drawVelocityArrow(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = WaveColors.speed
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final centerY = size.height / 2 - 120;
    const startX = 50.0;
    const endX = 150.0;

    canvas.drawLine(Offset(startX, centerY), Offset(endX, centerY), paint);
    final path = Path()
      ..moveTo(endX - 10, centerY - 5)
      ..lineTo(endX, centerY)
      ..lineTo(endX - 10, centerY + 5);
    canvas.drawPath(path, paint);

    _draw3PartLabel(
      canvas,
      Offset(startX, centerY - 45),
      'v',
      '${state.waveSpeed.toInt()} m/s',
      'Wave Speed',
      WaveColors.speed,
    );
  }

  void _drawNodes(Canvas canvas, Size size) {
    final nodePaint = Paint()
      ..color = WaveColors.harmonic
      ..style = PaintingStyle.fill;
    final antinodePaint = Paint()
      ..color = WaveColors.amplitude.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final centerY = size.height / 2;
    for (int i = 0; i <= state.harmonic; i++) {
      final x = (i / state.harmonic) * size.width;
      canvas.drawCircle(Offset(x, centerY), 4, nodePaint);
      _drawHUDText(
        canvas,
        Offset(x - 5, centerY + 10),
        'N',
        WaveColors.harmonic,
        10,
      );

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

    final double wavelength = (state.waveSpeed / 10) / state.frequency;
    final double visualWavelength = (wavelength / 10) * size.width;

    final constPaint = Paint()
      ..color = WaveColors.constructive.withOpacity(0.05)
      ..style = PaintingStyle.fill;
    final destPaint = Paint()
      ..color = WaveColors.destructive.withOpacity(0.05)
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

  void _drawDopplerAnnotations(Canvas canvas, Size size) {
    final v = state.waveSpeed;
    final vs = state.sourceVelocity;
    final f = state.frequency;
    final lambdaComp = (v - vs) / f;
    final lambdaStretch = (v + vs) / f;
    final fObsApproaching = f * (v / (v - vs));
    final fObsReceding = f * (v / (v + vs));

    final centerY = size.height / 2;
    final centerX = size.width / 2;

    final double visualLambdaComp = (lambdaComp / 100) * (size.width / 4);
    _drawBracket(
      canvas,
      Offset(centerX - visualLambdaComp - 20, centerY + 80),
      visualLambdaComp,
      'λ_comp',
      WaveColors.wavelength,
    );

    final double visualLambdaStretch = (lambdaStretch / 100) * (size.width / 4);
    _drawBracket(
      canvas,
      Offset(centerX + 20, centerY + 80),
      visualLambdaStretch,
      'λ_stretch',
      WaveColors.wavelength,
    );

    _draw3PartLabel(
      canvas,
      Offset(50, size.height * 0.8),
      'f_obs',
      '${fObsApproaching.toInt()} Hz',
      'Approaching',
      WaveColors.frequency,
    );
    _draw3PartLabel(
      canvas,
      Offset(size.width - 150, size.height * 0.8),
      'f_obs',
      '${fObsReceding.toInt()} Hz',
      'Receding',
      WaveColors.frequency,
    );

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

  void _drawPulseIndicator(Canvas canvas, Size size) {
    final double t = (state.currentTime * 2) % 1.0;
    const startX = 50.0;
    const endX = 150.0;
    final double pulseX = startX + (endX - startX) * t;

    final pulsePaint = Paint()
      ..color = WaveColors.speed
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(pulseX, size.height / 2 - 120), 4, pulsePaint);

    for (int i = 1; i < 5; i++) {
      double ghostT = (t - (i * 0.05)) % 1.0;
      if (ghostT < 0) ghostT += 1.0;
      final gx = startX + (endX - startX) * ghostT;
      canvas.drawCircle(
        Offset(gx, size.height / 2 - 120),
        4 - i.toDouble(),
        Paint()
          ..color = pulsePaint.color.withOpacity(0.5 / i)
          ..style = PaintingStyle.fill,
      );
    }
  }

  void _drawLongitudinalZones(Canvas canvas, Size size) {
    final double wavelength = (state.waveSpeed / 10) / state.frequency;
    final double visualWavelength = (wavelength / 10) * size.width;
    final double timeOffset =
        (state.currentTime * (state.waveSpeed / 10) / 10) % visualWavelength;

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

    final paint = Paint()
      ..color = WaveColors.wavelength
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    final centerY = size.height / 2 + 60;
    const startX = 100.0;
    canvas.drawLine(
      Offset(startX, centerY - 5),
      Offset(startX, centerY + 5),
      paint,
    );
    canvas.drawLine(
      Offset(startX, centerY),
      Offset(startX + visualWavelength, centerY),
      paint,
    );
    canvas.drawLine(
      Offset(startX + visualWavelength, centerY - 5),
      Offset(startX + visualWavelength, centerY + 5),
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

  void _drawHUDText(
    Canvas canvas,
    Offset position,
    String text,
    Color color,
    double fontSize,
  ) {
    final textPainter = TextPainter(
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
    );
    textPainter.layout();
    textPainter.paint(canvas, position);
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
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
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
    textPainter.layout();
    double x = isCentered ? position.dx - textPainter.width / 2 : position.dx;
    textPainter.paint(canvas, Offset(x, position.dy));

    textPainter.text = TextSpan(
      text: fullName.toUpperCase(),
      style: TextStyle(
        color: Colors.white.withOpacity(0.4),
        fontSize: 8,
        letterSpacing: 1.0,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x, position.dy + 16));

    final linePaint = Paint()
      ..color = accentColor.withOpacity(0.5)
      ..strokeWidth = 1.0;
    canvas.drawLine(
      Offset(x, position.dy - 2),
      Offset(x + 40, position.dy - 2),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant BlueprintPainter oldDelegate) => true;
}
