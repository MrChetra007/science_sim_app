import 'package:flutter/material.dart';

class AppColors {
  // ── Backgrounds ──────────────────────────────────
  static const Color bgDeep     = Color(0xFF08090E);  // deepest canvas
  static const Color bgSurface  = Color(0xFF11141C);  // card surface
  static const Color bgElevated = Color(0xFF1A1E2A);  // elevated panel
  static const Color bgHighlight= Color(0xFF232838);  // hover / selected

  // ── Text ─────────────────────────────────────────
  static const Color textPrimary   = Color(0xFFE8ECF4);
  static const Color textSecondary = Color(0xFF8892A4);
  static const Color textHint      = Color(0xFF4A5263);

  // ── Borders ──────────────────────────────────────
  static const Color borderDefault = Color(0xFF252B38);
  static const Color borderAccent  = Color(0xFF3D4560);

  // ── Orbital colors ───────────────────────────────
  static const Color orbitalS = Color(0xFF5B8FFF);  // s orbital — blue
  static const Color orbitalP = Color(0xFF9B6EFF);  // p orbital — purple
  static const Color orbitalD = Color(0xFF3ECFA8);  // d orbital — teal

  // ── Element category colors ───────────────────────
  static const Color catAlkali       = Color(0xFFFF6B6B);
  static const Color catAlkalineEarth= Color(0xFFFFB347);
  static const Color catTransition   = Color(0xFFFFD700);
  static const Color catMetalloid    = Color(0xFF7EC8A0);
  static const Color catNonmetal     = Color(0xFF5B8FFF);
  static const Color catHalogen      = Color(0xFFFF69B4);
  static const Color catNobleGas     = Color(0xFF9B6EFF);

  // ── Shell / energy level colors ───────────────────
  static const List<Color> shellColors = [
    Color(0xFF5B8FFF),  // K shell (n=1) — blue
    Color(0xFF3ECFA8),  // L shell (n=2) — teal
    Color(0xFF9B6EFF),  // M shell (n=3) — purple
    Color(0xFFFF9F43),  // N shell (n=4) — orange
    Color(0xFFFF6B6B),  // O shell (n=5) — red
  ];
}

class AppSpacing {
  static const double xs  = 4.0;
  static const double sm  = 8.0;
  static const double md  = 16.0;
  static const double lg  = 24.0;
  static const double xl  = 36.0;
  static const double xxl = 52.0;
}

class AppRadius {
  static const double sm   = 8.0;
  static const double md   = 12.0;
  static const double lg   = 16.0;
  static const double xl   = 24.0;
  static const double pill = 999.0;
}
