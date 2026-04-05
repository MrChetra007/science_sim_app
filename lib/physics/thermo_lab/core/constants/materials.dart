class ThermalMaterial {
  final String name;
  final double conductivity; // W/m·K
  final String emoji;
  final String realWorldUse;

  const ThermalMaterial({
    required this.name,
    required this.conductivity,
    required this.emoji,
    required this.realWorldUse,
  });
}

const List<ThermalMaterial> kMaterials = [
  ThermalMaterial(name: 'Copper',    conductivity: 401.0, emoji: '🟤', realWorldUse: 'Electrical wiring, heat sinks'),
  ThermalMaterial(name: 'Aluminium', conductivity: 237.0, emoji: '⬜', realWorldUse: 'Cooking pans, aircraft frames'),
  ThermalMaterial(name: 'Iron',      conductivity: 80.0,  emoji: '🔩', realWorldUse: 'Building structures, engines'),
  ThermalMaterial(name: 'Glass',     conductivity: 1.0,   emoji: '🪟', realWorldUse: 'Windows, insulation'),
  ThermalMaterial(name: 'Wood',      conductivity: 0.12,  emoji: '🪵', realWorldUse: 'Furniture, door handles'),
  ThermalMaterial(name: 'Air',       conductivity: 0.025, emoji: '💨', realWorldUse: 'Thermal insulation in walls'),
];
