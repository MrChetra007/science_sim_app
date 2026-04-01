import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'electroplating_state.dart';
import '../../../core/constants/electrodes.dart';

part 'electroplating_provider.g.dart';

const double kFaradayConstant = 96485.3; // C/mol

@riverpod
class ElectroplatingNotifier extends _$ElectroplatingNotifier {
  Timer? _timer;

  @override
  ElectroplatingState build() {
    ref.onDispose(() => _timer?.cancel());
    return ElectroplatingState(
      metal: kElectrodes.firstWhere((e) => e.symbol == 'Ag'), // Standard: Silver plating
    );
  }

  void setCurrent(double amps) {
    state = state.copyWith(currentAmps: amps);
    _checkPlating();
  }

  void setIsPlating(bool start) {
    state = state.copyWith(isPlating: start);
    _checkPlating();
  }

  void setMetal(Electrode e) {
    state = state.copyWith(metal: e, depositedMassMg: 0, durationSeconds: 0);
    _checkPlating();
  }

  void setTarget(PlatingObject obj) {
    state = state.copyWith(target: obj, depositedMassMg: 0, durationSeconds: 0);
  }

  void _checkPlating() {
    if (state.isPlating && state.currentAmps > 0) {
      _startTimer();
    } else {
      _stopTimer();
    }
  }

  void _startTimer() {
    if (_timer != null) return;
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      const dt = 0.1; // seconds
      final current = state.currentAmps;
      final molarMass = state.metal.molarMass;
      final valence = state.metal.electrons;

      // Faraday's Law: m = (I * t * M) / (n * F)
      // Result in grams, converted to mg (* 1000)
      final dMassG = (current * dt * molarMass) / (valence * kFaradayConstant);
      final dMassMg = dMassG * 1000;

      state = state.copyWith(
        durationSeconds: state.durationSeconds + dt,
        depositedMassMg: state.depositedMassMg + dMassMg,
      );
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }
}
