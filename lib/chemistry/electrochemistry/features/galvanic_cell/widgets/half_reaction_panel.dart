import 'package:flutter/material.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import '../providers/galvanic_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class HalfReactionPanel extends StatelessWidget {
  final GalvanicState state;

  const HalfReactionPanel({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.borderDefault, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ReactionRow(
              label: AppLocalizations.of(context)!.oxidationAnode,
              reaction: state.anodeReaction,
              color: AppColors.accentAmber,
            ),
            const Divider(color: AppColors.borderDefault, height: AppSpacing.md),
            _ReactionRow(
              label: AppLocalizations.of(context)!.reductionCathode,
              reaction: state.cathodeReaction,
              color: AppColors.accentGreen,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReactionRow extends StatelessWidget {
  final String label;
  final String reaction;
  final Color color;

  const _ReactionRow({
    required this.label,
    required this.reaction,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            reaction,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontFamily: 'JetBrains Mono',
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
