import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../painters/wave_painter.dart';
import '../painters/standing_wave_painter.dart';
import '../painters/interference_painter.dart';
import '../painters/doppler_painter.dart';
import '../widgets/control_panel.dart';
import '../widgets/results_panel.dart';
import '../providers/wave_provider.dart';

class SimulationScreen extends ConsumerWidget {
  const SimulationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final waveState = ref.watch(waveProvider);

    Widget waveWidget;
    switch (waveState.mode) {
      case WaveMode.standing:
        waveWidget = CustomPaint(
          painter: StandingWavePainter(state: waveState),
        );
        break;
      case WaveMode.interference:
        waveWidget = CustomPaint(
          painter: InterferencePainter(state: waveState),
        );
        break;
      case WaveMode.doppler:
        waveWidget = CustomPaint(painter: DopplerPainter(state: waveState));
        break;
      case WaveMode.simulation:
        waveWidget = CustomPaint(painter: WavePainter(state: waveState));
        break;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF040D17),
      appBar: AppBar(
        title: Text(_getTitle(waveState.mode)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF00E5FF),
      ),
      body: Stack(
        children: [
          // Holographic Grid Background
          Positioned.fill(child: CustomPaint(painter: GridPainter())),

          // The Wave
          Positioned.fill(child: waveWidget),

          // Top Info Panel
          const Positioned(top: 20, left: 20, right: 20, child: ResultsPanel()),

          // Bottom Control Panel
          const Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: ControlPanel(),
          ),
        ],
      ),
    );
  }

  String _getTitle(WaveMode mode) {
    switch (mode) {
      case WaveMode.simulation:
        return 'Standard Waves';
      case WaveMode.standing:
        return 'Standing Waves (Harmonics)';
      case WaveMode.interference:
        return 'Wave Interference';
      case WaveMode.doppler:
        return 'Doppler Effect';
    }
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.05)
      ..strokeWidth = 1.0;

    const double step = 30.0;
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
