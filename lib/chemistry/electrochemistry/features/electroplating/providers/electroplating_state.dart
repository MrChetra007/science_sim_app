import '../../../core/constants/electrodes.dart';

enum PlatingObject { key, spoon, coin }

class ElectroplatingState {
  final Electrode metal;
  final PlatingObject target;
  final double currentAmps;
  final double durationSeconds;
  final double depositedMassMg;
  final bool isPlating;

  const ElectroplatingState({
    required this.metal,
    this.target = PlatingObject.key,
    this.currentAmps = 0.0,
    this.durationSeconds = 0.0,
    this.depositedMassMg = 0.0,
    this.isPlating = false,
  });

  ElectroplatingState copyWith({
    Electrode? metal,
    PlatingObject? target,
    double? currentAmps,
    double? durationSeconds,
    double? depositedMassMg,
    bool? isPlating,
  }) {
    return ElectroplatingState(
      metal: metal ?? this.metal,
      target: target ?? this.target,
      currentAmps: currentAmps ?? this.currentAmps,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      depositedMassMg: depositedMassMg ?? this.depositedMassMg,
      isPlating: isPlating ?? this.isPlating,
    );
  }
}
