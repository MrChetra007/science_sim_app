import 'package:flutter/material.dart';

class VoltageColors {
  static Color forVoltage(double volts) {
    if (volts >= 1.5) return const Color(0xFF2ECC71);   // strong green
    if (volts >= 0.8) return const Color(0xFF4FAAFF);   // blue
    if (volts >= 0.3) return const Color(0xFFF0A030);   // amber
    if (volts > 0.0)  return const Color(0xFFE85D30);   // weak red-orange
    return const Color(0xFF888780);                      // gray = non-spontaneous
  }
}
