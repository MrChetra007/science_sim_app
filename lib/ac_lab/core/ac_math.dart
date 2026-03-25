import 'dart:math' as math;

class ACMath {
  // Instantaneous voltage at time t: V(t) = Vp * sin(2 * pi * f * t)
  static double voltage(double Vp, double freq, double t) {
    return Vp * math.sin(2 * math.pi * freq * t);
  }

  // Instantaneous current: I(t) = V(t) / R
  static double current(double Vt, double R) {
    return Vt / R;
  }

  // RMS voltage: Vrms = Vp / sqrt(2)
  static double vrms(double Vp) => Vp / math.sqrt(2);

  // RMS current: Irms = Vrms / R
  static double irms(double Vp, double R) => vrms(Vp) / R;

  // Period in milliseconds: T = 1000 / f
  static double periodMs(double freq) => 1000.0 / freq;

  // Angular frequency: omega = 2 * pi * f
  static double omega(double freq) => 2 * math.pi * freq;

  // Average power: Pavg = Vrms * Irms = Vrms^2 / R
  static double avgPower(double Vp, double R) {
    final vr = vrms(Vp);
    return vr * vr / R;
  }

  // Phase angle in degrees (for display): range 0-360
  static double phaseDeg(double freq, double t) {
    return (omega(freq) * t * 180 / math.pi) % 360;
  }

  // Instantaneous power: P(t) = V(t) * I(t)
  static double instantPower(double Vt, double It) => Vt * It;

  // Normalised brightness for bulb (0.0 – 1.0) based on instantaneous voltage ratio
  static double bulbBrightness(double Vt, double Vp) {
    if (Vp == 0) return 0;
    return Vt.abs() / Vp;
  }

  // Reactive Math
  static double calculateXL(double frequency, double inductance) {
    return 2 * math.pi * frequency * inductance;
  }

  static double calculateXC(double frequency, double capacitance) {
    if (capacitance == 0) return 999999;
    return 1 / (2 * math.pi * frequency * capacitance);
  }

  static double calculateImpedance(double r, double xl, double xc) {
    return math.sqrt(math.pow(r, 2) + math.pow(xl - xc, 2));
  }

  static double calculatePhaseAngle(double r, double xl, double xc) {
    return math.atan2(xl - xc, r);
  }
}
