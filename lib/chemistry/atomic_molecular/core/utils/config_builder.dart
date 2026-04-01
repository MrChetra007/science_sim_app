class ConfigBuilder {
  // Aufbau filling order
  static const List<String> _aufbauOrder = [
    '1s', '2s', '2p', '3s', '3p', '4s', '3d', '4p',
    '5s', '4d', '5p', '6s', '4f', '5d', '6p',
  ];

  static const Map<String, int> _maxElectrons = {
    's': 2, 'p': 6, 'd': 10, 'f': 14,
  };

  /// Returns filled orbitals for a given atomic number
  static List<OrbitalFill> buildConfig(int atomicNumber) {
    final result = <OrbitalFill>[];
    int remaining = atomicNumber;

    for (final orbital in _aufbauOrder) {
      if (remaining <= 0) break;
      final type = orbital[orbital.length - 1];
      final max = _maxElectrons[type]!;
      final count = remaining.clamp(0, max);
      result.add(OrbitalFill(orbital: orbital, electrons: count));
      remaining -= count;
    }

    return result;
  }

  /// Format as superscript notation string: "1s² 2s² 2p⁴"
  static String toNotation(List<OrbitalFill> fills) {
    const sup = ['⁰', '¹', '²', '³', '⁴', '⁵', '⁶', '⁷', '⁸', '⁹'];
    return fills.map((f) {
      final String superscript;
      if (f.electrons < 10) {
        superscript = sup[f.electrons];
      } else {
        superscript = '${sup[f.electrons ~/ 10]}${sup[f.electrons % 10]}';
      }
      return '${f.orbital}$superscript';
    }).join(' ');
  }
}

class OrbitalFill {
  final String orbital;
  final int electrons;
  const OrbitalFill({required this.orbital, required this.electrons});
}
