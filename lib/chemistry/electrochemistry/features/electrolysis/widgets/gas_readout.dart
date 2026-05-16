import 'package:flutter/material.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import '../providers/electrolysis_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class GasReadout extends StatelessWidget {
  final ElectrolysisState state;

  const GasReadout({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.borderDefault, width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _GasBox(
            label: '${AppLocalizations.of(context)!.anode} (${state.electrolyte.anodeProduct})',
            volume: state.anodeGasVolume,
            color: state.electrolyte.anodeGasColor,
          ),
          Container(width: 1, height: 40, color: AppColors.borderDefault),
          _GasBox(
            label: '${AppLocalizations.of(context)!.cathode} (${state.electrolyte.cathodeProduct})',
            volume: state.cathodeGasVolume,
            color: state.electrolyte.cathodeGasColor,
          ),
        ],
      ),
    );
  }
}

class _GasBox extends StatelessWidget {
  final String label;
  final double volume;
  final Color color;

  const _GasBox({required this.label, required this.volume, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: color.withValues(alpha: 0.8), fontSize: 10, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          '${volume.toStringAsFixed(2)} mL',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'JetBrains Mono',
          ),
        ),
      ],
    );
  }
}
