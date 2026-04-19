import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ac_provider.dart';

class ControlPanel extends StatelessWidget {
  const ControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ACProvider>();
    final state = provider.state;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        border: Border.all(color: const Color(0xFF1C2638)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildSlider(
            label: 'Peak Voltage (Vp)',
            value: state.vp,
            min: 10,
            max: 340,
            onChanged: (v) => provider.setVp(v),
            color: Colors.amber,
          ),
          _buildSlider(
            label: 'Frequency (Hz)',
            value: state.frequency,
            min: 1,
            max: 100,
            onChanged: (v) => provider.setFrequency(v),
            color: Colors.green,
          ),
          _buildSlider(
            label: 'Resistance (Ω)',
            value: state.resistance,
            min: 10,
            max: 500,
            onChanged: (v) => provider.setResistance(v),
            color: Colors.cyan,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => provider.togglePlay(),
                icon: Icon(provider.isRunning ? Icons.pause : Icons.play_arrow),
                label: Text(provider.isRunning ? 'PAUSE' : 'PLAY'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.withOpacity(0.1),
                  foregroundColor: Colors.amber,
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () => provider.reset(),
                icon: const Icon(Icons.replay),
                label: const Text('RESET'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.cyan),
              ),
            ],
          ),
          const Divider(color: Colors.white10),
          SwitchListTile(
            title: const Text('Mains Hum (Haptic)', style: TextStyle(color: Colors.white70, fontSize: 12)),
            value: provider.humEnabled,
            onChanged: (v) => provider.toggleHum(),
            activeThumbColor: Colors.amber,
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: color, fontSize: 12)),
            Text(value.toStringAsFixed(0), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: color,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
