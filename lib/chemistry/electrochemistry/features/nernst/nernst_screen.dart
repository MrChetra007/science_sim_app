import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/nernst_provider.dart';
import 'widgets/nernst_chart.dart';
import 'widgets/equation_display.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/voltage_colors.dart';
import '../../../core/widgets/explanation_panel.dart';

class NernstScreen extends ConsumerWidget {
  const NernstScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(nernstNotifierProvider);
    final notifier = ref.read(nernstNotifierProvider.notifier);
    final spots = notifier.generateLinearPoints();

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      appBar: AppBar(
        title: const Text('Nernst Equation'),
        backgroundColor: AppColors.bgDeep,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => ExplanationPanel.show(
              context,
              title: 'Nernst Equation Explorer',
              sections: [
                ExplanationSection(
                  title: 'Non-Standard Conditions',
                  content: 'Standard cell potentials (E°) are measured at 25°C and 1.0M concentration. The Nernst Equation calculates the actual potential under any other conditions.',
                ),
                ExplanationSection(
                  title: 'The Equation',
                  content: 'E = E° - (RT/nF) * ln(Q)',
                  formula: 'E = E° - (0.0592/n) * log10(Q) at 25°C',
                ),
                ExplanationSection(
                  title: 'Reaction Quotient (Q)',
                  content: 'Q is the ratio of product concentration to reactant concentration. If [Red] increases, Q increases and the cell potential (E) decreases.',
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            // 1. Interactive Chart
            NernstChart(state: state, spots: spots),

            const SizedBox(height: AppSpacing.lg),

            // 2. Equation Readout
            EquationDisplay(state: state),

            const SizedBox(height: AppSpacing.lg),

            // 3. Result Banner
            _ResultBanner(voltage: state.actualPotential),

            const SizedBox(height: AppSpacing.xl),

            // 4. Controls
            _SliderSection(
              title: 'Temperature (K)',
              value: state.temperatureK,
              min: 273.15,
              max: 373.15,
              onChanged: (v) => notifier.setTemperature(v),
              displayValue: '${(state.temperatureK - 273.15).toStringAsFixed(1)}°C',
            ),
            const SizedBox(height: AppSpacing.md),
            _SliderSection(
              title: '[Ox] Concentration (M)',
              value: state.concentrationOx,
              min: 0.1,
              max: 2.0,
              onChanged: (v) => notifier.setConcentrationOx(v),
              displayValue: '${state.concentrationOx.toStringAsFixed(2)}M',
            ),
            const SizedBox(height: AppSpacing.md),
            _SliderSection(
              title: '[Red] Concentration (M)',
              value: state.concentrationRed,
              min: 0.1,
              max: 2.0,
              onChanged: (v) => notifier.setConcentrationRed(v),
              displayValue: '${state.concentrationRed.toStringAsFixed(2)}M',
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _ResultBanner extends StatelessWidget {
  final double voltage;

  const _ResultBanner({required this.voltage});

  @override
  Widget build(BuildContext context) {
    final color = VoltageColors.forVoltage(voltage);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.2), Colors.transparent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ACTUAL CELL POTENTIAL (E)',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 10, letterSpacing: 1.0),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${voltage.toStringAsFixed(3)} V',
              style: TextStyle(
                color: color,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'JetBrains Mono',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliderSection extends StatelessWidget {
  final String title;
  final double value;
  final double min;
  final double max;
  final String displayValue;
  final ValueChanged<double> onChanged;

  const _SliderSection({
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.displayValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
            Text(displayValue, style: const TextStyle(color: AppColors.accentPurple, fontWeight: FontWeight.bold)),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
          activeColor: AppColors.accentPurple,
          inactiveColor: AppColors.bgElevated,
        ),
      ],
    );
  }
}
