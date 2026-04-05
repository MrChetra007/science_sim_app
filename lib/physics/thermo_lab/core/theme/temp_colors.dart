import 'dart:ui';
import 'package:flutter/material.dart';

class TempColors {
  // Maps temperature (0°C to 500°C) to a color
  static const List<Color> tempGradient = [
    Color(0xFF4FC3F7),  // 0°C   — ice blue (freezing)
    Color(0xFF81D4FA),  // 50°C  — light blue
    Color(0xFFB2EBF2),  // 100°C — pale cyan (boiling)
    Color(0xFFFFF9C4),  // 150°C — pale yellow
    Color(0xFFFFCC80),  // 200°C — warm orange
    Color(0xFFFF8A65),  // 300°C — orange-red
    Color(0xFFE53935),  // 400°C — red
    Color(0xFFB71C1C),  // 500°C — deep red (scorching)
  ];

  static Color forTemp(double tempC) {
    final clamped = tempC.clamp(0.0, 499.9);
    final index = (clamped / 500 * (tempGradient.length - 1)).floor();
    final t = (clamped / 500 * (tempGradient.length - 1)) - index;
    if (index >= tempGradient.length - 1) return tempGradient.last;
    return Color.lerp(tempGradient[index], tempGradient[index + 1], t)!;
  }
}
