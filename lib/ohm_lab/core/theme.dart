import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFF0A0C0F);
  static const Color surface    = Color(0xFF0F1318);
  static const Color amber      = Color(0xFFF5A623);   // Voltage
  static const Color green      = Color(0xFF00FF88);   // Resistance
  static const Color blue       = Color(0xFF00CFFF);   // Current
  static const Color red        = Color(0xFFFF4455);   // Danger

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: blue,
        surface: surface,
        onSurface: Colors.white,
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.orbitron(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineMedium: GoogleFonts.orbitron(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.shareTechMono(
          fontSize: 18,
          color: Colors.white70,
        ),
        bodyMedium: GoogleFonts.shareTechMono(
          fontSize: 16,
          color: Colors.white60,
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: blue,
        inactiveTrackColor: blue.withOpacity(0.2),
        thumbColor: blue,
        overlayColor: blue.withOpacity(0.2),
      ),
    );
  }
}
