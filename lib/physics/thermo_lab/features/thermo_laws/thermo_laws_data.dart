import 'package:flutter/material.dart';
import '../../../../l10n/generated/app_localizations.dart';

class ThermoLaw {
  final String number;      // "0th", "1st", "2nd", "3rd"
  final String nameKey;
  final String statementKey;
  final String formula;
  final String explanationKey;
  final String realWorldKey;
  final String emoji;

  const ThermoLaw({
    required this.number,
    required this.nameKey,
    required this.statementKey,
    required this.formula,
    required this.explanationKey,
    required this.realWorldKey,
    required this.emoji,
  });

  String name(BuildContext context) {
    switch (nameKey) {
      case 'thermalEquilibrium': return AppLocalizations.of(context)!.thermalEquilibrium;
      case 'conservationOfEnergy': return AppLocalizations.of(context)!.conservationOfEnergy;
      case 'entropyAlwaysIncreases': return AppLocalizations.of(context)!.entropyAlwaysIncreases;
      case 'absoluteZero': return AppLocalizations.of(context)!.absoluteZero;
      default: return nameKey;
    }
  }

  String statement(BuildContext context) {
    switch (statementKey) {
      case 'zerothLawStatement': return AppLocalizations.of(context)!.zerothLawStatement;
      case 'firstLawStatement': return AppLocalizations.of(context)!.firstLawStatement;
      case 'secondLawStatement': return AppLocalizations.of(context)!.secondLawStatement;
      case 'thirdLawStatement': return AppLocalizations.of(context)!.thirdLawStatement;
      default: return statementKey;
    }
  }

  String explanation(BuildContext context) {
    switch (explanationKey) {
      case 'zerothLawExplanation': return AppLocalizations.of(context)!.zerothLawExplanation;
      case 'firstLawExplanation': return AppLocalizations.of(context)!.firstLawExplanation;
      case 'secondLawExplanation': return AppLocalizations.of(context)!.secondLawExplanation;
      case 'thirdLawExplanation': return AppLocalizations.of(context)!.thirdLawExplanation;
      default: return explanationKey;
    }
  }

  String realWorld(BuildContext context) {
    switch (realWorldKey) {
      case 'zerothLawRealWorld': return AppLocalizations.of(context)!.zerothLawRealWorld;
      case 'firstLawRealWorld': return AppLocalizations.of(context)!.firstLawRealWorld;
      case 'secondLawRealWorld': return AppLocalizations.of(context)!.secondLawRealWorld;
      case 'thirdLawRealWorld': return AppLocalizations.of(context)!.thirdLawRealWorld;
      default: return realWorldKey;
    }
  }
}

const List<ThermoLaw> kThermoLaws = [
  ThermoLaw(
    number: '0th',
    emoji: '🤝',
    nameKey: 'thermalEquilibrium',
    statementKey: 'zerothLawStatement',
    formula: 'T_A = T_B = T_C',
    explanationKey: 'zerothLawExplanation',
    realWorldKey: 'zerothLawRealWorld',
  ),
  ThermoLaw(
    number: '1st',
    emoji: '⚖️',
    nameKey: 'conservationOfEnergy',
    statementKey: 'firstLawStatement',
    formula: 'ΔU = Q - W',
    explanationKey: 'firstLawExplanation',
    realWorldKey: 'firstLawRealWorld',
  ),
  ThermoLaw(
    number: '2nd',
    emoji: '🌀',
    nameKey: 'entropyAlwaysIncreases',
    statementKey: 'secondLawStatement',
    formula: 'ΔS_universe ≥ 0',
    explanationKey: 'secondLawExplanation',
    realWorldKey: 'secondLawRealWorld',
  ),
  ThermoLaw(
    number: '3rd',
    emoji: '🧊',
    nameKey: 'absoluteZero',
    statementKey: 'thirdLawStatement',
    formula: 'S → 0 as T → 0 K',
    explanationKey: 'thirdLawExplanation',
    realWorldKey: 'thirdLawRealWorld',
  ),
];
