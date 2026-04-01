import 'dart:math' as math;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fl_chart/fl_chart.dart';
import 'nernst_state.dart';

part 'nernst_provider.g.dart';

const double kGasConstant = 8.314;    // R, J/(mol·K)
const double kFaraday     = 96485.0;  // F, C/mol

@riverpod
class NernstNotifier extends _$NernstNotifier {
  @override
  NernstState build() {
    return _recalculate(const NernstState(
      standardPotential: 1.10, // Zn/Cu cell
      n: 2,
      temperatureK: 298.15,    // 25°C
      concentrationOx: 1.0,
      concentrationRed: 1.0,
    ));
  }

  void setTemperature(double tKelvin) {
    state = _recalculate(state.copyWith(temperatureK: tKelvin));
  }

  void setConcentrationOx(double c) {
    state = _recalculate(state.copyWith(concentrationOx: c));
  }

  void setConcentrationRed(double c) {
    state = _recalculate(state.copyWith(concentrationRed: c));
  }

  NernstState _recalculate(NernstState s) {
    final Q = s.concentrationRed / s.concentrationOx;
    
    // Nernst Equation: E = E° - (RT/nF) * ln(Q)
    final nernstCorrection = (kGasConstant * s.temperatureK) / (s.n * kFaraday) * math.log(Q);
    final eCellActual = s.standardPotential - nernstCorrection;

    return s.copyWith(
      reactionQuotient: Q,
      actualPotential: eCellActual,
    );
  }

  // Generate data points for Nernst curve (E vs Concentration Ratio)
  // We'll vary the ratio from 0.01 to 100 for a linear/log visual
  List<FlSpot> generateLinearPoints() {
    final points = <FlSpot>[];
    for (double ratio = 0.05; ratio <= 5.0; ratio += 0.1) {
      final nernstCorrection = (kGasConstant * state.temperatureK) / (state.n * kFaraday) * math.log(ratio);
      final e = state.standardPotential - nernstCorrection;
      points.add(FlSpot(ratio, e));
    }
    return points;
  }
}
