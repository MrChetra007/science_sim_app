import 'package:flutter/material.dart';
import '../providers/wave_provider.dart';
import '../physics/wave_solver.dart';

class LongitudinalPainter extends CustomPainter {
  final WaveState state;
  LongitudinalPainter({required this.state});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;

    final centerY = size.height / 2;
    // Number of particles vertically and horizontally
    const int rows = 5;
    const double rowSpacing = 40.0;
    const double particleSpacing = 10.0;

    // Calculate visual amplitude to fit screen elegantly
    final double visualAmplitude = state.amplitude * 20.0;

    for (int r = 0; r < rows; r++) {
      final yPos = centerY + (r - (rows - 1) / 2) * rowSpacing;

      for (double x = 0; x < size.width; x += particleSpacing) {
        final double xOffset = WaveSolver.calculateDisplacement(
          amplitude: visualAmplitude,
          frequency: state.frequency,
          waveSpeed: state.waveSpeed / 10,
          x: x,
          t: state.currentTime,
          isDampingEnabled: state.isDampingEnabled,
        );

        canvas.drawCircle(Offset(x + xOffset, yPos), 2, paint);
      }
    }

    if (state.showLabels) {
      _paintLabels(canvas, size, state);
    }
  }

  void _paintLabels(Canvas canvas, Size size, WaveState targetState) {
    final textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 10,
      fontWeight: FontWeight.bold,
      backgroundColor: Colors.black45,
    );

    // 1. Velocity and Frequency Labels
    final vX = size.width - 60;
    final vY = 40.0;
    _drawHorizontalArrow(
      canvas,
      Offset(vX - 20, vY),
      40,
      Colors.cyanAccent,
      2.0,
    );
    _drawText(
      canvas,
      'v = ${targetState.waveSpeed.toInt()}m/s',
      Offset(vX - 20, vY - 20),
      textStyle,
    );
    _drawText(
      canvas,
      'f = ${targetState.frequency.toStringAsFixed(1)}Hz',
      Offset(vX - 20, vY + 10),
      textStyle,
    );

    // 2. Wavelength Indicator (between compressions)
    final wavelength = targetState.waveSpeed / targetState.frequency;
    final visualWavelength = (wavelength / 10) * size.width;

    if (visualWavelength < size.width) {
      final startX = size.width * 0.2;
      final endX = startX + visualWavelength;
      final lineY = size.height - 40;

      final arrowPaint = Paint()
        ..color = Colors.amberAccent
        ..strokeWidth = 2.0;

      canvas.drawLine(Offset(startX, lineY), Offset(endX, lineY), arrowPaint);
      canvas.drawLine(
        Offset(startX, lineY - 5),
        Offset(startX, lineY + 5),
        arrowPaint,
      );
      canvas.drawLine(
        Offset(endX, lineY - 5),
        Offset(endX, lineY + 5),
        arrowPaint,
      );

      _drawText(
        canvas,
        'λ = ${wavelength.toStringAsFixed(1)}m',
        Offset(startX + visualWavelength / 2 - 20, lineY + 5),
        textStyle,
      );
    }
  }

  void _drawText(Canvas canvas, String text, Offset position, TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, position);
  }

  void _drawHorizontalArrow(
    Canvas canvas,
    Offset origin,
    double length,
    Color color,
    double width,
  ) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = width;
    final end = Offset(origin.dx + length, origin.dy);
    canvas.drawLine(origin, end, paint);

    final headSize = 5.0;
    canvas.drawLine(end, Offset(end.dx - headSize, end.dy - headSize), paint);
    canvas.drawLine(end, Offset(end.dx - headSize, end.dy + headSize), paint);
  }

  @override
  bool shouldRepaint(covariant LongitudinalPainter oldDelegate) {
    return oldDelegate.state.currentTime != state.currentTime ||
        oldDelegate.state.amplitude != state.amplitude ||
        oldDelegate.state.frequency != state.frequency ||
        oldDelegate.state.waveSpeed != state.waveSpeed ||
        oldDelegate.state.showLabels != state.showLabels;
  }
}
