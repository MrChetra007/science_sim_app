import 'dart:ui';
import 'package:flutter/material.dart' show Colors;

class Electrolyte {
  final String name;
  final String formula;
  final double thresholdVoltage; // V_min
  final String anodeProduct;     // e.g. O2
  final String cathodeProduct;   // e.g. H2
  final Color anodeGasColor;
  final Color cathodeGasColor;
  final Color solutionColor;

  const Electrolyte({
    required this.name,
    required this.formula,
    required this.thresholdVoltage,
    required this.anodeProduct,
    required this.cathodeProduct,
    required this.anodeGasColor,
    required this.cathodeGasColor,
    required this.solutionColor,
  });
}

const List<Electrolyte> kElectrolytes = [
  Electrolyte(
    name: 'Aqueous Sodium Chloride',
    formula: 'NaCl (aq)',
    thresholdVoltage: 2.19,
    anodeProduct: 'Cl₂',
    cathodeProduct: 'H₂',
    anodeGasColor: Color(0xFFD4FF80), // Pale Green
    cathodeGasColor: Color(0xFFE0F7FA), // Light Blue/Clear
    solutionColor: Color(0xFF1A3A5A),
  ),
  Electrolyte(
    name: 'Copper (II) Sulfate',
    formula: 'CuSO₄ (aq)',
    thresholdVoltage: 1.23,
    anodeProduct: 'O₂',
    cathodeProduct: 'Cu',
    anodeGasColor: Colors.white,
    cathodeGasColor: Colors.transparent, // Solid deposition, no gas
    solutionColor: Color(0xFF1A6FA0),
  ),
  Electrolyte(
    name: 'Water (Dilute H₂SO₄)',
    formula: 'H₂O',
    thresholdVoltage: 1.23,
    anodeProduct: 'O₂',
    cathodeProduct: 'H₂',
    anodeGasColor: Colors.white,
    cathodeGasColor: Color(0xFFE0F7FA),
    solutionColor: Color(0xFF2C3E50),
  ),
];
