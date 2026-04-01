import '../core/ac_math.dart';
import 'dart:math' as math;

class ACState {
  final double vp;          // Peak voltage (V)
  final double frequency;   // Frequency (Hz)
  final double resistance;  // Resistance (Ω)
  final double inductance;  // Inductance (H)
  final double capacitance; // Capacitance (F)
  final double time;        // Current simulation time (seconds)

  ACState({
    this.vp = 120.0,
    this.frequency = 50.0,
    this.resistance = 100.0,
    this.inductance = 0.0,
    this.capacitance = 0.0,
    this.time = 0.0,
  });

  // Computed properties
  double get vt       => ACMath.voltage(vp, frequency, time);
  
  // Phase shift calculations
  double get xl => ACMath.calculateXL(frequency, inductance);
  double get xc => ACMath.calculateXC(frequency, capacitance);
  double get impedance => ACMath.calculateImpedance(resistance, xl, xc);
  double get phi => ACMath.calculatePhaseAngle(resistance, xl, xc);

  // Instantaneous current with phase shift: i(t) = (Vp/Z) * sin(omega*t - phi)
  double get it {
    if (impedance == 0) return 0;
    return (vp / impedance) * math.sin(omega * time - phi);
  }

  double get valVrms  => ACMath.vrms(vp);
  double get valIrms  => (vp / impedance) / math.sqrt(2);
  double get period   => ACMath.periodMs(frequency);
  double get avgPower => valVrms * valIrms * math.cos(phi);
  double get phaseDeg => ACMath.phaseDeg(frequency, time);
  double get omega    => ACMath.omega(frequency);
  double get brightness => ACMath.bulbBrightness(vt, vp);

  ACState copyWith({
    double? vp,
    double? frequency,
    double? resistance,
    double? inductance,
    double? capacitance,
    double? time,
  }) {
    return ACState(
      vp:           vp          ?? this.vp,
      frequency:    frequency   ?? this.frequency,
      resistance:   resistance  ?? this.resistance,
      inductance:   inductance  ?? this.inductance,
      capacitance:  capacitance ?? this.capacitance,
      time:         time        ?? this.time,
    );
  }
}
