import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flame/game.dart';
import 'providers/electrolysis_provider.dart';
import 'flame/electrolysis_game.dart';
import 'widgets/gas_readout.dart';
import '../../../core/constants/electrolytes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/explanation_panel.dart';

class ElectrolysisScreen extends ConsumerStatefulWidget {
  const ElectrolysisScreen({super.key});

  @override
  ConsumerState<ElectrolysisScreen> createState() => _ElectrolysisScreenState();
}

class _ElectrolysisScreenState extends ConsumerState<ElectrolysisScreen> {
  late final ElectrolysisGame _game;

  @override
  void initState() {
    super.initState();
    final state = ref.read(electrolysisNotifierProvider);
    _game = ElectrolysisGame(state: state);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(electrolysisNotifierProvider);
    
    // Update game state
    _game.updateState(state);

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      appBar: AppBar(
        title: const Text('Electrolysis Lab'),
        backgroundColor: AppColors.bgDeep,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => ExplanationPanel.show(
              context,
              title: 'Electrolysis Lab',
              sections: [
                ExplanationSection(
                  title: 'Non-Spontaneous Reactions',
                  content: 'Electrolysis uses electrical energy to drive a chemical reaction that would not otherwise occur. It is the opposite of a galvanic cell.',
                ),
                ExplanationSection(
                  title: 'Decomposition of NaCl',
                  content: 'In aqueous NaCl, chloride ions are oxidized at the anode (forming Cl2 gas) and water is reduced at the cathode (forming H2 gas).',
                ),
                ExplanationSection(
                  title: 'Threshold Voltage',
                  content: 'Each electrolyte has a specific decomposition voltage (Vmin). If the applied voltage is lower than Vmin, no reaction occurs.',
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Simulation Canvas
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.borderDefault, width: 0.5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: GameWidget(game: _game),
              ),
            ),
          ),

          // 2. Gas Volume Readouts
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: GasReadout(state: state),
          ),

          const SizedBox(height: AppSpacing.lg),

          // 3. Controls Area
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
            ),
            child: Column(
              children: [
                _VoltageControl(
                  voltage: state.appliedVoltage,
                  threshold: state.electrolyte.thresholdVoltage,
                  isPowerOn: state.isPowerOn,
                  onChanged: (v) => ref.read(electrolysisNotifierProvider.notifier).setVoltage(v),
                  onToggle: (on) => ref.read(electrolysisNotifierProvider.notifier).togglePower(on),
                ),
                const SizedBox(height: AppSpacing.xl),
                _ElectrolytePicker(
                  selected: state.electrolyte,
                  onSelected: (e) => ref.read(electrolysisNotifierProvider.notifier).setElectrolyte(e),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VoltageControl extends StatelessWidget {
  final double voltage;
  final double threshold;
  final bool isPowerOn;
  final ValueChanged<double> onChanged;
  final ValueChanged<bool> onToggle;

  const _VoltageControl({
    required this.voltage,
    required this.threshold,
    required this.isPowerOn,
    required this.onChanged,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isGlowing = isPowerOn && voltage >= threshold;
    final accentColor = isGlowing ? AppColors.accentElectric : AppColors.textHint;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('EXTERNAL POWER SUPPLY', style: TextStyle(color: AppColors.textSecondary, fontSize: 10, letterSpacing: 1.0)),
                Text(
                  '${voltage.toStringAsFixed(1)}V',
                  style: TextStyle(color: accentColor, fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'JetBrains Mono'),
                ),
              ],
            ),
            Switch(
              value: isPowerOn,
              onChanged: onToggle,
              activeColor: AppColors.accentElectric,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Slider(
          value: voltage,
          min: 0,
          max: 12,
          onChanged: onChanged,
          activeColor: accentColor,
        ),
        Text(
          'Minimum voltage required: ${threshold.toStringAsFixed(2)}V',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
        ),
      ],
    );
  }
}

class _ElectrolytePicker extends StatelessWidget {
  final Electrolyte selected;
  final ValueChanged<Electrolyte> onSelected;

  const _ElectrolytePicker({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('ELECTROLYTE SOLUTION', style: TextStyle(color: AppColors.textSecondary, fontSize: 10, letterSpacing: 1.0)),
        const SizedBox(height: AppSpacing.md),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: kElectrolytes.map((e) {
              final isSelected = e.formula == selected.formula;
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: ChoiceChip(
                  label: Text(e.formula, style: TextStyle(color: isSelected ? Colors.white : AppColors.textSecondary)),
                  selected: isSelected,
                  onSelected: (val) => onSelected(e),
                  selectedColor: AppColors.accentPurple,
                  backgroundColor: AppColors.bgElevated,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
