import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/wave_provider.dart';
import '../physics/wave_solver.dart';
import 'maths_derivation_sheet.dart';

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
            const VerticalDivider(color: Colors.white12, width: 24),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const MathsDerivationSheet(),
                    );
                  },
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(4),
                  icon: const Icon(
                    Icons.functions,
                    color: Color(0xFF00E5FF),
                    size: 18,
                  ),
                  tooltip: 'Math Derivations',
                ),
                IconButton(
                  onPressed: () => context.push('/formula-reference'),
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(4),
                  icon: const Icon(
                    Icons.menu_book,
                    color: Color(0xFF00E5FF),
                    size: 18,
                  ),
                  tooltip: 'Formula Reference',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEquationHUD(WaveState state) {
    String eq = '';
    final omega = (2 * pi * state.frequency).toStringAsFixed(1);
    final k =
        (2 *
                pi /
                WaveSolver.calculateWavelength(
                  state.waveSpeed,
                  state.frequency,
                ))
            .toStringAsFixed(2);

    switch (state.mode) {
      case WaveMode.simulation:
        eq =
            'y(x,t) = ${state.amplitude.toStringAsFixed(1)} sin(${k}x - ${omega}t)';
        break;
      case WaveMode.standing:
        eq =
            'y(x,t) = [${(2 * state.amplitude).toStringAsFixed(1)} sin(${k}x)] cos(${omega}t)';
        break;
      case WaveMode.interference:
        eq =
            'yt = ${state.amplitude.toStringAsFixed(1)}sin(…) + ${state.secondaryAmplitude.toStringAsFixed(1)}sin(…)';
        break;
      case WaveMode.doppler:
        eq =
            "f' = ${state.frequency.toStringAsFixed(1)} [${state.waveSpeed.toInt()} / (${state.waveSpeed.toInt()} - ${state.sourceVelocity.toInt()})]";
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
