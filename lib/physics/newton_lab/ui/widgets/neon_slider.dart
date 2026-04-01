import 'package:flutter/material.dart';
import '../../core/constants.dart';

class NeonSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final String label;

  const NeonSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primaryAccent,
            inactiveTrackColor: AppColors.gridLines,
            thumbColor: AppColors.primaryAccent,
            overlayColor: AppColors.primaryAccent.withOpacity(0.2),
            trackHeight: 4.0,
          ),
          child: Slider(value: value, min: min, max: max, onChanged: onChanged),
        ),
      ],
    );
  }
}
