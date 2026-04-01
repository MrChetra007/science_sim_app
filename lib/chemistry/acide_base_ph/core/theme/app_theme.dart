import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppRadius {
  static const double sm  = 8.0;
  static const double md  = 12.0;
  static const double lg  = 16.0;
  static const double xl  = 24.0;
  static const double pill = 999.0;
}

class AppSpacing {
  static const double xs  = 4.0;
  static const double sm  = 8.0;
  static const double md  = 16.0;
  static const double lg  = 24.0;
  static const double xl  = 32.0;
  static const double xxl = 48.0;
}

ThemeData buildAppTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bgDeep,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accentBlue,
      secondary: AppColors.accentGreen,
      surface: AppColors.bgSurface,
    ),
    textTheme: AppTypography.textTheme,
    cardTheme: CardThemeData(
      color: AppColors.bgSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: const BorderSide(color: AppColors.borderDefault, width: 0.5),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.borderDefault,
      thickness: 0.5,
    ),
  );
}
