import 'package:flutter/material.dart';

class AppColors {
  static const Color bg = Color(0xFF0B0F19);
  static const Color surface = Color(0xFF131B2E);
  static const Color card = Color(0xFF1C2640);
  static const Color hover = Color(0xFF263353);
  static const Color text = Color(0xFFF1F5F9);
  static const Color dim = Color(0xFF94A3B8);
  static const Color accent = Color(0xFF38BDF8);
  static const Color danger = Color(0xFFF87171);
  static const Color success = Color(0xFF4ADE80);
  static const Color warning = Color(0xFFFBBF24);
  static const Color border = Color(0xFF2E3D60);
  static const Color canvasBg = Color(0xFF090D16);
}

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.accent,
    brightness: Brightness.dark,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.bg,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.text,
      elevation: 0,
      centerTitle: false,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.accent,
      thumbColor: AppColors.accent,
      inactiveTrackColor: AppColors.border,
      overlayColor: AppColors.accent.withValues(alpha: 0.15),
      valueIndicatorColor: AppColors.surface,
      valueIndicatorTextStyle:
          const TextStyle(color: AppColors.text, fontSize: 11),
    ),
    dropdownMenuTheme: const DropdownMenuThemeData(
      textStyle: TextStyle(color: AppColors.text, fontSize: 13),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(AppColors.surface),
      ),
    ),
  );
}