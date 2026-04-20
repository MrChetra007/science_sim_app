import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import '../../../l10n/generated/app_localizations.dart';
import '../providers/wave_provider.dart';

class MathsDerivationSheet extends ConsumerWidget {
  const MathsDerivationSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(waveProvider);

    // Live derived values
    final omega = 2 * pi * state.frequency;
    final wavelength = state.waveSpeed / state.frequency;
    final k = 2 * pi / wavelength;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF040D17),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  children: [
                    Text(
                      l10n.mathDerivationTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.mathLiveValues,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 24),

                    _section(
                      l10n.mathWaveEquation,
                      l10n.mathWaveEquationDesc,
                      'y(x, t) = ${state.amplitude.toStringAsFixed(2)} sin(${k.toStringAsFixed(2)}x - ${omega.toStringAsFixed(2)}t)',
                      subtitle: 'y(x, t) = A sin(kx - ωt)',
                    ),

                    if (state.mode == WaveMode.standing)
                      _section(
                        l10n.mathStandingCondition,
                        l10n.mathStandingConditionDesc,
                        'y(x, t) = [2(${state.amplitude.toStringAsFixed(2)}) sin(${k.toStringAsFixed(2)}x)] cos(${omega.toStringAsFixed(2)}t)',
                        subtitle: 'y(x, t) = [2A sin(kx)] cos(ωt)',
                      ),

                    _section(
                      l10n.mathParticleVelocity,
                      l10n.mathParticleVelocityDesc,
                      'v_y = -${(state.amplitude * omega).toStringAsFixed(2)} cos(${k.toStringAsFixed(2)}x - ${omega.toStringAsFixed(2)}t)',
                      subtitle: 'v_y = -Aω cos(kx - ωt)',
                    ),

                    _section(
                      l10n.mathWaveParameters,
                      l10n.mathWaveParametersDesc,
                      '${state.waveSpeed.toStringAsFixed(0)} = ${state.frequency.toStringAsFixed(1)} × ${wavelength.toStringAsFixed(2)}',
                      subtitle: 'v = fλ',
                    ),

                    const Divider(color: Colors.white12, height: 40),
                    Text(
                      l10n.mathCurrentValues,
                      style: TextStyle(
                        color: Color(0xFF00E5FF),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _variable(
                      'A',
                      '${state.amplitude.toStringAsFixed(2)} m (${l10n.mathAmplitudeLabel})',
                    ),
                    _variable(
                      'f',
                      '${state.frequency.toStringAsFixed(1)} Hz (${l10n.mathFrequencyLabel})',
                    ),
                    _variable(
                      'v',
                      '${state.waveSpeed.toStringAsFixed(0)} m/s (${l10n.mathSpeedLabel})',
                    ),
                    _variable(
                      'λ',
                      '${wavelength.toStringAsFixed(2)} m (${l10n.mathWavelengthLabel})',
                    ),
                    _variable(
                      'ω',
                      '${omega.toStringAsFixed(2)} rad/s (${l10n.mathAngularFreqLabel})',
                    ),
                    _variable(
                      'k',
                      '${k.toStringAsFixed(2)} rad/m (${l10n.mathWaveNumberLabel})',
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _section(
    String title,
    String description,
    String formula, {
    String? subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF00E5FF),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Text(
              formula,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'monospace',
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _variable(String symbol, String meaning) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30,
            child: Text(
              symbol,
              style: const TextStyle(
                color: Color(0xFF00E5FF),
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
          ),
          Expanded(
            child: Text(
              meaning,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
