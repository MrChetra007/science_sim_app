import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../gas_laws/flame/piston_component.dart';
import '../providers/carnot_provider.dart';
import 'heat_flow_indicator.dart';

class CarnotGame extends FlameGame {
  final WidgetRef ref;
  late PistonComponent piston;
  late HeatFlowIndicator qIn;
  late HeatFlowIndicator qOut;
  double animationTime = 0;
  final double cycleDuration = 8.0; // 2 seconds per stage

  // Expose animation state for the UI without Riverpod
  final ValueNotifier<double> volumeNotifier = ValueNotifier(1.0);
  final ValueNotifier<CarnotStep> stepNotifier = ValueNotifier(CarnotStep.isothermalExpansion);

  CarnotGame(this.ref);

  @override
  Future<void> onLoad() async {
    // Heat Flow Indicators
    qIn = HeatFlowIndicator(
      isIn: true,
      color: Colors.redAccent,
      position: Vector2(size.x / 2 - 20, 20),
      size: Vector2(40, 40),
    );
    add(qIn);

    qOut = HeatFlowIndicator(
      isIn: false,
      color: Colors.blueAccent,
      position: Vector2(size.x / 2 - 20, size.y - 100),
      size: Vector2(40, 40),
    );
    add(qOut);

    // Piston
    piston = PistonComponent(volume: 1.0);
    piston.size = Vector2(size.x, 20);
    add(piston);
  }

  @override
  void update(double dt) {
    super.update(dt);
    final state = ref.read(carnotProvider);

    if (state.isPaused) return;

    animationTime += dt;
    final totalProgress = (animationTime % cycleDuration) / cycleDuration;
    final stageIndex = (totalProgress * 4).floor(); // 0-3
    final stageProgress = (totalProgress * 4) % 1.0; // 0.0-1.0
    
    final CarnotStep step = CarnotStep.values[stageIndex];
    double calculatedVolume = 0;

    // Simulation-specific Volume ranges
    const v1 = 0.5; // Min
    const v2 = 1.2; 
    const v3 = 2.0; // Max
    const v4 = 0.8;

    switch (step) {
      case CarnotStep.isothermalExpansion:
        calculatedVolume = v1 + (v2 - v1) * stageProgress;
        qIn.setActive(true);
        qOut.setActive(false);
        break;
      case CarnotStep.adiabaticExpansion:
        calculatedVolume = v2 + (v3 - v2) * stageProgress;
        qIn.setActive(false);
        qOut.setActive(false);
        break;
      case CarnotStep.isothermalCompression:
        calculatedVolume = v3 - (v3 - v4) * stageProgress;
        qIn.setActive(false);
        qOut.setActive(true);
        break;
      case CarnotStep.adiabaticCompression:
        calculatedVolume = v4 - (v4 - v1) * stageProgress;
        qIn.setActive(false);
        qOut.setActive(false);
        break;
    }

    piston.size.x = size.x;
    piston.updateVolume(calculatedVolume, size.y);
    
    // Update local notifiers
    volumeNotifier.value = calculatedVolume;
    stepNotifier.value = step;
  }

  @override
  void onRemove() {
    volumeNotifier.dispose();
    stepNotifier.dispose();
    super.onRemove();
  }
}
