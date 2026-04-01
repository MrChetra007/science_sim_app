import 'package:flutter/material.dart';

class PHColors {
  static const List<Color> phGradient = [
    Color(0xFFBF0000),  // pH 0  — deep red (battery acid)
    Color(0xFFE03030),  // pH 1  — strong red
    Color(0xFFE05520),  // pH 2  — red-orange (lemon)
    Color(0xFFDD8020),  // pH 3  — orange
    Color(0xFFD4B020),  // pH 4  — yellow-orange
    Color(0xFFB0C030),  // pH 5  — yellow-green
    Color(0xFF60B060),  // pH 6  — light green
    Color(0xFF209090),  // pH 7  — teal (neutral)
    Color(0xFF2070CC),  // pH 8  — sky blue (baking soda)
    Color(0xFF1555AA),  // pH 9  — medium blue
    Color(0xFF0F4090),  // pH 10 — deep blue
    Color(0xFF092D78),  // pH 11 — navy
    Color(0xFF071D60),  // pH 12 — dark navy
    Color(0xFF040F48),  // pH 13 — very dark blue
    Color(0xFF020830),  // pH 14 — near black-blue (bleach)
  ];

  static Color forPH(double ph) {
    if (ph < 0) return phGradient.first;
    if (ph >= 14) return phGradient.last;
    
    final index = ph.floor();
    final t = ph - index;
    
    if (index >= phGradient.length - 1) return phGradient.last;
    
    return Color.lerp(phGradient[index], phGradient[index + 1], t)!;
  }
}
