import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/gas_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class VariableSliders extends ConsumerWidget {
  const VariableSliders({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gasProvider);

    return Column(
      children: [
        _SliderRow(
          label: 'Pressure (P)',
          value: state.pressure.clamp(GasState.minP, GasState.maxP),
          min: GasState.minP,
          max: GasState.maxP,
          unit: 'atm',
          color: AppColors.accentHeat,
          onChanged: (val) => ref.read(gasProvider.notifier).setPressure(val),
          isEnabled: state.law != GasLaw.charles,
        ),
        const SizedBox(height: AppSpacing.sm),
        _SliderRow(
          label: 'Volume (V)',
          value: state.volume.clamp(GasState.minV, GasState.maxV),
          min: GasState.minV,
          max: GasState.maxV,
          unit: 'L',
          color: AppColors.accentGas,
          onChanged: (val) => ref.read(gasProvider.notifier).setVolume(val),
          isEnabled: state.law != GasLaw.gayLussac,
        ),
        const SizedBox(height: AppSpacing.sm),
        _SliderRow(
          label: 'Temperature (T)',
          value: state.temperature.clamp(GasState.minT, GasState.maxT),
          min: GasState.minT,
          max: GasState.maxT,
          unit: 'K',
          color: AppColors.accentCarnot,
          onChanged: (val) => ref.read(gasProvider.notifier).setTemperature(val),
          isEnabled: state.law != GasLaw.boyle,
        ),
      ],
    );
  }
}

class _SliderRow extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final String unit;
  final Color color;
  final ValueChanged<double> onChanged;
  final bool isEnabled;

  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.unit,
    required this.color,
    required this.onChanged,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isEnabled ? AppColors.textPrimary : AppColors.textHint,
                    fontWeight: isEnabled ? FontWeight.bold : FontWeight.normal,
                  ),
            ),
            Text(
              '${value.toStringAsFixed(2)} $unit',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isEnabled ? color : AppColors.textHint,
                  ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            disabledActiveTrackColor: AppColors.textHint.withOpacity(0.3),
            disabledInactiveTrackColor: AppColors.textHint.withOpacity(0.1),
            disabledThumbColor: AppColors.textHint,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            activeColor: color,
            onChanged: isEnabled ? onChanged : null,
          ),
        ),
      ],
    );
  }
}
