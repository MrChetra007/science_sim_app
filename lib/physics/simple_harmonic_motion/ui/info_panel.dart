import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sim_provider.dart';
import '../../../l10n/generated/app_localizations.dart';

class InfoPanel extends ConsumerWidget {
  const InfoPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(simProvider);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      color: const Color(0xFF1A1A2E),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _metricRow(state),
          const SizedBox(height: 2),
          _compactInfoLine(state, l10n),
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

  Widget _compactInfoLine(SimState state, AppLocalizations l10n) {
    final formula = state.mode == SimMode.spring
        ? '\u03C9=\u221A(k/m)=${state.omega.toStringAsFixed(1)}  T=2\u03C0\u221A(m/k)=${state.period.toStringAsFixed(2)}s  F=-kx'
        : 'T=2\u03C0\u221A(L/g)=${state.period.toStringAsFixed(2)}s  \u03C9=\u221A(g/L)=${state.omega.toStringAsFixed(1)}  \u03B8(t)=\u03B8\u2080cos(\u03C9t)';

    final x = state.position;
    final A = state.amplitude;
    String status;
    if (A < 0.01) {
      status = l10n.shmStatusAdjustAmplitude;
    } else if (x.abs() < 0.01 * A) {
      status = l10n.shmStatusAtEquilibrium;
    } else if ((x / A).abs() > 0.95) {
      status = l10n.shmStatusAtMaxDisplacement;
    } else if (x > 0) {
      status = l10n.shmStatusRestoringForce;
    } else {
      status = l10n.shmStatusMovingToEquilibrium;
    }
    if (state.mode == SimMode.pendulum && state.initialAngle > 15) {
      status += '  \u26A0 ${l10n.shmStatusLargeAngle}';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1F0A),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF00FF41).withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              formula,
              style: const TextStyle(
                color: Color(0xFF00FF41),
                fontFamily: 'monospace',
                fontSize: 9,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              status,
              style: const TextStyle(color: Colors.white54, fontSize: 9),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
