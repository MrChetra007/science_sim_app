import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'providers/galvanic_provider.dart';
import 'widgets/cell_canvas_widget.dart';
import 'widgets/electrode_selector.dart';
import 'widgets/voltmeter_widget.dart';
import 'widgets/half_reaction_panel.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/explanation_panel.dart';

class GalvanicScreen extends ConsumerWidget {
  const GalvanicScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(galvanicNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.galvanicCell),
        backgroundColor: AppColors.bgDeep,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              final l10n = AppLocalizations.of(context)!;
              ExplanationPanel.show(
                context,
                title: l10n.galvanicCellBasics,
                sections: [
                  ExplanationSection(
                    title: l10n.howItWorks,
                    content: l10n.galvanicCellHowItWorksDesc,
                  ),
                  ExplanationSection(
                    title: l10n.electromotiveForce,
                    content: l10n.cellPotentialDesc,
                    formula: 'E°cell = E°cathode - E°anode',
                  ),
                  ExplanationSection(
                    title: l10n.saltBridge,
                    content: l10n.saltBridgeDesc,
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Live Cell Canvas (Flame widget/CustomPainter placeholder)
          Expanded(flex: 3, child: CellCanvasWidget(state: state)),

          const SizedBox(height: AppSpacing.md),

          // 2. Electrode Selectors
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: ElectrodeSelector(
                    label: AppLocalizations.of(context)!.anodeLabel,
                    selected: state.anode,
                    onChanged: (e) {
                      if (e != null) {
                        ref.read(galvanicNotifierProvider.notifier).setAnode(e);
                      }
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElectrodeSelector(
                    label: AppLocalizations.of(context)!.cathodeLabel,
                    selected: state.cathode,
                    onChanged: (e) {
                      if (e != null) {
                        ref
                            .read(galvanicNotifierProvider.notifier)
                            .setCathode(e);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // 3. Metrics Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VoltmeterWidget(voltage: state.cellPotential),
                const SizedBox(width: AppSpacing.md),
                HalfReactionPanel(state: state),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
