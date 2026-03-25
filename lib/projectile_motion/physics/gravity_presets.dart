class GravityPreset {
  final String id;
  final String name;
  final double value; // m/s²
  final String emoji;

  const GravityPreset({
    required this.id,
    required this.name,
    required this.value,
    required this.emoji,
  });
}

const List<GravityPreset> gravityPresets = [
  GravityPreset(id: 'earth', name: 'Earth', value: 9.81, emoji: '🌍'),
  GravityPreset(id: 'moon', name: 'Moon', value: 1.62, emoji: '🌙'),
  GravityPreset(id: 'mars', name: 'Mars', value: 3.72, emoji: '🔴'),
  GravityPreset(id: 'jupiter', name: 'Jupiter', value: 24.79, emoji: '🪐'),
];

GravityPreset gravityById(String id) => gravityPresets
    .firstWhere((p) => p.id == id, orElse: () => gravityPresets.first);
