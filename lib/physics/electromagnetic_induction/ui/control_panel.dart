import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sim_provider.dart';

class ControlPanel extends ConsumerWidget {
  const ControlPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(simProvider);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      color: const Color(0xFF1E1E1E),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SliderRow(
            label: 'Speed',
            value: state.speed,
            min: 0.2,
            max: 3.0,
            display: '${state.speed.toStringAsFixed(1)}x',
            onChanged: (v) => ref.read(simProvider.notifier).setSpeed(v),
          ),
          _SliderRow(
            label: 'Field',
            value: state.fieldStrength,
            min: 0.5,
            max: 3.0,
            display: '${state.fieldStrength.toStringAsFixed(1)}x',
            onChanged: (v) =>
                ref.read(simProvider.notifier).setFieldStrength(v),
          ),
          _SliderRow(
            label: 'Turns',
            value: state.turns.toDouble(),
            min: 2,
            max: 20,
            divisions: 18,
            display: '${state.turns}',
            onChanged: (v) =>
                ref.read(simProvider.notifier).setTurns(v.round()),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _RoundButton(
                icon: state.isRunning ? Icons.pause : Icons.play_arrow,
                onPressed: () =>
                    ref.read(simProvider.notifier).togglePause(),
              ),
              const SizedBox(width: 24),
              _RoundButton(
                icon: Icons.replay,
                onPressed: () => ref.read(simProvider.notifier).reset(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final String display;
  final ValueChanged<double> onChanged;

  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    required this.display,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 48,
          child: Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
        ),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
            activeColor: const Color(0xFFD2691E),
            inactiveColor: Colors.grey[700],
          ),
        ),
        SizedBox(
          width: 36,
          child: Text(
            display,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _RoundButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        color: Colors.white,
        iconSize: 28,
        style: IconButton.styleFrom(
          backgroundColor: const Color(0xFF333333),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
      ),
    );
  }
}
