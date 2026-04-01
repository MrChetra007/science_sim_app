import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ac_provider.dart';

class InfoChipRow extends StatelessWidget {
  const InfoChipRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ACProvider>(
      builder: (context, provider, _) {
        final s = provider.state;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _buildChip('V = ${s.vt.toStringAsFixed(1)} V', Colors.amber),
              const SizedBox(width: 8),
              _buildChip('I = ${s.it.toStringAsFixed(2)} A', Colors.cyan),
              const SizedBox(width: 8),
              _buildChip('φ = ${s.phaseDeg.toStringAsFixed(0)}°', Colors.purpleAccent),
              const SizedBox(width: 8),
              _buildChip('T = ${s.period.toStringAsFixed(1)} ms', Colors.greenAccent),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}
