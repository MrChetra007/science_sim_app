import 'dart:math';

class LorentzEngine {
  /// Map slider (0–100) to β (0.0–0.99) with an ease-in curve
  /// so the interesting range (0.5–0.99) gets more slider travel.
  static double sliderToBeta(double sliderValue) {
    final t = (sliderValue / 100.0).clamp(0.0, 1.0);
    return 0.99 * (1.0 - pow(1.0 - t, 2));
  }

  /// Map β (0.0–0.99) back to slider value (0–100)
  static double betaToSlider(double beta) {
    final b = beta.clamp(0.0, 0.99);
    final inner = (1.0 - b / 0.99).clamp(0.0, 1.0);
    final t = 1.0 - sqrt(inner);
    return t * 100.0;
  }

  /// β = v/c  (0.0 → 0.999)
  /// γ = 1 / √(1 - β²)  — Lorentz factor
  static double gamma(double beta) {
    final b = beta.clamp(0.0, 0.999);
    return 1.0 / sqrt(1.0 - b * b);
  }

  /// Time Dilation: t' = γ × t₀
  /// Moving clock ticks slower — t' > t₀ (when observed from stationary frame)
  static double dilatedTime(double properTime, double beta) {
    return properTime * gamma(beta);
  }

  /// Length Contraction: L' = L₀ / γ
  /// Moving object appears shorter — L' < L₀ (when observed from stationary frame)
  static double contractedLength(double restLength, double beta) {
    return restLength / gamma(beta);
  }

  /// Mass-Energy: E = mc²  (in joules, m in kg)
  static double restEnergy(double massKg) {
    const c = 3e8;
    return massKg * c * c;
  }

  /// Relativistic kinetic energy: KE = (γ - 1) × mc²
  static double kineticEnergy(double massKg, double beta) {
    const c = 3e8;
    return (gamma(beta) - 1.0) * massKg * c * c;
  }

  /// Total relativistic energy: E_total = γ × mc²
  static double totalEnergy(double massKg, double beta) {
    const c = 3e8;
    return gamma(beta) * massKg * c * c;
  }
}
