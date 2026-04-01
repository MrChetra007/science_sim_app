import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ac_provider.dart';

class FactCards extends StatelessWidget {
  const FactCards({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ACProvider>();
    final s = provider.state;

    return Row(
      children: [
        _buildFactCard(
          title: 'RMS Voltage',
          value: '${s.valVrms.toStringAsFixed(1)} V',
          formula: 'Vp / √2',
          color: Colors.amber,
          icon: Icons.bolt,
        ),
        const SizedBox(width: 8),
        _buildFactCard(
          title: 'Avg Power',
          value: '${s.avgPower.toStringAsFixed(1)} W',
          formula: 'Vrms * Irms',
          color: Colors.redAccent,
          icon: Icons.fireplace_rounded,
        ),
      ],
    );
  }

  Widget _buildFactCard({
    required String title,
    required String value,
    required String formula,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF161B22),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 16),
                const SizedBox(width: 4),
                Text(title, style: TextStyle(color: color.withOpacity(0.7), fontSize: 10)),
              ],
            ),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(formula, style: TextStyle(color: Colors.white24, fontSize: 9, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}
