import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/phase_provider.dart';
import '../../../core/constants/substances.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class PhaseControls extends ConsumerWidget {
  const PhaseControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(phaseProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Play/Pause and Reset
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.filled(
              onPressed: () => ref.read(phaseProvider.notifier).togglePlay(),
              icon: Icon(
                state.isPaused ? Icons.play_arrow : Icons.pause,
                size: 32,
              ),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.accentPhase,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            IconButton.outlined(
              onPressed: () => ref.read(phaseProvider.notifier).reset(),
              icon: const Icon(Icons.refresh),
              style: IconButton.styleFrom(
                side: const BorderSide(color: AppColors.borderDefault),
                foregroundColor: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        
        // Substance Selector
        Text(
          'Substance',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.bgElevated,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderDefault),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<PhaseSubstance>(
              value: state.substance,
              isExpanded: true,
              dropdownColor: AppColors.bgElevated,
              style: const TextStyle(color: AppColors.textPrimary),
              items: kPhaseSubstances.map((s) {
                return DropdownMenuItem(
                  value: s,
                  child: Text('${s.emoji} ${s.name}'),
                );
              }).toList(),
              onChanged: (s) {
                if (s != null) {
                  ref.read(phaseProvider.notifier).selectSubstance(s);
                }
              },
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        
        // Heat Rate Slider
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Heat Flow (Watts)',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            Text(
              '${state.heatRateWatts.toInt()} J/s',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.accentHeat,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        Slider(
          value: state.heatRateWatts,
          min: 100.0,
          max: 1000.0,
          activeColor: AppColors.accentHeat,
          onChanged: (val) => ref.read(phaseProvider.notifier).setHeatRate(val),
        ),
      ],
    );
  }
}
