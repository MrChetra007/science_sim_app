import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static final TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.spaceGrotesk(fontSize: 32, fontWeight: FontWeight.w700),
    titleLarge:   GoogleFonts.spaceGrotesk(fontSize: 22, fontWeight: FontWeight.w600),
    titleMedium:  GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.w500),
    bodyLarge:    GoogleFonts.inter(fontSize: 16, height: 1.6),
    bodyMedium:   GoogleFonts.inter(fontSize: 14, height: 1.5),
    labelSmall:   GoogleFonts.jetBrainsMono(fontSize: 12),  // voltages, formulas
  );
}

class AppSpacing {
  static const double xs  = 4.0;
  static const double sm  = 8.0;
  static const double md  = 16.0;
  static const double lg  = 24.0;
  static const double xl  = 32.0;
  static const double xxl = 48.0;
}

class AppRadius {
  static const double sm   = 8.0;
  static const double md   = 12.0;
  static const double lg   = 16.0;
  static const double xl   = 24.0;
  static const double pill = 999.0;
}
