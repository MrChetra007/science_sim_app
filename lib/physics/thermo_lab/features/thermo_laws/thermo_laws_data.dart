class ThermoLaw {
  final String number;      // "0th", "1st", "2nd", "3rd"
  final String name;
  final String statement;
  final String formula;
  final String explanation;
  final String realWorld;
  final String emoji;

  const ThermoLaw({
    required this.number,
    required this.name,
    required this.statement,
    required this.formula,
    required this.explanation,
    required this.realWorld,
    required this.emoji,
  });
}

const List<ThermoLaw> kThermoLaws = [
  ThermoLaw(
    number: '0th',
    emoji: '🤝',
    name: 'Thermal Equilibrium',
    statement: 'If A is in thermal equilibrium with B, and B with C, then A is in thermal equilibrium with C.',
    formula: 'T_A = T_B = T_C',
    explanation: 'This is the basis of temperature measurement. Objects in contact eventually reach the same temperature.',
    realWorld: 'A thermometer works because it reaches thermal equilibrium with your body — then reads that shared temperature.',
  ),
  ThermoLaw(
    number: '1st',
    emoji: '⚖️',
    name: 'Conservation of Energy',
    statement: 'Energy cannot be created or destroyed — only converted from one form to another.',
    formula: 'ΔU = Q - W',
    explanation: 'The internal energy (ΔU) of a system changes by heat added (Q) minus work done by the system (W).',
    realWorld: 'A car engine converts fuel\'s chemical energy → heat → mechanical work. Total energy is conserved.',
  ),
  ThermoLaw(
    number: '2nd',
    emoji: '🌀',
    name: 'Entropy Always Increases',
    statement: 'The total entropy of an isolated system always increases over time.',
    formula: 'ΔS_universe ≥ 0',
    explanation: 'Natural processes go from order to disorder. You can\'t build a perfect engine — some energy is always wasted as heat.',
    realWorld: 'Your room gets messy by itself. Cleaning it (reversing disorder) requires energy input — you can\'t get that for free.',
  ),
  ThermoLaw(
    number: '3rd',
    emoji: '🧊',
    name: 'Absolute Zero',
    statement: 'The entropy of a perfect crystal at absolute zero (0 K = -273.15°C) is exactly zero.',
    formula: 'S → 0 as T → 0 K',
    explanation: 'At absolute zero, all motion stops and perfect order exists. You can never actually reach absolute zero.',
    realWorld: 'Scientists cool atoms to within billionths of a degree of absolute zero — but can never fully reach it.',
  ),
];
