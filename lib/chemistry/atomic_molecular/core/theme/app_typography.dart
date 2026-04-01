import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  static TextTheme get textTheme => TextTheme(
    displayLarge: GoogleFonts.outfit(
      fontSize: 34, fontWeight: FontWeight.w700,
      color: AppColors.textPrimary),
    titleLarge: GoogleFonts.outfit(
      fontSize: 22, fontWeight: FontWeight.w600,
      color: AppColors.textPrimary),
    titleMedium: GoogleFonts.outfit(
      fontSize: 17, fontWeight: FontWeight.w500,
      color: AppColors.textPrimary),
    bodyLarge: GoogleFonts.inter(
      fontSize: 15, height: 1.65,
      color: AppColors.textPrimary),
    bodyMedium: GoogleFonts.inter(
      fontSize: 13, height: 1.55,
      color: AppColors.textSecondary),
    labelSmall: GoogleFonts.jetBrainsMono(
      fontSize: 12,
      color: AppColors.textHint),       // for numbers, formulas, configs
  );
}
