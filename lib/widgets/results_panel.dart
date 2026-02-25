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
        color: const Color(0xFF040D17).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF00E5FF).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildEquation(state),
          const Divider(color: Colors.white12, height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: _buildMetrics(state, wavelength, period)),
          ),
        ],
      ),
    );
  }

  Widget _buildEquation(WaveState state) {
    String eq = '';
    switch (state.mode) {
      case WaveMode.simulation:
        eq =
            'y(x,t) = ${state.amplitude.toStringAsFixed(1)} sin(kx - ${state.frequency.toStringAsFixed(1)}t)';
        break;
      case WaveMode.standing:
        eq = 'y(x,t) = [2A sin(kx)] cos(ωt) (n=${state.harmonic})';
        break;
      case WaveMode.interference:
        eq = 'y_total = y1 + y2';
        break;
      case WaveMode.doppler:
        eq = "f' = f [v / (v - vs)]";
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PHYSICS ENGINE HUD',
          style: TextStyle(
            color: Color(0xFF00E5FF),
            fontSize: 10,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          eq,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  List<Widget> _buildMetrics(WaveState state, double wavelength, double T) {
    final List<Widget> items = [];

    if (state.mode == WaveMode.doppler) {
      final fPrime = WaveSolver.calculateDopplerFrequency(
        sourceFrequency: state.frequency,
        waveSpeed: state.waveSpeed,
        sourceVelocity: state.sourceVelocity,
      );
      items.add(
        _buildMetric('Observed f\'', '${fPrime.toStringAsFixed(1)} Hz'),
      );
      items.add(
        _buildMetric(
          'Shift Δf',
          '${(fPrime - state.frequency).toStringAsFixed(1)} Hz',
        ),
      );
    } else {
      items.add(
        _buildMetric('λ (Wavelength)', '${wavelength.toStringAsFixed(1)} m'),
      );
      items.add(_buildMetric('T (Period)', '${T.toStringAsFixed(2)} s'));
      items.add(_buildMetric('v (Speed)', '${state.waveSpeed.toInt()} m/s'));
    }

    if (state.mode == WaveMode.standing) {
      items.add(_buildMetric('Nodes', '${state.harmonic + 1}'));
    }

    return items
        .map(
          (m) => Padding(padding: const EdgeInsets.only(right: 20), child: m),
        )
        .toList();
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
