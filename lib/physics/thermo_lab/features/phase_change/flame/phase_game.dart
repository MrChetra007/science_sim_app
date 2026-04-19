import 'package:flame/game.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'particle_state_component.dart';
import '../providers/phase_provider.dart';

class PhaseGame extends FlameGame {
  final WidgetRef ref;
  final List<ParticleStateComponent> _particles = [];
  double _resetKey = 0.0;

  // Simulation State (Internal to Flame)
  double _temperature = -40.0;
  double _progress = 0.0;
  double _time = 0.0;
  final List<FlSpot> _spots = [];

  // Local notifiers to decouple Flame from Riverpod
  final ValueNotifier<double> tempNotifier = ValueNotifier(0.0);
  final ValueNotifier<PhysicalState> phaseNotifier = ValueNotifier(PhysicalState.solid);
  final ValueNotifier<double> progressNotifier = ValueNotifier(0.0);
  final ValueNotifier<List<FlSpot>> curveNotifier = ValueNotifier([]);

  PhaseGame(this.ref);

  @override
  Future<void> onLoad() async {
    _initSubstance();
  }

  void _initSubstance() {
    for (var p in _particles) {
      p.removeFromParent();
    }
    _particles.clear();
    
    final settings = ref.read(phaseProvider);
    _resetKey = settings.resetCounter;
    _temperature = settings.substance.meltingPoint - 40;
    _progress = 0.0;
    _time = 0.0;
    _spots.clear();
    _spots.add(FlSpot(0, _temperature));
    
    _syncNotifiers();

    const rows = 6;
    const cols = 8;
    const spacing = 15.0;
    final startX = size.x / 2 - (cols * spacing) / 2;
    final startY = size.y - 120.0;
    
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        final p = ParticleStateComponent(
          homePosition: Vector2(startX + j * spacing, startY + i * spacing),
          temperature: _temperature,
          phase: _getPhysicalState(),
        );
        _particles.add(p);
        add(p);
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    final settings = ref.read(phaseProvider);

    // Hard reset if substance changed
    if (settings.resetCounter != _resetKey) {
      _initSubstance();
      return;
    }

    if (settings.isPaused) return;

    // --- Thermodynamic Simulation Logic ---
    final double m = 100.0; // 100g
    final double deltaQ = settings.heatRateWatts * dt;
    final s = settings.substance;

    if (_temperature < s.meltingPoint) {
      _temperature += deltaQ / (m * s.specificHeatSolid);
      if (_temperature >= s.meltingPoint) {
         _temperature = s.meltingPoint;
         _progress = 0.0;
      }
    } else if (_temperature == s.meltingPoint && _progress < 1.0) {
      _progress += deltaQ / (m * s.latentHeatFusion);
      if (_progress >= 1.0) _progress = 1.0;
    } else if (_temperature < s.boilingPoint) {
      _temperature += deltaQ / (m * s.specificHeatLiquid);
      if (_temperature >= s.boilingPoint) {
        _temperature = s.boilingPoint;
        _progress = 0.0;
      }
    } else if (_temperature == s.boilingPoint && _progress < 1.0) {
      _progress += deltaQ / (m * s.latentHeatVaporization);
      if (_progress >= 1.0) _progress = 1.0;
    } else {
      _temperature += deltaQ / (m * s.specificHeatGas);
    }

    _time += dt;

    // Update Curve Points (every 0.5s for performance)
    if (_spots.isEmpty || (_time - _spots.last.x) > 0.5) {
       _spots.add(FlSpot(_time, _temperature));
       if (_spots.length > 500) _spots.removeAt(0);
       curveNotifier.value = List.from(_spots);
    }

    // Update Particles
    for (var p in _particles) {
      p.temperature = _temperature;
      p.phase = _getPhysicalState();
    }
    
    _syncNotifiers();
  }

  void _syncNotifiers() {
    tempNotifier.value = _temperature;
    phaseNotifier.value = _getPhysicalState();
    progressNotifier.value = _progress;
  }

  PhysicalState _getPhysicalState() {
    final s = ref.read(phaseProvider).substance;
    if (_temperature < s.meltingPoint) return PhysicalState.solid;
    if (_temperature == s.meltingPoint && _progress < 1.0) return PhysicalState.melting;
    if (_temperature < s.boilingPoint) return PhysicalState.liquid;
    if (_temperature == s.boilingPoint && _progress < 1.0) return PhysicalState.boiling;
    return PhysicalState.gas;
  }

  @override
  void onRemove() {
    tempNotifier.dispose();
    phaseNotifier.dispose();
    progressNotifier.dispose();
    curveNotifier.dispose();
    super.onRemove();
  }
}
