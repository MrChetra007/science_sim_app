import 'package:flutter/material.dart';

class ReadoutCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;

  const ReadoutCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF080A0D),
          border: Border.all(color: color.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 1,
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white54,
                    letterSpacing: 1.0,
                    fontSize: 10,
                  ),
            ),
            const SizedBox(height: 4),
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 400),
              tween: Tween(begin: 0, end: double.tryParse(value) ?? 0),
              curve: Curves.easeOutCubic,
              builder: (context, val, child) {
                String displayValue;
                if (label == "CURRENT") {
                  displayValue = val.toStringAsFixed(3);
                } else {
                  displayValue = val.toStringAsFixed(1);
                }
                return FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    displayValue,
                    style: TextStyle(
                      color: color,
                      fontFamily: 'ShareTechMono',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 4),
            Text(
              unit,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white38,
                    fontSize: 9,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReadoutPanel extends StatelessWidget {
  final double voltage;
  final double resistance;
  final double current;

  const ReadoutPanel({
    super.key,
    required this.voltage,
    required this.resistance,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ReadoutCard(
          label: "VOLTAGE",
          value: voltage.toStringAsFixed(1),
          unit: "V",
          color: const Color(0xFFF5A623),
        ),
        const SizedBox(width: 8),
        ReadoutCard(
          label: "RESISTANCE",
          value: resistance.toStringAsFixed(1),
          unit: "Ω",
          color: const Color(0xFF00FF88),
        ),
        const SizedBox(width: 8),
        ReadoutCard(
          label: "CURRENT",
          value: current.toStringAsFixed(3),
          unit: "A",
          color: const Color(0xFF00CFFF),
        ),
      ],
    );
  }
}
