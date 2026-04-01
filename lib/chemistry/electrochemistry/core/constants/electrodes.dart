class Electrode {
  final String symbol;
  final String name;
  final double reductionPotential; // E° in volts vs SHE
  final int electrons;             // n
  final String ion;
  final double molarMass;          // g/mol
  final String solution;

  const Electrode({
    required this.symbol,
    required this.name,
    required this.reductionPotential,
    required this.electrons,
    required this.ion,
    required this.molarMass,
    required this.solution,
  });
}

const List<Electrode> kElectrodes = [
  Electrode(symbol: 'Zn', name: 'Zinc',      reductionPotential: -0.76, electrons: 2, ion: 'Zn²⁺', molarMass: 65.38,  solution: 'ZnSO₄'),
  Electrode(symbol: 'Fe', name: 'Iron',      reductionPotential: -0.44, electrons: 2, ion: 'Fe²⁺', molarMass: 55.85,  solution: 'FeSO₄'),
  Electrode(symbol: 'Ni', name: 'Nickel',    reductionPotential: -0.25, electrons: 2, ion: 'Ni²⁺', molarMass: 58.69,  solution: 'NiSO₄'),
  Electrode(symbol: 'Pb', name: 'Lead',      reductionPotential: -0.13, electrons: 2, ion: 'Pb²⁺', molarMass: 207.20, solution: 'Pb(NO₃)₂'),
  Electrode(symbol: 'Cu', name: 'Copper',    reductionPotential:  0.34, electrons: 2, ion: 'Cu²⁺', molarMass: 63.55,  solution: 'CuSO₄'),
  Electrode(symbol: 'Ag', name: 'Silver',    reductionPotential:  0.80, electrons: 1, ion: 'Ag⁺',  molarMass: 107.87, solution: 'AgNO₃'),
  Electrode(symbol: 'Au', name: 'Gold',      reductionPotential:  1.50, electrons: 3, ion: 'Au³⁺', molarMass: 196.97, solution: 'AuCl₃'),
  Electrode(symbol: 'Pt', name: 'Platinum',  reductionPotential:  1.20, electrons: 2, ion: 'Pt²⁺', molarMass: 195.08, solution: 'H₂PtCl₆'),
];
