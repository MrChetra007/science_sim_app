import 'package:flutter/material.dart';
import '../../../core/theme/voltage_colors.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class VoltmeterWidget extends StatelessWidget {
  final double voltage;

  const VoltmeterWidget({super.key, required this.voltage});

  @override
  Widget build(BuildContext context) {
    final vColor = VoltageColors.forVoltage(voltage);

    return Container(
      width: 140,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: vColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: vColor.withValues(alpha: 0.15),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'E°cell (V)',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            voltage.toStringAsFixed(3),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: vColor,
              fontFamily: 'JetBrains Mono',
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}
