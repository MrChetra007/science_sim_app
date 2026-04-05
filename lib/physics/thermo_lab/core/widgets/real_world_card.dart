import 'package:flutter/material.dart';
import '../constants/real_world_examples.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class RealWorldCard extends StatelessWidget {
  final RealWorldExample example;
  final Color accentColor;

  const RealWorldCard({
    super.key,
    required this.example,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                example.emoji,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Real World: ${example.title}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: accentColor,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            example.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}
