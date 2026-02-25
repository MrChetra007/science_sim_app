import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/wave_provider.dart';
import '../physics/wave_solver.dart';

class ResultsPanel extends ConsumerWidget {
  const ResultsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(waveProvider);

    final wavelength = WaveSolver.calculateWavelength(
      state.waveSpeed,
      state.frequency,
    );
    final period = WaveSolver.calculatePeriod(state.frequency);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF040D17).withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'LIVE WAVE EQUATION',
            style: TextStyle(
              color: Color(0xFF00E5FF),
              fontSize: 10,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            child: Text(
              'y(x,t) = ${state.amplitude.toStringAsFixed(1)} sin(kx - ${state.frequency.toStringAsFixed(1)}t)',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'monospace',
              ),
            ),
          ),
          const Divider(color: Colors.white12, height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetric('λ', '${wavelength.toStringAsFixed(2)} m'),
              _buildMetric('T', '${period.toStringAsFixed(2)} s'),
              _buildMetric('v', '${state.waveSpeed.toInt()} m/s'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 10),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
