class RealWorldExample {
  final String module;
  final String title;
  final String description;
  final String emoji;

  const RealWorldExample({
    required this.module,
    required this.title,
    required this.description,
    required this.emoji,
  });
}

const Map<String, List<RealWorldExample>> kRealWorldExamples = {
  'heat_transfer': [
    RealWorldExample(
      module: 'heat_transfer', emoji: '🍳',
      title: 'Cooking pan',
      description: 'Metal pan conducts heat from the stove burner directly to your food.',
    ),
    RealWorldExample(
      module: 'heat_transfer', emoji: 'Waves',
      title: 'Ocean currents',
      description: 'Warm water rises, cold water sinks — global convection that drives climate.',
    ),
    RealWorldExample(
      module: 'heat_transfer', emoji: '☀️',
      title: 'Solar radiation',
      description: 'The Sun heats Earth through radiation — no medium needed across space.',
    ),
  ],
  'gas_laws': [
    RealWorldExample(
      module: 'gas_laws', emoji: '🚴',
      title: 'Bicycle pump',
      description: 'Compressing air (Boyle\'s Law) increases pressure to inflate the tyre.',
    ),
    RealWorldExample(
      module: 'gas_laws', emoji: '🎈',
      title: 'Hot air balloon',
      description: 'Heating air (Charles\'s Law) increases volume, reducing density so it floats.',
    ),
    RealWorldExample(
      module: 'gas_laws', emoji: '🌋',
      title: 'Pressure cooker',
      description: 'Increased temperature at fixed volume (Gay-Lussac\'s Law) leads to higher pressure for faster cooking.',
    ),
  ],
  'carnot': [
    RealWorldExample(
      module: 'carnot', emoji: '🚗',
      title: 'Car engine',
      description: 'Combustion engines are heat engines — fuel burns (hot reservoir), exhaust cools (cold reservoir).',
    ),
    RealWorldExample(
      module: 'carnot', emoji: '🧊',
      title: 'Refrigerator',
      description: 'A heat pump running in reverse — moves heat from cold (inside) to hot (room).',
    ),
    RealWorldExample(
      module: 'carnot', emoji: '⚡',
      title: 'Power plant',
      description: 'Steam turbines are large Carnot-like engines. Higher steam temperature = better efficiency.',
    ),
  ],
  'phase_change': [
    RealWorldExample(
      module: 'phase_change', emoji: '💦',
      title: 'Sweating',
      description: 'Sweat evaporates from skin. Evaporation absorbs body heat — that\'s how you cool down.',
    ),
    RealWorldExample(
      module: 'phase_change', emoji: '🧊',
      title: 'Ice packs',
      description: 'Melting ice absorbs latent heat from injuries to reduce swelling.',
    ),
    RealWorldExample(
      module: 'phase_change', emoji: '🌫️',
      title: 'Clouds forming',
      description: 'Water vapor condenses (releases latent heat) to form clouds and rain.',
    ),
  ],
  'entropy': [
    RealWorldExample(
      module: 'entropy', emoji: '🧊',
      title: 'Ice melting',
      description: 'Ordered ice crystals become disordered liquid water — entropy increases spontaneously.',
    ),
    RealWorldExample(
      module: 'entropy', emoji: '🌹',
      title: 'Perfume spreading',
      description: 'Molecules spread from high to low concentration — nature always increases disorder.',
    ),
    RealWorldExample(
      module: 'entropy', emoji: '🏚️',
      title: 'Rusting & decay',
      description: 'Ordered matter spontaneously breaks down into disorder. You need energy to reverse it.',
    ),
  ],
};
