import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/constants/electrolytes.dart';
import 'electrolysis_state.dart';

part 'electrolysis_provider.g.dart';

@riverpod
class ElectrolysisNotifier extends _$ElectrolysisNotifier {
  Timer? _tickTimer;

  @override
  ElectrolysisState build() {
    ref.onDispose(() => _tickTimer?.cancel());
    return ElectrolysisState(
      electrolyte: kElectrolytes[0],
      appliedVoltage: 0.0,
      isPowerOn: false,
    );
  }

  void setVoltage(double v) {
    state = state.copyWith(appliedVoltage: v);
    _updateReaction();
  }

  void togglePower(bool on) {
    state = state.copyWith(isPowerOn: on);
    _updateReaction();
  }

  void setElectrolyte(Electrolyte e) {
    state = state.copyWith(
      electrolyte: e,
      anodeGasVolume: 0,
      cathodeGasVolume: 0,
    );
    _updateReaction();
  }

  void _updateReaction() {
    if (state.isReacting) {
      _startTicking();
    } else {
      _stopTicking();
    }
  }

  void _startTicking() {
    if (_tickTimer != null) return;
    _tickTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      final overPotential = state.appliedVoltage - state.electrolyte.thresholdVoltage;
      
      // Faraday Law simplified simulation: rate ~ voltage over Vmin
      final productionRate = (overPotential * 0.01).clamp(0, 0.5);
      
      state = state.copyWith(
        anodeGasVolume: state.anodeGasVolume + productionRate,
        cathodeGasVolume: state.cathodeGasVolume + productionRate * 2, // H2 vs O2 stoichiometry
        currentAmps: overPotential * 0.5,
      );
    });
  }

  void _stopTicking() {
    _tickTimer?.cancel();
    _tickTimer = null;
    state = state.copyWith(currentAmps: 0);
  }
}
