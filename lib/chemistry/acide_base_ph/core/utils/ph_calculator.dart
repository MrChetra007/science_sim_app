import 'dart:math';

class PHCalculator {
  /// Hydrogen ion concentration [H⁺] from pH
  static double hydrogenConcentration(double ph) => pow(10, -ph).toDouble();

  /// Hydroxide ion concentration [OH⁻] from pH
  static double hydroxideConcentration(double ph) => pow(10, -(14 - ph)).toDouble();

  /// pOH from pH
  static double poh(double ph) => 14 - ph;

  /// Mix acid and base — returns resulting pH
  static double mixAcidBase({
    required double acidPH,
    required double acidVolumeMl,
    required double basePH,
    required double baseVolumeMl,
  }) {
    // moles = concentration * volume
    final hAcid = hydrogenConcentration(acidPH) * (acidVolumeMl / 1000);
    final ohBase = hydroxideConcentration(basePH) * (baseVolumeMl / 1000);
    final totalVolumeL = (acidVolumeMl + baseVolumeMl) / 1000;

    if (totalVolumeL == 0) return 7.0;

    // React H+ and OH- to form water (neutralization)
    if ((hAcid - ohBase).abs() < 1e-15) return 7.0; // exactly neutral

    if (hAcid > ohBase) {
      // Excess acid remains
      final excessHMoL = hAcid - ohBase;
      final concentrationH = excessHMoL / totalVolumeL;
      // pH = -log10[H+]
      return -log(concentrationH) / ln10;
    } else {
      // Excess base remains
      final excessOHMoL = ohBase - hAcid;
      final concentrationOH = excessOHMoL / totalVolumeL;
      // pOH = -log10[OH-]
      final pOH = -log(concentrationOH) / ln10;
      return 14 - pOH;
    }
  }

  /// Label the pH type
  static String label(double ph) {
    if (ph < 3) return 'Strong acid';
    if (ph < 6) return 'Weak acid';
    if (ph < 6.5) return 'Mildly acidic';
    if (ph <= 7.5) return 'Neutral';
    if (ph <= 9) return 'Mildly basic';
    if (ph <= 11) return 'Weak base';
    return 'Strong base';
  }
}
