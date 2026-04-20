import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import '../providers/entropy_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class EntropyControls extends ConsumerWidget {
  const EntropyControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(entropyProvider);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Main Action Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: settings.wallRemoved 
              ? null 
              : () => ref.read(entropyProvider.notifier).removeWall(),
            icon: const Icon(Icons.layers_clear),
            label: Text(l10n.removePartition),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentEntropy,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.bgElevated,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        
        // Reset Button
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.outlined(
              onPressed: () => ref.read(entropyProvider.notifier).reset(),
              icon: const Icon(Icons.refresh),
              style: IconButton.styleFrom(
                side: const BorderSide(color: AppColors.borderDefault),
                foregroundColor: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Text('Reset Experiment', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}
