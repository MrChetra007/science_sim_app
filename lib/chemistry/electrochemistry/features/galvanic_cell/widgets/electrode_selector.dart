import 'package:flutter/material.dart';
import '../../../core/constants/electrodes.dart';
import '../../../core/theme/electrode_colors.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class ElectrodeSelector extends StatelessWidget {
  final String label;
  final Electrode selected;
  final ValueChanged<Electrode?> onChanged;

  const ElectrodeSelector({
    super.key,
    required this.label,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.bgSurface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: ElectrodeColors.metalFill[selected.symbol] ?? AppColors.borderDefault,
              width: 1.5,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Electrode>(
              value: selected,
              icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
              isExpanded: true,
              dropdownColor: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              items: kElectrodes.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: ElectrodeColors.metalFill[e.symbol],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '${e.symbol} — ${e.name}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
