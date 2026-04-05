import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/gas_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class GasLawTabs extends ConsumerWidget {
  const GasLawTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gasProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Row(
        children: [
          _buildTab(context, ref, "Boyle's", GasLaw.boyle, state.law),
          _buildTab(context, ref, "Charles's", GasLaw.charles, state.law),
          _buildTab(context, ref, "Gay-Lussac", GasLaw.gayLussac, state.law),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, WidgetRef ref, String title, GasLaw law, GasLaw current) {
    final isSelected = law == current;
    return Expanded(
      child: InkWell(
        onTap: () => ref.read(gasProvider.notifier).setLaw(law),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accentGas : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.black : AppColors.textSecondary,
                ),
          ),
        ),
      ),
    );
  }
}
