import 'package:flutter/material.dart';
import '../thermo_laws_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import 'animated_formula_box.dart';

class LawCard extends StatelessWidget {
  final ThermoLaw law;
  final Color accentColor;

  const LawCard({
    super.key,
    required this.law,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.bgSurface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.borderDefault,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    accentColor.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                   Container(
                     padding: const EdgeInsets.all(10),
                     decoration: BoxDecoration(
                       color: accentColor.withValues(alpha: 0.1),
                       shape: BoxShape.circle,
                     ),
                     child: Text(
                       law.emoji,
                       style: const TextStyle(fontSize: 24),
                     ),
                   ),
                   const SizedBox(width: AppSpacing.md),
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                        Text(
                          '${law.number} Law',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: accentColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        Text(
                          law.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 20,
                          ),
                        ),
                     ],
                   ),
                ],
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Statement Quote
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.bgElevated.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.borderDefault,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '"${law.statement}"',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: AppColors.textPrimary,
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  
                  // Formula Section
                  Text(
                    'Mathematical Formula',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  AnimatedFormulaBox(
                    formula: law.formula,
                    accentColor: accentColor,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  
                  // Explanation
                  Text(
                    law.explanation,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Divider(height: AppSpacing.lg, color: AppColors.borderDefault),
                  
                  // Real World
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🌍', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          law.realWorld,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
