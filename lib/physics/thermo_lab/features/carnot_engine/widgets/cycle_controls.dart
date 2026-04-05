import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/carnot_provider.dart';
import '../flame/carnot_game.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class CycleControls extends ConsumerWidget {
  final CarnotGame game;

  const CycleControls({super.key, required this.game});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(carnotProvider);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.filled(
              onPressed: () => ref.read(carnotProvider.notifier).togglePlay(),
              icon: Icon(
                state.isPaused ? Icons.play_arrow : Icons.pause,
                size: 32,
              ),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.accentCarnot,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Flexible(
              child: ValueListenableBuilder<CarnotStep>(
                valueListenable: game.stepNotifier,
                builder: (context, step, child) {
                  return Text(
                    _getStepName(step),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Slider(
              label: 'Hot Reservoir (Th)',
              value: state.tempHot,
              min: 400.0,
              max: 1000.0,
              color: const Color(0xFFFF5252),
              onChanged: (val) => ref.read(carnotProvider.notifier).setTempHot(val),
            ),
            _Slider(
              label: 'Cold Reservoir (Tc)',
              value: state.tempCold,
              min: 100.0,
              max: 350.0,
              color: const Color(0xFF448AFF),
              onChanged: (val) => ref.read(carnotProvider.notifier).setTempCold(val),
            ),
          ],
        ),
      ],
    );
  }

  String _getStepName(CarnotStep step) {
    switch (step) {
      case CarnotStep.isothermalExpansion:
        return 'Isothermal Expansion ($Q_in)';
      case CarnotStep.adiabaticExpansion:
        return 'Adiabatic Expansion ($W_out)';
      case CarnotStep.isothermalCompression:
        return 'Isothermal Compression ($Q_out)';
      case CarnotStep.adiabaticCompression:
        return 'Adiabatic Compression ($W_in)';
    }
  }

  static const String Q_in = 'Qin';
  static const String Q_out = 'Qout';
  static const String W_in = 'Win';
  static const String W_out = 'Wout';
}

class _Slider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final Color color;
  final ValueChanged<double> onChanged;

  const _Slider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.color,
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
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '${value.toInt()}K',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: color,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
