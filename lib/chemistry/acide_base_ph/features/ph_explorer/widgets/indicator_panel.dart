import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/indicators.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/indicator_calculator.dart';
import '../providers/ph_provider.dart';

class IndicatorPanel extends ConsumerWidget {
  const IndicatorPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ph = ref.watch(phProvider).ph;

    return Column(
      children: kIndicators.map((indicator) {
        final color = IndicatorCalculator.colorForPH(indicator, ph);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderDefault, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    indicator.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _colorLabel(indicator, ph),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                'Indicator color',
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: AppColors.textHint),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _colorLabel(Indicator indicator, double ph) {
    if (ph < indicator.transitionLow) return 'Acidic color phase';
    if (ph > indicator.transitionHigh) return 'Basic color phase';
    return 'Neutral / Transitioning';
  }
}
