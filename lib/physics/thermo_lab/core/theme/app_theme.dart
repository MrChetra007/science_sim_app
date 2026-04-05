import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

ThemeData buildAppTheme() {
  return ThemeData(
    scaffoldBackgroundColor: AppColors.bgDeep,
    brightness: Brightness.dark,
    textTheme: AppTypography.textTheme,
    colorScheme: const ColorScheme.dark(
      surface: AppColors.bgSurface,
      primary: AppColors.accentHeat,
      secondary: AppColors.accentGas,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bgSurface,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: AppColors.bgSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.borderDefault),
      ),
    ),
  );
}
