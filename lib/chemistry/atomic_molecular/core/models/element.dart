class ChemElement {
  final int atomicNumber;
  final String symbol;
  final String name;
  final double atomicMass;
  final String category;
  final List<int> shells; // electrons per shell e.g. [2, 8, 6]
  final String configuration; // e.g. "1s² 2s² 2p⁴"
  final int valenceElectrons;
  final String period;
  final String group;
  final String funFact;

  const ChemElement({
    required this.atomicNumber,
    required this.symbol,
    required this.name,
    required this.atomicMass,
    required this.category,
    required this.shells,
    required this.configuration,
    required this.valenceElectrons,
    required this.period,
    required this.group,
    required this.funFact,
  });
}
