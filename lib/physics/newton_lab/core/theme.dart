import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primaryAccent,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryAccent,
        secondary: AppColors.secondaryAccent,
        surface: AppColors.surface,
        error: AppColors.warning,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppConstants.cardRadius)),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.spaceGrotesk(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.spaceGrotesk(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: GoogleFonts.spaceGrotesk(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: GoogleFonts.spaceGrotesk(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: GoogleFonts.spaceGrotesk(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.spaceGrotesk(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: GoogleFonts.spaceGrotesk(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: GoogleFonts.spaceGrotesk(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.inter(color: AppColors.textPrimary),
        bodyMedium: GoogleFonts.inter(color: AppColors.textPrimary),
        bodySmall: GoogleFonts.inter(color: AppColors.textSecondary),
        labelLarge: GoogleFonts.inter(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        labelSmall: GoogleFonts.jetBrainsMono(color: AppColors.textSecondary),
      ),
    );
  }
}
