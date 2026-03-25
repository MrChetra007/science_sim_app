import 'package:flutter/material.dart';

class AppColors {
  // Background & Surface
  static const Color background = Color(0xFF0D0D1A);
  static const Color surface = Color(0xFF14142B);
  
  // Accents
  static const Color primaryAccent = Color(0xFF00F5D4); // Neon cyan
  static const Color secondaryAccent = Color(0xFFF72585); // Hot pink
  static const Color warning = Color(0xFFFFB703); // Amber for mass
  
  // Text
  static const Color textPrimary = Color(0xFFE0E0FF);
  static const Color textSecondary = Color(0xFF7B7B9E);
  
  // Decorative
  static const Color gridLines = Color(0xFF1E1E3A);
}

class AppConstants {
  static const double cardRadius = 16.0;
  static const double infoPanelOpacity = 0.7;
}

class PhysicsConstants {
  // Typical physics constants can go here later, e.g. gravity
  static const double g = 9.81;
}
