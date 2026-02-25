import 'package:flutter/material.dart';
import '../providers/wave_provider.dart';
import '../physics/wave_solver.dart';

class InterferencePainter extends CustomPainter {
  final WaveState state;

  InterferencePainter({required this.state});

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final paint1 = Paint()
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final paint2 = Paint()
      ..color = const Color(0xFFFF5252)
          .withValues(alpha: 0.4) // Red for wave 2
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final resultantPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    final resGlowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final path1 = Path();
    final path2 = Path();
    final resultantPath = Path();

    for (double x = 0; x <= size.width; x += 2) {
      final d1 = WaveSolver.calculateDisplacement(
        amplitude: state.amplitude * 50,
        frequency: state.frequency,
        waveSpeed: state.waveSpeed,
        x: x / 20, // scale spatial
        t: state.currentTime,
      );

      final d2 = WaveSolver.calculateDisplacement(
        amplitude: state.secondaryAmplitude * 50,
        frequency: state.secondaryFrequency,
        waveSpeed: state.waveSpeed,
        x: x / 20,
        t: state.currentTime,
        phi: state.phaseDifference,
      );

      if (x == 0) {
        path1.moveTo(x, centerY + d1);
        path2.moveTo(x, centerY + d2);
        resultantPath.moveTo(x, centerY + d1 + d2);
      } else {
        path1.lineTo(x, centerY + d1);
        path2.lineTo(x, centerY + d2);
        resultantPath.lineTo(x, centerY + d1 + d2);
      }
    }

    canvas.drawPath(path1, paint1);
    canvas.drawPath(path2, paint2);
    canvas.drawPath(resultantPath, resGlowPaint);
    canvas.drawPath(resultantPath, resultantPaint);
  }

  @override
  bool shouldRepaint(covariant InterferencePainter oldDelegate) => true;
}
