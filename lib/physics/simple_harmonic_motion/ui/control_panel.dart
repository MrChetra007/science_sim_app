import 'package:flutter/material.dart';
import '../providers/sim_provider.dart';
import '../../../l10n/generated/app_localizations.dart';

class ControlPanel extends StatelessWidget {
  final SimState state;
  final ValueChanged<double> onSpringConstant;
  final ValueChanged<double> onMass;
  final ValueChanged<double> onAmplitude;
  final ValueChanged<double> onPendulumLength;
  final ValueChanged<double> onGravity;
  final ValueChanged<double> onInitialAngle;
  final VoidCallback onModeToggle;
  final VoidCallback onPause;
  final VoidCallback onReset;
  final VoidCallback onToggleVectors;

  const ControlPanel({
    super.key,
    required this.state,
    required this.onSpringConstant,
    required this.onMass,
    required this.onAmplitude,
    required this.onPendulumLength,
    required this.onGravity,
    required this.onInitialAngle,
    required this.onModeToggle,
    required this.onPause,
    required this.onReset,
    required this.onToggleVectors,
  });

  List<MapEntry<String, double>> _planets(AppLocalizations l10n) => [
    MapEntry(l10n.shmPlanetMoon, 1.6),
    MapEntry(l10n.shmPlanetMars, 3.7),
    MapEntry(l10n.shmPlanetEarth, 9.8),
    MapEntry(l10n.shmPlanetJupiter, 24.8),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      color: const Color(0xFF1A1A2E),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _modeButton(context, l10n.shmSpringMode, SimMode.spring),
              const SizedBox(width: 8),
              _modeButton(context, l10n.shmPendulumMode, SimMode.pendulum),
              const Spacer(),
              _iconButton(Icons.pause_rounded, state.isRunning ? l10n.pause : l10n.play, onPause),
              _iconButton(Icons.refresh_rounded, l10n.reset, onReset),
              _iconButton(Icons.arrow_right_alt_rounded, l10n.shmVectors, onToggleVectors),
            ],
          ),
          const SizedBox(height: 8),
          if (state.mode == SimMode.spring) ...[
            _slider(l10n.shmSpringConstant, state.springConstant, 5, 50, 'N/m', onSpringConstant),
            _slider(l10n.shmMassLabel, state.mass, 0.1, 2.0, 'kg', onMass),
            _slider(l10n.shmAmplitudeLabel, state.amplitude, 0.05, 0.30, 'm', onAmplitude),
          ] else ...[
            _slider(l10n.shmLength, state.pendulumLength, 0.2, 2.0, 'm', onPendulumLength),
            _slider(l10n.shmInitialAngle, state.initialAngle, 5, 45, '\u00B0', onInitialAngle),
            Row(
              children: _planets(l10n).map((e) {
                final selected = state.gravity == e.value;
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: ChoiceChip(
                    label: Text('${e.key} ${e.value}', style: const TextStyle(fontSize: 11)),
                    selected: selected,
                    onSelected: (_) => onGravity(e.value),
                    selectedColor: Colors.cyan.withValues(alpha: 0.3),
                    backgroundColor: Colors.grey[900],
                    labelStyle: TextStyle(color: selected ? Colors.cyan : Colors.white70, fontSize: 11),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _modeButton(BuildContext context, String label, SimMode mode) {
    final selected = state.mode == mode;
    return TextButton(
      onPressed: onModeToggle,
      style: TextButton.styleFrom(
        backgroundColor: selected ? Colors.cyan.withValues(alpha: 0.2) : Colors.transparent,
        foregroundColor: selected ? Colors.cyan : Colors.white54,
        side: BorderSide(color: selected ? Colors.cyan : Colors.white24),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _iconButton(IconData icon, String tooltip, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, color: Colors.white70, size: 20),
      onPressed: onTap,
      tooltip: tooltip,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      padding: EdgeInsets.zero,
    );
  }

  Widget _slider(String label, double value, double min, double max, String unit, ValueChanged<double> onChanged) {
    return Row(
      children: [
        SizedBox(
          width: 140,
          child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
            activeColor: Colors.cyan,
            inactiveColor: Colors.white24,
          ),
        ),
        SizedBox(
          width: 60,
          child: Text('${value.toStringAsFixed(2)} $unit', style: const TextStyle(color: Colors.cyan, fontSize: 11)),
        ),
      ],
    );
  }
}
