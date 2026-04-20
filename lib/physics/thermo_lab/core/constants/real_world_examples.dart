import 'package:flutter/material.dart';
import '../../../../l10n/generated/app_localizations.dart';

class RealWorldExample {
  final String module;
  final String titleKey;
  final String descKey;
  final String emoji;

  const RealWorldExample({
    required this.module,
    required this.titleKey,
    required this.descKey,
    required this.emoji,
  });

  String title(BuildContext context) {
    switch (titleKey) {
      case 'cookingPan': return AppLocalizations.of(context)!.cookingPan;
      case 'oceanCurrents': return AppLocalizations.of(context)!.oceanCurrents;
      case 'solarRadiation': return AppLocalizations.of(context)!.solarRadiation;
      case 'bicyclePump': return AppLocalizations.of(context)!.bicyclePump;
      case 'hotAirBalloon': return AppLocalizations.of(context)!.hotAirBalloon;
      case 'pressureCooker': return AppLocalizations.of(context)!.pressureCooker;
      case 'carEngine': return AppLocalizations.of(context)!.carEngine;
      case 'refrigerator': return AppLocalizations.of(context)!.refrigerator;
      case 'powerPlant': return AppLocalizations.of(context)!.powerPlant;
      case 'sweating': return AppLocalizations.of(context)!.sweating;
      case 'icePacks': return AppLocalizations.of(context)!.icePacks;
      case 'cloudsForming': return AppLocalizations.of(context)!.cloudsForming;
      case 'iceMelting': return AppLocalizations.of(context)!.iceMelting;
      case 'perfumeSpreading': return AppLocalizations.of(context)!.perfumeSpreading;
      case 'rustingDecay': return AppLocalizations.of(context)!.rustingDecay;
      default: return titleKey;
    }
  }

  String description(BuildContext context) {
    switch (descKey) {
      case 'cookingPanDesc': return AppLocalizations.of(context)!.cookingPanDesc;
      case 'oceanCurrentsDesc': return AppLocalizations.of(context)!.oceanCurrentsDesc;
      case 'solarRadiationDesc': return AppLocalizations.of(context)!.solarRadiationDesc;
      case 'bicyclePumpDesc': return AppLocalizations.of(context)!.bicyclePumpDesc;
      case 'hotAirBalloonDesc': return AppLocalizations.of(context)!.hotAirBalloonDesc;
      case 'pressureCookerDesc': return AppLocalizations.of(context)!.pressureCookerDesc;
      case 'carEngineDesc': return AppLocalizations.of(context)!.carEngineDesc;
      case 'refrigeratorDesc': return AppLocalizations.of(context)!.refrigeratorDesc;
      case 'powerPlantDesc': return AppLocalizations.of(context)!.powerPlantDesc;
      case 'sweatingDesc': return AppLocalizations.of(context)!.sweatingDesc;
      case 'icePacksDesc': return AppLocalizations.of(context)!.icePacksDesc;
      case 'cloudsFormingDesc': return AppLocalizations.of(context)!.cloudsFormingDesc;
      case 'iceMeltingDesc': return AppLocalizations.of(context)!.iceMeltingDesc;
      case 'perfumeSpreadingDesc': return AppLocalizations.of(context)!.perfumeSpreadingDesc;
      case 'rustingDecayDesc': return AppLocalizations.of(context)!.rustingDecayDesc;
      default: return descKey;
    }
  }
}

const Map<String, List<RealWorldExample>> kRealWorldExamples = {
  'heat_transfer': [
    RealWorldExample(
      module: 'heat_transfer', emoji: '🍳',
      titleKey: 'cookingPan',
      descKey: 'cookingPanDesc',
    ),
    RealWorldExample(
      module: 'heat_transfer', emoji: '🌊',
      titleKey: 'oceanCurrents',
      descKey: 'oceanCurrentsDesc',
    ),
    RealWorldExample(
      module: 'heat_transfer', emoji: '☀️',
      titleKey: 'solarRadiation',
      descKey: 'solarRadiationDesc',
    ),
  ],
  'gas_laws': [
    RealWorldExample(
      module: 'gas_laws', emoji: '🚴',
      titleKey: 'bicyclePump',
      descKey: 'bicyclePumpDesc',
    ),
    RealWorldExample(
      module: 'gas_laws', emoji: '🎈',
      titleKey: 'hotAirBalloon',
      descKey: 'hotAirBalloonDesc',
    ),
    RealWorldExample(
      module: 'gas_laws', emoji: '🌋',
      titleKey: 'pressureCooker',
      descKey: 'pressureCookerDesc',
    ),
  ],
  'carnot': [
    RealWorldExample(
      module: 'carnot', emoji: '🚗',
      titleKey: 'carEngine',
      descKey: 'carEngineDesc',
    ),
    RealWorldExample(
      module: 'carnot', emoji: '🧊',
      titleKey: 'refrigerator',
      descKey: 'refrigeratorDesc',
    ),
    RealWorldExample(
      module: 'carnot', emoji: '⚡',
      titleKey: 'powerPlant',
      descKey: 'powerPlantDesc',
    ),
  ],
  'phase_change': [
    RealWorldExample(
      module: 'phase_change', emoji: '💦',
      titleKey: 'sweating',
      descKey: 'sweatingDesc',
    ),
    RealWorldExample(
      module: 'phase_change', emoji: '🧊',
      titleKey: 'icePacks',
      descKey: 'icePacksDesc',
    ),
    RealWorldExample(
      module: 'phase_change', emoji: '🌫️',
      titleKey: 'cloudsForming',
      descKey: 'cloudsFormingDesc',
    ),
  ],
  'entropy': [
    RealWorldExample(
      module: 'entropy', emoji: '🧊',
      titleKey: 'iceMelting',
      descKey: 'iceMeltingDesc',
    ),
    RealWorldExample(
      module: 'entropy', emoji: '🌹',
      titleKey: 'perfumeSpreading',
      descKey: 'perfumeSpreadingDesc',
    ),
    RealWorldExample(
      module: 'entropy', emoji: '🏚️',
      titleKey: 'rustingDecay',
      descKey: 'rustingDecayDesc',
    ),
  ],
};
