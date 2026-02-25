import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/wave_provider.dart';

class ControlPanel extends ConsumerWidget {
  const ControlPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final waveState = ref.watch(waveProvider);
    final waveNotifier = ref.read(waveProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.3)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWaveTypeToggle(waveState, waveNotifier),
          const Divider(color: Colors.white24),
          _buildSlider(
            label: 'Amplitude (A)',
            value: waveState.amplitude,
            min: 0.1,
            max: 5.0,
            onChanged: waveNotifier.setAmplitude,
          ),
          _buildSlider(
            label: 'Frequency (f)',
            value: waveState.frequency,
            min: 0.1,
            max: 20.0,
            onChanged: waveNotifier.setFrequency,
          ),
          _buildSlider(
            label: 'Wave Speed (v)',
            value: waveState.waveSpeed,
            min: 100,
            max: 1500,
            onChanged: waveNotifier.setWaveSpeed,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              IconButton(
                onPressed: waveNotifier.togglePause,
                icon: Icon(
                  waveState.isPaused ? Icons.play_arrow : Icons.pause,
                  color: const Color(0xFF00E5FF),
                ),
              ),
              IconButton(
                onPressed: waveNotifier.resetTime,
                icon: const Icon(Icons.refresh, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWaveTypeToggle(WaveState state, WaveNotifier notifier) {
    return Row(
      children: [
        const Text('Type:', style: TextStyle(color: Colors.white70)),
        const SizedBox(width: 10),
        ChoiceChip(
          label: const Text('Transverse'),
          selected: state.waveType == WaveType.transverse,
          onSelected: (_) => notifier.setWaveType(WaveType.transverse),
          selectedColor: const Color(0xFF00E5FF),
          labelStyle: TextStyle(
            color: state.waveType == WaveType.transverse
                ? Colors.black
                : Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        ChoiceChip(
          label: const Text('Longitudinal'),
          selected: state.waveType == WaveType.longitudinal,
          onSelected: (_) => notifier.setWaveType(WaveType.longitudinal),
          selectedColor: const Color(0xFF00E5FF),
          labelStyle: TextStyle(
            color: state.waveType == WaveType.longitudinal
                ? Colors.black
                : Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              value.toStringAsFixed(2),
              style: const TextStyle(
                color: Color(0xFF00E5FF),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
          activeColor: const Color(0xFF00E5FF),
          inactiveColor: Colors.white10,
        ),
      ],
    );
  }
}
