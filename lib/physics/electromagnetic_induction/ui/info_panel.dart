import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sim_provider.dart';

class InfoPanel extends ConsumerWidget {
  const InfoPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(simProvider);

    final infoText = _getInfoText(state.magnetY);
    final dirText = state.emf > 0
        ? 'CCW'
        : (state.emf < 0 ? 'CW' : '—');
    final dirColor = state.emf > 0
        ? const Color(0xFFFFCA28)
        : (state.emf < 0 ? const Color(0xFFFF7043) : Colors.grey);

    final dFluxDt = state.deltaT > 0
        ? state.dFlux / state.deltaT
        : 0.0;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      color: const Color(0xFF252525),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _FormulaDisplay(
            turns: state.turns,
            dFlux: state.dFlux,
            dt: state.deltaT,
            emf: state.emf,
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _Metric(
                label: 'EMF',
                value: '${state.emf.toStringAsFixed(2)} V',
                color: const Color(0xFF00FF41),
              ),
              _Metric(
                label: 'Flux Φ',
                value: '${state.flux.toStringAsFixed(3)} Wb',
                color: const Color(0xFF42A5F5),
              ),
              _Metric(
                label: 'dΦ/dt',
                value: '${dFluxDt.toStringAsFixed(2)} Wb/s',
                color: const Color(0xFFCE93D8),
              ),
              _Metric(label: 'Dir', value: dirText, color: dirColor),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            infoText,
            style: const TextStyle(color: Colors.white54, fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getInfoText(double magnetY) {
    final absY = magnetY.abs();
    if (absY > 0.85) return 'At extremes — Velocity = 0, EMF = 0';
    if (absY < 0.15) return 'At coil center — Max velocity, Peak EMF';
    if (magnetY < 0) return 'Entering coil — Flux increasing, EMF induced';
    return 'Exiting coil — Flux decreasing, EMF reverses (Lenz)';
  }
}

class _FormulaDisplay extends StatelessWidget {
  final int turns;
  final double dFlux;
  final double dt;
  final double emf;

  const _FormulaDisplay({
    required this.turns,
    required this.dFlux,
    required this.dt,
    required this.emf,
  });

  @override
  Widget build(BuildContext context) {
    final dFluxStr = dFlux.toStringAsFixed(4);
    final dtStr = dt.toStringAsFixed(3);
    final emfStr = emf.toStringAsFixed(2);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF333355)),
      ),
      child: Column(
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 13, fontFamily: 'monospace'),
              children: [
                TextSpan(
                  text: 'EMF = ',
                  style: TextStyle(color: Color(0xFF00FF41)),
                ),
                TextSpan(
                  text: '-N × ΔΦ/Δt',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              children: [
                TextSpan(
                  text: '= ',
                  style: TextStyle(color: emf.abs() > 0.01
                      ? const Color(0xFF00FF41)
                      : Colors.grey),
                ),
                TextSpan(
                  text: '-$turns × ($dFluxStr / $dtStr)',
                  style: const TextStyle(color: Color(0xFFCE93D8)),
                ),
                TextSpan(
                  text: ' = ',
                  style: TextStyle(color: emf.abs() > 0.01
                      ? const Color(0xFF00FF41)
                      : Colors.grey),
                ),
                TextSpan(
                  text: '$emfStr V',
                  style: TextStyle(
                    color: emf.abs() > 0.01
                        ? const Color(0xFF00FF41)
                        : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _Metric({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.grey, fontSize: 10)),
        const SizedBox(height: 2),
        Text(value,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            )),
      ],
    );
  }
}
