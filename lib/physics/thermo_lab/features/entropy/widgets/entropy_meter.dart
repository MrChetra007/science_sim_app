import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class EntropyMeter extends StatelessWidget {
  final double value; // 0.0 to 1.0

  const EntropyMeter({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    // Gradient from Ordered (Teal) to Disordered (Purple)
    final color = Color.lerp(
      AppColors.accentLaws,    // Teal
      AppColors.accentEntropy, // Purple
      value.clamp(0.0, 1.0),
    )!;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.bgSurface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Entropy (Disorder)',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              Text(
                '${(value * 100).toInt()}%',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          
          // Progress Bar with Glow
          Stack(
            children: [
              Container(
                height: 12,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.24),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              FractionallySizedBox(
                widthFactor: value.clamp(0.01, 1.0), // ensure some visibility
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('ORDER', style: TextStyle(color: Colors.grey, fontSize: 8)),
              const Text('MAX DISORDER', style: TextStyle(color: Colors.grey, fontSize: 8)),
            ],
          ),
        ],
      ),
    );
  }
}
