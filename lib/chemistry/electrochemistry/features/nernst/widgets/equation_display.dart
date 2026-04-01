import 'package:flutter/material.dart';
import '../providers/nernst_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class EquationDisplay extends StatelessWidget {
  final NernstState state;

  const EquationDisplay({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.bgSurface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.accentPurple.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        children: [
          const Text(
            'Nernst Equation',
            style: TextStyle(
              color: AppColors.accentPurple,
              fontWeight: FontWeight.bold,
              fontSize: 10,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _mathText('E = E° - ', size: 22),
                Column(
                  children: [
                    _mathText('RT', size: 14),
                    Container(width: 30, height: 1.5, color: AppColors.textPrimary),
                    _mathText('nF', size: 14),
                  ],
                ),
                _mathText(' ln(Q)', size: 22),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _infoTile('n = ${state.n}e⁻'),
              const SizedBox(width: AppSpacing.md),
              _infoTile('T = ${state.temperatureK.toStringAsFixed(1)}K'),
              const SizedBox(width: AppSpacing.md),
              _infoTile('Q = ${state.reactionQuotient.toStringAsFixed(3)}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mathText(String text, {double size = 18}) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'JetBrains Mono',
        fontSize: size,
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _infoTile(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        text,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
      ),
    );
  }
}
