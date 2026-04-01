import 'package:flutter/material.dart';
import '../../../core/models/element.dart';
import '../../../core/theme/app_colors.dart';

class ElementInfoCard extends StatelessWidget {
  final ChemElement element;

  const ElementInfoCard({super.key, required this.element});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                element.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              Text(
                'Mass: ${element.atomicMass}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            element.category,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.orbitalS,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const Divider(height: 24, color: AppColors.borderDefault),
          Text(
            element.funFact,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _InfoBadge(label: 'Period', value: element.period),
              const SizedBox(width: 8),
              _InfoBadge(label: 'Group', value: element.group),
              const SizedBox(width: 8),
              _InfoBadge(label: 'Valence', value: '${element.valenceElectrons}e⁻'),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final String label;
  final String value;

  const _InfoBadge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 11, color: AppColors.textPrimary),
      ),
    );
  }
}
