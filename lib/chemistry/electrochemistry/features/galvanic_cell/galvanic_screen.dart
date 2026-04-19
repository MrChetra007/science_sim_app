import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        title: const Text('Galvanic Cell'),
        backgroundColor: AppColors.bgDeep,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => ExplanationPanel.show(
              context,
              title: 'Galvanic Cell Basics',
              sections: [
                ExplanationSection(
                  title: 'How it Works',
                  content:
                      'A galvanic (voltaic) cell converts chemical energy into electrical energy through spontaneous redox reactions. Electrons flow from the Anode to the Cathode.',
                ),
                ExplanationSection(
                  title: 'Electromotive Force',
                  content:
                      'The cell potential is calculated by the difference between the reduction potentials of the two electrodes.',
                  formula: 'E°cell = E°cathode - E°anode',
                ),
                ExplanationSection(
                  title: 'Salt Bridge',
                  content:
                      'The salt bridge completes the circuit and maintains electrical neutrality by allowing ions to flow between the two half-cells.',
                ),
              ],
            ),
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
                    label: 'Anode (−)',
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
                    label: 'Cathode (+)',
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
