import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/ph_colors.dart';
import '../providers/ph_provider.dart';

class PHSliderWidget extends ConsumerWidget {
  const PHSliderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ph = ref.watch(phProvider).ph;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'pH Level',
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
            ),
            const Spacer(),
            Text(
              ph.toStringAsFixed(1),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: PHColors.forPH(ph)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 8,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
            activeTrackColor: PHColors.forPH(ph),
            inactiveTrackColor: AppColors.bgElevated,
            thumbColor: PHColors.forPH(ph),
            overlayColor: PHColors.forPH(ph).withOpacity(0.2),
          ),
          child: Slider(
            min: 0,
            max: 14,
            divisions: 140,
            value: ph,
            onChanged: (v) => ref.read(phProvider.notifier).setPH(v),
          ),
        ),
        // pH scale labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['0', '2', '4', '6', '7', '8', '10', '12', '14']
              .map(
                (n) => Text(
                  n,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: AppColors.textHint),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
