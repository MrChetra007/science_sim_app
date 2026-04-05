class PhaseSubstance {
  final String name;
  final double meltingPoint;  // °C
  final double boilingPoint;  // °C
  final double latentHeatFusion; // J/g (Approx)
  final double latentHeatVaporization; // J/g (Approx)
  final double specificHeatSolid; // J/g·°C
  final double specificHeatLiquid; // J/g·°C
  final double specificHeatGas; // J/g·°C
  final String emoji;
  final String realWorldNote;

  const PhaseSubstance({
    required this.name,
    required this.meltingPoint,
    required this.boilingPoint,
    required this.latentHeatFusion,
    required this.latentHeatVaporization,
    required this.specificHeatSolid,
    required this.specificHeatLiquid,
    required this.specificHeatGas,
    required this.emoji,
    required this.realWorldNote,
  });
}

const List<PhaseSubstance> kPhaseSubstances = [
  PhaseSubstance(
    name: 'Water',
    meltingPoint: 0.0,
    boilingPoint: 100.0,
    latentHeatFusion: 334.0,
    latentHeatVaporization: 2260.0,
    specificHeatSolid: 2.1,
    specificHeatLiquid: 4.18,
    specificHeatGas: 2.0,
    emoji: '💧',
    realWorldNote: 'Most important substance on Earth. Life depends on its unique phase behavior.',
  ),
  PhaseSubstance(
    name: 'Ethanol',
    meltingPoint: -114.1,
    boilingPoint: 78.4,
    latentHeatFusion: 109.0,
    latentHeatVaporization: 841.0,
    specificHeatSolid: 1.5,
    specificHeatLiquid: 2.44,
    specificHeatGas: 1.7,
    emoji: '🍶',
    realWorldNote: 'Used as fuel and in thermometers because it stays liquid across a wide range.',
  ),
  PhaseSubstance(
    name: 'Mercury',
    meltingPoint: -38.8,
    boilingPoint: 356.7,
    latentHeatFusion: 11.4,
    latentHeatVaporization: 294.0,
    specificHeatSolid: 0.14,
    specificHeatLiquid: 0.14,
    specificHeatGas: 0.10,
    emoji: '🌡️',
    realWorldNote: 'Only metal liquid at room temperature. Historically used in thermometers.',
  ),
  PhaseSubstance(
    name: 'Nitrogen',
    meltingPoint: -210.0,
    boilingPoint: -195.8,
    latentHeatFusion: 25.7,
    latentHeatVaporization: 199.0,
    specificHeatSolid: 1.0,
    specificHeatLiquid: 2.0,
    specificHeatGas: 1.04,
    emoji: '🫧',
    realWorldNote: 'Liquid nitrogen is used to freeze biological samples and food.',
  ),
];
