import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/carnot_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class EfficiencyCard extends ConsumerWidget {
  const EfficiencyCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(carnotProvider);
    final efficiencyPercent = (state.efficiency * 100).toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm), // reduced padding
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDefault, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Efficiency (η)',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 10, // slightly smaller
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.accentCarnot.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$efficiencyPercent%',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.accentCarnot,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(color: AppColors.borderDefault),
          const SizedBox(height: AppSpacing.sm),
          _FormulaRow(
            label: 'Goal:',
            formula: 'η = 1 - (Tc/Th)',
          ),
          const SizedBox(height: AppSpacing.xs),
          _FormulaRow(
            label: 'Actual:',
            formula: '${state.tempCold.toInt()}K/${state.tempHot.toInt()}K',
          ),
        ],
      ),
    );
  }
}

class _FormulaRow extends StatelessWidget {
  final String label;
  final String formula;

  const _FormulaRow({required this.label, required this.formula});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Flexible(
          child: Text(
            formula,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textPrimary,
              fontStyle: FontStyle.italic,
              fontSize: 10,
            ),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
