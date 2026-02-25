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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF040D17).withValues(alpha: 0.9),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF00E5FF).withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Expanded(flex: 3, child: _buildEquationHUD(state)),
            const VerticalDivider(color: Colors.white12, width: 24),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _buildMetricsHUD(state, wavelength, period),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEquationHUD(WaveState state) {
    String eq = '';
    switch (state.mode) {
      case WaveMode.simulation:
        eq =
            'y(x,t) = ${state.amplitude.toStringAsFixed(1)} sin(kx - ${state.frequency.toStringAsFixed(1)}t)';
        break;
      case WaveMode.standing:
        eq = 'y(x,t) = [2A sin(kx)] cos(ωt)';
        break;
      case WaveMode.interference:
        eq = 'y_total = y1 + y2';
        break;
      case WaveMode.doppler:
        eq = "f' = f [v / (v - vs)]";
        break;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PHYSICS ENGINE HUB',
          style: TextStyle(
            color: Color(0xFF00E5FF),
            fontSize: 8,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            eq,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildMetricsHUD(WaveState state, double lambda, double T) {
    final List<Widget> items = [];

    if (state.mode == WaveMode.doppler) {
      final fPrime = WaveSolver.calculateDopplerFrequency(
        sourceFrequency: state.frequency,
        waveSpeed: state.waveSpeed,
        sourceVelocity: state.sourceVelocity,
      );
      items.add(_metric('f\'', '${fPrime.toStringAsFixed(1)}Hz'));
      items.add(
        _metric('Δf', '${(fPrime - state.frequency).toStringAsFixed(1)}Hz'),
      );
    } else {
      items.add(_metric('λ', '${lambda.toStringAsFixed(1)}m'));
      items.add(_metric('T', '${T.toStringAsFixed(2)}s'));
      items.add(_metric('v', '${state.waveSpeed.toInt()}m/s'));
    }

    if (state.mode == WaveMode.standing) {
      items.add(_metric('n', '${state.harmonic}'));
    }

    return items
        .map(
          (m) => Padding(padding: const EdgeInsets.only(right: 16), child: m),
        )
        .toList();
  }

  Widget _metric(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 8)),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
