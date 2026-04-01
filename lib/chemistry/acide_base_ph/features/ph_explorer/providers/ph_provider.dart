import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/substances.dart';
import '../../../core/services/audio_service.dart';

class PHState {
  final double ph;
  final Substance? selectedSubstance;

  const PHState({required this.ph, this.selectedSubstance});

  PHState copyWith({double? ph, Substance? selectedSubstance}) => PHState(
        ph: ph ?? this.ph,
        selectedSubstance: selectedSubstance ?? this.selectedSubstance,
      );
}

class PHNotifier extends StateNotifier<PHState> {
  PHNotifier() : super(const PHState(ph: 7.0));

  void setPH(double value) {
    if ((state.ph - value).abs() > 0.5) {
      AudioService.playNeutralize();
    }
    state = state.copyWith(
      ph: value.clamp(0.0, 14.0),
      selectedSubstance: null, // Clear selection when manually sliding
    );
  }

  void selectSubstance(Substance substance) {
    AudioService.playNeutralize();
    state = PHState(ph: substance.ph, selectedSubstance: substance);
  }
}

final phProvider = StateNotifierProvider<PHNotifier, PHState>(
  (ref) => PHNotifier(),
);
