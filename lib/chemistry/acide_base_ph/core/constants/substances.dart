class Substance {
  final String name;
  final double ph;
  final String emoji;
  final String description;

  const Substance({
    required this.name,
    required this.ph,
    required this.emoji,
    required this.description,
  });
}

const List<Substance> kSubstances = [
  Substance(name: 'Battery acid',  ph: 0.5,  emoji: '🔋', description: 'Extremely corrosive. pH near 0.'),
  Substance(name: 'Lemon juice',   ph: 2.2,  emoji: '🍋', description: 'Citric acid gives lemons their sour taste.'),
  Substance(name: 'Vinegar',       ph: 2.9,  emoji: '🫙', description: 'Acetic acid solution used in cooking.'),
  Substance(name: 'Coffee',        ph: 5.0,  emoji: '☕', description: 'Mildly acidic — hence the bitter taste.'),
  Substance(name: 'Rain water',    ph: 5.6,  emoji: '🌧️', description: 'Slightly acidic due to dissolved CO₂.'),
  Substance(name: 'Pure water',    ph: 7.0,  emoji: '💧', description: 'Perfectly neutral at 25°C.'),
  Substance(name: 'Blood',         ph: 7.4,  emoji: '🩸', description: 'Slightly basic — tightly regulated by the body.'),
  Substance(name: 'Baking soda',   ph: 8.3,  emoji: '🧁', description: 'NaHCO₃ solution used in baking.'),
  Substance(name: 'Seawater',      ph: 8.1,  emoji: '🌊', description: 'Slightly basic due to dissolved salts.'),
  Substance(name: 'Bleach',        ph: 12.5, emoji: '🧴', description: 'Strong base — highly corrosive and caustic.'),
  Substance(name: 'Drain cleaner', ph: 13.5, emoji: '🪣', description: 'Sodium hydroxide (NaOH) — very dangerous.'),
];
