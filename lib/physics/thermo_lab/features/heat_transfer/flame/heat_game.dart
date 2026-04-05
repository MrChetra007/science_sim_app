import 'package:flame/game.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'rod_component.dart';
import 'convection_particle_system.dart';
import 'radiation_particle_system.dart';
import 'heat_source_component.dart';
import '../providers/heat_provider.dart';

class HeatGame extends FlameGame {
  final WidgetRef ref;
  late RodComponent rod;
  late ConvectionParticleSystem convection;
  late RadiationParticleSystem radiation;
  late HeatSourceComponent source;
  HeatMode? currentMode;

  HeatGame(this.ref);

  @override
  Future<void> onLoad() async {
    final state = ref.read(heatProvider);
    currentMode = state.mode;

    _setupComponents(state);
  }

  void _setupComponents(HeatState state) {
    removeAll(children);

    if (state.mode == HeatMode.conduction) {
      rod = RodComponent(
        segments: 10,
        size: Vector2(size.x - 100, 40),
        position: Vector2(50, size.y / 2 - 20),
      );
      add(rod);
    } else if (state.mode == HeatMode.convection) {
      convection = ConvectionParticleSystem(
        count: 40,
        areaWidth: size.x,
        areaHeight: size.y,
      );
      add(convection);
    } else if (state.mode == HeatMode.radiation) {
      // Source at bottom-center
      source = HeatSourceComponent(
        temperature: state.heatSourceTemp,
        position: Vector2(size.x / 2 - 50, size.y - 60),
        size: Vector2(100, 50),
      );
      add(source);

      // Radiation effect
      radiation = RadiationParticleSystem(
        sourcePosition: Vector2(size.x / 2, size.y - 50),
        temperature: state.heatSourceTemp,
        intensity: (1.0 - state.distance).clamp(0.1, 1.0),
      );
      add(radiation);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    final state = ref.read(heatProvider);

    // Sync mode changes
    if (currentMode != state.mode) {
      currentMode = state.mode;
      _setupComponents(state);
    }

    // Run simulation logic locally
    if (state.mode == HeatMode.conduction) {
      rod.tickConduction(
          dt, state.heatSourceTemp, state.selectedMaterial.conductivity);
    } else if (state.mode == HeatMode.radiation) {
      source.temperature = state.heatSourceTemp;
      radiation.updateTemp(state.heatSourceTemp);
      radiation.updateIntensity(state.distance);
    }
  }
}
