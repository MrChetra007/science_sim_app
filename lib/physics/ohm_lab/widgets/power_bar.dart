import 'package:flutter/material.dart';

class PowerBar extends StatelessWidget {
  final double power;
  final double maxPower = 200.0;

  const PowerBar({super.key, required this.power});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "POWER DISSIPATION",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white54,
                    letterSpacing: 1.1,
                  ),
            ),
            Text(
              "${power.toStringAsFixed(1)} W",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 12,
              decoration: BoxDecoration(
                color: const Color(0xFF080A0D),
                border: Border.all(color: Colors.white10),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 12,
              width: MediaQuery.of(context).size.width * (power / maxPower).clamp(0.0, 1.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00FF88), Color(0xFFF5A623), Color(0xFFFF4455)],
                ),
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.4),
                    blurRadius: 6,
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
