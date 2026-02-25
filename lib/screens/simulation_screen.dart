import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../painters/wave_painter.dart';
import '../widgets/control_panel.dart';
import '../widgets/results_panel.dart';
import '../providers/wave_provider.dart';

class SimulationScreen extends ConsumerWidget {
  const SimulationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final waveState = ref.watch(waveProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF040D17),
      appBar: AppBar(
        title: const Text('Wave Laboratory'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF00E5FF),
      ),
      body: Stack(
        children: [
          // Holographic Grid Background
          Positioned.fill(child: CustomPaint(painter: GridPainter())),

          // The Wave
          Positioned.fill(
            child: CustomPaint(painter: WavePainter(state: waveState)),
          ),

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
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00E5FF).withOpacity(0.05)
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
