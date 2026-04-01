import 'package:flutter/material.dart';

class ElectrodeColors {
  static const Map<String, Color> metalFill = {
    'Zn': Color(0xFF6B7F96),   // blue-gray
    'Fe': Color(0xFF888780),   // iron gray
    'Ni': Color(0xFF7F9AAA),   // steel blue
    'Pb': Color(0xFF9A9A95),   // lead gray
    'Cu': Color(0xFFC97C3A),   // copper orange
    'Ag': Color(0xFFAAA9A0),   // silver
    'Au': Color(0xFFD4A01A),   // gold
    'Pt': Color(0xFFCCCCCC),   // platinum white
  };

  static const Map<String, Color> solutionColor = {
    'ZnSO4':  Color(0xFF3B5A7A),
    'FeSO4':  Color(0xFF4A6040),
    'NiSO4':  Color(0xFF2E7A4A),
    'CuSO4':  Color(0xFF1A6FA0),
    'AgNO3':  Color(0xFF5A5A70),
    'AuCl3':  Color(0xFF806020),
  };
}
