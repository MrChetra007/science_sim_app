import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flame/game.dart';
import 'providers/electroplating_provider.dart';
import 'providers/electroplating_state.dart';
import 'flame/electroplating_game.dart';
import '../../core/constants/electrodes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/electrode_colors.dart';
import '../../core/widgets/explanation_panel.dart';

class ElectroplatingScreen extends ConsumerStatefulWidget {
  const ElectroplatingScreen({super.key});

  @override
  ConsumerState<ElectroplatingScreen> createState() =>
      _ElectroplatingScreenState();
}

class _ElectroplatingScreenState extends ConsumerState<ElectroplatingScreen> {
  late final ElectroplatingGame _game;

  @override
  void initState() {
    super.initState();
    final state = ref.read(electroplatingNotifierProvider);
    _game = ElectroplatingGame(state: state);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(electroplatingNotifierProvider);
    _game.updateState(state);

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      appBar: AppBar(
        title: const Text('Electroplating Lab'),
        backgroundColor: AppColors.bgDeep,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => ExplanationPanel.show(
              context,
              title: 'Electroplating Secrets',
              sections: [
                ExplanationSection(
                  title: 'What is Electroplating?',
                  content:
                      'A process of coating a base metal (like iron or brass) with a layer of a more precious metal (like gold or silver) via an electrolytic reaction.',
                ),
                ExplanationSection(
                  title: 'Faraday\'s Law',
                  content:
                      'The mass of the metal deposited is directly proportional to the amount of electric charge passed through the solution.',
                  formula: 'm = (I * t * M) / (n * F)',
                ),
                ExplanationSection(
                  title: 'Molar Mass & Valence',
                  content:
                      'Heavier metals with higher molar masses plate more mass per hour, while higher valence (n) values slow down the process because more electrons are needed per atom.',
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Simulation Area
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

          // 2. Mass Readout
          _MassReadout(
            mass: state.depositedMassMg,
            time: state.durationSeconds,
          ),

          // 3. Control Panel
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.xl),
              ),
            ),
            child: Column(
              children: [
                _CurrentControl(
                  amps: state.currentAmps,
                  isPlating: state.isPlating,
                  onChanged: (v) => ref
                      .read(electroplatingNotifierProvider.notifier)
                      .setCurrent(v),
                  onToggle: (on) => ref
                      .read(electroplatingNotifierProvider.notifier)
                      .setIsPlating(on),
                ),
                const SizedBox(height: AppSpacing.lg),
                _ObjectSelector(
                  selected: state.target,
                  onSelected: (obj) => ref
                      .read(electroplatingNotifierProvider.notifier)
                      .setTarget(obj),
                ),
                const SizedBox(height: AppSpacing.md),
                _MetalSelector(
                  selected: state.metal,
                  onSelected: (m) => ref
                      .read(electroplatingNotifierProvider.notifier)
                      .setMetal(m),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MassReadout extends StatelessWidget {
  final double mass;
  final double time;

  const _MassReadout({required this.mass, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _DataColumn(
            'DEPOSITED MASS',
            '${mass.toStringAsFixed(2)} mg',
            AppColors.accentElectric,
          ),
          _DataColumn(
            'ELAPSED TIME',
            '${time.toInt()} s',
            AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _DataColumn(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10,
            letterSpacing: 1,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'JetBrains Mono',
          ),
        ),
      ],
    );
  }
}

class _CurrentControl extends StatelessWidget {
  final double amps;
  final bool isPlating;
  final ValueChanged<double> onChanged;
  final ValueChanged<bool> onToggle;

  const _CurrentControl({
    required this.amps,
    required this.isPlating,
    required this.onChanged,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'D.C. CURRENT SOURCE',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    letterSpacing: 1.0,
                  ),
                ),
                Text(
                  '${amps.toStringAsFixed(1)} A',
                  style: TextStyle(
                    color: isPlating
                        ? AppColors.accentElectric
                        : AppColors.textHint,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'JetBrains Mono',
                  ),
                ),
              ],
            ),
            Switch(
              value: isPlating,
              onChanged: onToggle,
              activeThumbColor: AppColors.accentElectric,
            ),
          ],
        ),
        Slider(
          value: amps,
          min: 0,
          max: 10,
          onChanged: onChanged,
          activeColor: AppColors.accentElectric,
        ),
      ],
    );
  }
}

class _ObjectSelector extends StatelessWidget {
  final PlatingObject selected;
  final ValueChanged<PlatingObject> onSelected;

  const _ObjectSelector({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: PlatingObject.values.map((obj) {
        final isSelected = obj == selected;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(obj.name.toUpperCase()),
            selected: isSelected,
            onSelected: (_) => onSelected(obj),
            selectedColor: AppColors.accentPurple,
          ),
        );
      }).toList(),
    );
  }
}

class _MetalSelector extends StatelessWidget {
  final Electrode selected;
  final ValueChanged<Electrode> onSelected;

  const _MetalSelector({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final platingMetals = kElectrodes
        .where((e) => ['Ag', 'Cu', 'Au'].contains(e.symbol))
        .toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: platingMetals.map((m) {
          final isSelected = m.symbol == selected.symbol;
          final color = ElectrodeColors.metalFill[m.symbol] ?? Colors.grey;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              backgroundColor: isSelected
                  ? color.withValues(alpha: 0.3)
                  : AppColors.bgElevated,
              avatar: CircleAvatar(backgroundColor: color, radius: 8),
              label: Text(
                m.name,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
              onPressed: () => onSelected(m),
              side: isSelected ? BorderSide(color: color, width: 1) : null,
            ),
          );
        }).toList(),
      ),
    );
  }
}
