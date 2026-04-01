import '../../../core/constants/electrodes.dart';

class GalvanicState {
  final Electrode anode;
  final Electrode cathode;
  final double cellPotential;
  final int electronCount;
  final double gibbsFreeEnergy;
  final bool isSpontaneous;
  final String anodeReaction;
  final String cathodeReaction;

  const GalvanicState({
    required this.anode,
    required this.cathode,
    this.cellPotential = 1.10,
    this.electronCount = 2,
    this.gibbsFreeEnergy = -212.3,
    this.isSpontaneous = true,
    this.anodeReaction = 'Zn → Zn²⁺ + 2e⁻',
    this.cathodeReaction = 'Cu²⁺ + 2e⁻ → Cu',
  });

  GalvanicState copyWith({
    Electrode? anode,
    Electrode? cathode,
    double? cellPotential,
    int? electronCount,
    double? gibbsFreeEnergy,
    bool? isSpontaneous,
    String? anodeReaction,
    String? cathodeReaction,
  }) {
    return GalvanicState(
      anode: anode ?? this.anode,
      cathode: cathode ?? this.cathode,
      cellPotential: cellPotential ?? this.cellPotential,
      electronCount: electronCount ?? this.electronCount,
      gibbsFreeEnergy: gibbsFreeEnergy ?? this.gibbsFreeEnergy,
      isSpontaneous: isSpontaneous ?? this.isSpontaneous,
      anodeReaction: anodeReaction ?? this.anodeReaction,
      cathodeReaction: cathodeReaction ?? this.cathodeReaction,
    );
  }
}
