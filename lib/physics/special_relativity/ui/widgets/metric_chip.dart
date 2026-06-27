import 'package:flutter/material.dart';

class MetricChip extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const MetricChip({
    super.key,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = color ?? const Color(0xff4fc3f7);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: themeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: themeColor.withOpacity(0.3),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: themeColor,
                fontSize: 11,
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
