import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  static ThemeData buildAppTheme() => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bgDeep,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.orbitalS,
          secondary: AppColors.orbitalP,
          tertiary: AppColors.orbitalD,
          surface: AppColors.bgSurface,
          onSurface: AppColors.textPrimary,
        ),
        textTheme: AppTypography.textTheme,
        cardTheme: CardThemeData(
          color: AppColors.bgSurface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.borderDefault, width: 0.5),
          ),
        ),
        sliderTheme: SliderThemeData(
          trackHeight: 4,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
          activeTrackColor: AppColors.orbitalS,
          inactiveTrackColor: AppColors.bgElevated,
          thumbColor: AppColors.orbitalS,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.bgDeep,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      );
}
