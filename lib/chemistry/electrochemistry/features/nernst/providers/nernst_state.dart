class NernstState {
  final double standardPotential; // E°
  final int n;                    // electrons
  final double temperatureK;      // Temperature in Kelvin
  final double concentrationOx;   // [Ox]
  final double concentrationRed;  // [Red]
  final double reactionQuotient;  // Q
  final double actualPotential;   // E

  const NernstState({
    required this.standardPotential,
    required this.n,
    required this.temperatureK,
    required this.concentrationOx,
    required this.concentrationRed,
    this.reactionQuotient = 1.0,
    this.actualPotential = 1.10,
  });

  NernstState copyWith({
    double? standardPotential,
    int? n,
    double? temperatureK,
    double? concentrationOx,
    double? concentrationRed,
    double? reactionQuotient,
    double? actualPotential,
  }) {
    return NernstState(
      standardPotential: standardPotential ?? this.standardPotential,
      n: n ?? this.n,
      temperatureK: temperatureK ?? this.temperatureK,
      concentrationOx: concentrationOx ?? this.concentrationOx,
      concentrationRed: concentrationRed ?? this.concentrationRed,
      reactionQuotient: reactionQuotient ?? this.reactionQuotient,
      actualPotential: actualPotential ?? this.actualPotential,
    );
  }
}
