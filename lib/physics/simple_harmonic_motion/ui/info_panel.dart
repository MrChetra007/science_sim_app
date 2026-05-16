import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sim_provider.dart';

class InfoPanel extends ConsumerWidget {
  const InfoPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(simProvider);

    return Container(
      color: const Color(0xFF1A1A2E),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _metricRow(state),
          const SizedBox(height: 4),
          _statusText(state),
          const SizedBox(height: 4),
          _formulaBox(state),
        ],
      ),
    );
  }

  Widget _metricRow(SimState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _metricCard('T', '${state.period.toStringAsFixed(2)} s', Colors.green),
        _metricCard('\u03C9', '${state.omega.toStringAsFixed(2)} rad/s', Colors.orange),
        _metricCard('KE', '${state.kineticEnergy.toStringAsFixed(3)} J', Colors.orange),
        _metricCard('PE', '${state.potentialEnergy.toStringAsFixed(3)} J', Colors.blue),
        _metricCard('x', '${state.position.toStringAsFixed(3)} m', Colors.white),
      ],
    );
  }

  Widget _metricCard(String label, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(color: Colors.white70, fontSize: 9)),
      ],
    );
  }

  Widget _statusText(SimState state) {
    final x = state.position;
    final A = state.amplitude;
    String status;

    if (A < 0.01) {
      status = 'Adjust amplitude to start';
    } else if (x.abs() < 0.01 * A) {
      status = 'At equilibrium \u2014 maximum speed, zero PE';
    } else if ((x / A).abs() > 0.95) {
      status = 'At maximum displacement \u2014 zero speed, maximum PE';
    } else if (x > 0) {
      status = 'Restoring force pulling back toward equilibrium';
    } else {
      status = 'Moving toward equilibrium \u2014 KE increasing';
    }

    if (state.mode == SimMode.pendulum && state.initialAngle > 15) {
      status += '  \u26A0 Large angle \u2014 approximation less accurate';
    }

    return Text(
      status,
      style: const TextStyle(color: Colors.white54, fontSize: 10),
      textAlign: TextAlign.center,
    );
  }

  Widget _formulaBox(SimState state) {
    String formula;
    if (state.mode == SimMode.spring) {
      final k = state.springConstant;
      final x = state.position;
      final m = state.mass;
      final omega = state.omega;
      final T = state.period;
      formula =
        'F = -kx = -($k)(${x.toStringAsFixed(2)}) = ${(-k * x).toStringAsFixed(2)} N\n'
        '\u03C9 = \u221A(k/m) = \u221A($k/$m) = ${omega.toStringAsFixed(2)} rad/s\n'
        'T = 2\u03C0\u221A(m/k) = 2\u03C0\u221A($m/$k) = ${T.toStringAsFixed(2)} s';
    } else {
      final L = state.pendulumLength;
      final g = state.gravity;
      final omega = state.omega;
      final T = state.period;
      final theta0 = state.initialAngle;
      formula =
        'T = 2\u03C0\u221A(L/g) = 2\u03C0\u221A($L/$g) = ${T.toStringAsFixed(2)} s\n'
        '\u03C9 = \u221A(g/L) = \u221A($g/$L) = ${omega.toStringAsFixed(2)} rad/s\n'
        '\u03B8(t) = ${theta0.toStringAsFixed(0)}\u00B0 \u00D7 cos(${omega.toStringAsFixed(2)}t)';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1F0A),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF00FF41).withValues(alpha: 0.2)),
      ),
      child: Text(
        formula,
        style: const TextStyle(
          color: Color(0xFF00FF41),
          fontFamily: 'monospace',
          fontSize: 10,
          height: 1.4,
        ),
      ),
    );
  }
}
