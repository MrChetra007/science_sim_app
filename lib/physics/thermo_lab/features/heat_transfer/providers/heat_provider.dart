import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/materials.dart';

enum HeatMode { conduction, convection, radiation }

class HeatState {
  final HeatMode mode;
  final ThermalMaterial selectedMaterial;
  final double heatSourceTemp;  // °C
  final double distance;        // for radiation mode (0.1–1.0)

  const HeatState({
    required this.mode,
    required this.selectedMaterial,
    required this.heatSourceTemp,
    required this.distance,
  });

  HeatState copyWith({
    HeatMode? mode,
    ThermalMaterial? selectedMaterial,
    double? heatSourceTemp,
    double? distance,
  }) {
    return HeatState(
      mode: mode ?? this.mode,
      selectedMaterial: selectedMaterial ?? this.selectedMaterial,
      heatSourceTemp: heatSourceTemp ?? this.heatSourceTemp,
      distance: distance ?? this.distance,
    );
  }
}

class HeatNotifier extends StateNotifier<HeatState> {
  HeatNotifier() : super(HeatState(
    mode: HeatMode.conduction,
    selectedMaterial: kMaterials[0],
    heatSourceTemp: 200.0,
    distance: 0.2,
  ));

  void setMode(HeatMode mode) {
    if (mode != state.mode) {
      state = state.copyWith(mode: mode);
    }
  }

  void setMaterial(ThermalMaterial m) => state = state.copyWith(selectedMaterial: m);
  void setHeatTemp(double t)   => state = state.copyWith(heatSourceTemp: t);
  void setDistance(double d)   => state = state.copyWith(distance: d);
}

final heatProvider = StateNotifierProvider<HeatNotifier, HeatState>(
  (ref) => HeatNotifier(),
);
