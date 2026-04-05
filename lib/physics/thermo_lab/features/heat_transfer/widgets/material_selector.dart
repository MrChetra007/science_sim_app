import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/materials.dart';
import '../providers/heat_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class MaterialSelector extends ConsumerWidget {
  const MaterialSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(heatProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Material',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderDefault),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<ThermalMaterial>(
              value: state.selectedMaterial,
              dropdownColor: AppColors.bgSurface,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: AppColors.accentHeat),
              items: kMaterials.map((material) {
                return DropdownMenuItem<ThermalMaterial>(
                  value: material,
                  child: Row(
                    children: [
                      Text(material.emoji),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        material.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textPrimary,
                            ),
                      ),
                      const Spacer(),
                      Text(
                        '${material.conductivity} W/m·K',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (material) {
                if (material != null) {
                  ref.read(heatProvider.notifier).setMaterial(material);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
