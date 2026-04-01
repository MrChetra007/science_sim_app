import 'package:flutter/material.dart';

class Indicator {
  final String name;
  final Color acidColor;
  final Color neutralColor;
  final Color baseColor;
  final double transitionLow;   // pH where it starts changing
  final double transitionHigh;

  const Indicator({
    required this.name,
    required this.acidColor,
    required this.baseColor,
    required this.neutralColor,
    required this.transitionLow,
    required this.transitionHigh,
  });
}

const List<Indicator> kIndicators = [
  Indicator(
    name: 'Litmus',
    acidColor:    Color(0xFFE04040),  // red
    neutralColor: Color(0xFFAA50DD),  // purple
    baseColor:    Color(0xFF4060EE),  // blue
    transitionLow: 5.0, transitionHigh: 8.0,
  ),
  Indicator(
    name: 'Phenolphthalein',
    acidColor:    Color(0xFFF0F0F0),  // colorless
    neutralColor: Color(0xFFF0F0F0),  // colorless
    baseColor:    Color(0xFFE040A0),  // pink-magenta
    transitionLow: 8.2, transitionHigh: 10.0,
  ),
  Indicator(
    name: 'Methyl orange',
    acidColor:    Color(0xFFE88030),  // orange-red
    neutralColor: Color(0xFFDDCC40),  // yellow
    baseColor:    Color(0xFF40BB70),  // green
    transitionLow: 3.1, transitionHigh: 4.4,
  ),
];
