import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/ph_calculator.dart';

class TitrationState {
  final double currentPH;
  final double acidAddedMl;
  final double baseVolumeMl;
  final List<FlSpot> titrationCurve;
  final bool isRunning;

  const TitrationState({
    required this.currentPH,
    required this.acidAddedMl,
    required this.baseVolumeMl,
    required this.titrationCurve,
    this.isRunning = false,
  });

  TitrationState copyWith({
    double? currentPH,
    double? acidAddedMl,
    double? baseVolumeMl,
    List<FlSpot>? titrationCurve,
    bool? isRunning,
  }) => TitrationState(
    currentPH: currentPH ?? this.currentPH,
    acidAddedMl: acidAddedMl ?? this.acidAddedMl,
    baseVolumeMl: baseVolumeMl ?? this.baseVolumeMl,
    titrationCurve: titrationCurve ?? this.titrationCurve,
    isRunning: isRunning ?? this.isRunning,
  );
}

class TitrationNotifier extends StateNotifier<TitrationState> {
  TitrationNotifier()
    : super(
        const TitrationState(
          currentPH: 13.0, // Starting with a strong base NaOH
          acidAddedMl: 0.0,
          baseVolumeMl: 50.0,
          titrationCurve: [FlSpot(0, 13.0)],
        ),
      );

  void addAcidDrop(double volumeMl) {
    if (state.acidAddedMl > 100) return; // limit simulation

    final newAcidAdded = state.acidAddedMl + volumeMl;
    final newPH = PHCalculator.mixAcidBase(
      acidPH: 1.0, // Strong acid (HCl)
      acidVolumeMl: newAcidAdded,
      basePH: 13.0, // Strong base (NaOH)
      baseVolumeMl: state.baseVolumeMl,
    );

    state = state.copyWith(
      currentPH: newPH,
      acidAddedMl: newAcidAdded,
      titrationCurve: [...state.titrationCurve, FlSpot(newAcidAdded, newPH)],
    );
  }

  void reset() {
    state = const TitrationState(
      currentPH: 13.0,
      acidAddedMl: 0.0,
      baseVolumeMl: 50.0,
      titrationCurve: [FlSpot(0, 13.0)],
    );
  }

  void toggleRunning() {
    state = state.copyWith(isRunning: !state.isRunning);
  }
}

final titrationProvider =
    StateNotifierProvider<TitrationNotifier, TitrationState>(
      (ref) => TitrationNotifier(),
    );
