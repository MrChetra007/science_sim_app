import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/substances.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/ph_colors.dart';
import '../providers/ph_provider.dart';

class SubstanceGrid extends ConsumerWidget {
  const SubstanceGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(phProvider).selectedSubstance;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: kSubstances.map((substance) {
        final isSelected = selected?.name == substance.name;
        final color = PHColors.forPH(substance.ph);

        return GestureDetector(
          onTap: () => ref.read(phProvider.notifier).selectSubstance(substance),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withOpacity(0.15)
                  : AppColors.bgElevated,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(
                color: isSelected ? color : AppColors.borderDefault,
                width: isSelected ? 1.5 : 0.5,
              ),
            ),
            child: Text(
              '${substance.emoji} ${substance.name}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
