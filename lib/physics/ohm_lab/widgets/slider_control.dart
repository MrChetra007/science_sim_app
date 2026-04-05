import 'package:flutter/material.dart';

class SliderControl extends StatelessWidget {
  final String label;
  final String unit;
  final double min;
  final double max;
  final Color color;
  final double value;
  final ValueChanged<double> onChanged;
  final GlobalKey? walkthroughKey;

  const SliderControl({
    super.key,
    required this.label,
    required this.unit,
    required this.min,
    required this.max,
    required this.color,
    required this.value,
    required this.onChanged,
    this.walkthroughKey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: walkthroughKey,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$label  ($unit)",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              "${value.toStringAsFixed(1)} $unit",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            inactiveTrackColor: color.withOpacity(0.2),
            thumbColor: color,
            overlayColor: color.withOpacity(0.2),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
