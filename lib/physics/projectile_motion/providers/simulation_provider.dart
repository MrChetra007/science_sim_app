import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../game/projectile_game.dart';
import '../models/simulation_state.dart';
import '../physics/gravity_presets.dart';
import '../physics/projectile_objects.dart';
import '../physics/projectile_physics.dart';
import '../services/persistence_service.dart';
import '../../../core/services/subscription_service.dart';

/// Provider that holds a single game instance for the lifetime of the app.
final projectileGameProvider = Provider<ProjectileGame>((ref) {
  return ProjectileGame();
});

/// Simulation state provider — controls all physics parameters and playback.
final simulationProvider =
    StateNotifierProvider<SimulationNotifier, SimulationState>(
  (ref) => SimulationNotifier(ref),
);

class SimulationNotifier extends StateNotifier<SimulationState> {
  final Ref _ref;
  SubscriptionService? _subService;
  SimulationNotifier(this._ref) : super(SimulationState.initial()) {
    // Connect the game's completion callback
    final game = _ref.read(projectileGameProvider);
    game.onSimulationComplete = _onGameComplete;
    
    // Initialize subscription service reference and listener
    _initSubscription();
    _initSettings();
    
    // Retry subscription init after frame renders (in case context wasn't ready)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initSubscription();
    });
  }

  void _initSubscription() {
    if (_subService != null) return;
    
    // Use the singleton SubscriptionService instance
    _subService = SubscriptionService();
    _subService!.addListener(_onSubscriptionChange);
    
    // Set initial pro status
    if (state.isPro != _subService!.isPro) {
      state = state.copyWith(isPro: _subService!.isPro);
    }
  }

  void _onSubscriptionChange() {
    final service = _subService ?? SubscriptionService();
    if (state.isPro != service.isPro) {
      state = state.copyWith(isPro: service.isPro);
    }
  }

  Future<void> _initSettings() async {
    final settings = await PersistenceService.loadSettings();
    if (settings != null) {
      state = state.copyWith(
        angle: settings['angle'] ?? state.angle,
        initialSpeed: settings['speed'] ?? state.initialSpeed,
        initialHeight: settings['height'] ?? state.initialHeight,
        gravity: settings['gravity'] ?? state.gravity,
        selectedGravityId: settings['gravityId'] ?? state.selectedGravityId,
        selectedObjectId: settings['objectId'] ?? state.selectedObjectId,
        airResistance: settings['airResistance'] ?? state.airResistance,
        slowMotion: settings['slowMotion'] ?? state.slowMotion,
        isChallengeMode: settings['challengeMode'] ?? state.isChallengeMode,
        score: settings['score'] ?? state.score,
        showForces: settings['showForces'] ?? state.showForces,
        showVelocity: settings['showVelocity'] ?? state.showVelocity,
      );

      // Initialize Pro status
      final isPro = _subService?.isPro ?? SubscriptionService().isPro;
      state = state.copyWith(isPro: isPro);

      _syncAppearanceToGame();
      _syncHudToGame();
      _syncTargetToGame();
      _syncVectorSettingsToGame();
      _game.setAngle(state.angle);
      _game.setInitialHeight(state.initialHeight);
    }
  }

  @override
  void dispose() {
    _subService?.removeListener(_onSubscriptionChange);
    super.dispose();
  }

  void _syncTargetToGame() {
    _game.setTarget(state.isChallengeMode ? state.targetDistance : null);
  }

  void _save() => PersistenceService.saveSettings(state);

  ProjectileGame get _game => _ref.read(projectileGameProvider);

  void _onGameComplete() {
    state = state.copyWith(status: SimulationStatus.completed);
    if (state.isChallengeMode) {
      _checkHit();
    }
  }

  void _checkHit() {
    final traj = state.trajectory;
    final target = state.targetDistance;
    if (traj == null || target == null) return;

    final landingX = traj.range;
    final distance = (landingX - target).abs();

    if (distance <= 2.5) {
      // Hit!
      state = state.copyWith(score: state.score + 100);
      _save();
      // Generate new target for next round
      _generateTarget();
    }
  }

  // ── Parameter updates ────────────────────────────────────────────────────

  void updateAngle(double angle) {
    state = state.copyWith(angle: angle);
    _game.setAngle(angle);
    _recompute();
    _save();
  }

  void updateSpeed(double speed) {
    state = state.copyWith(initialSpeed: speed);
    _recompute();
    _save();
  }

  void updateHeight(double height) {
    state = state.copyWith(initialHeight: height);
    _game.setInitialHeight(height);
    _recompute();
    _save();
  }

  void selectGravity(String id) {
    final preset = gravityById(id);
    state = state.copyWith(selectedGravityId: id, gravity: preset.value);
    _syncHudToGame();
    _recompute();
    _save();
  }

  void updateGravity(double value) {
    state = state.copyWith(selectedGravityId: 'custom', gravity: value);
    _syncHudToGame();
    _recompute();
    _save();
  }

  void selectObject(String id) {
    state = state.copyWith(selectedObjectId: id);
    _syncAppearanceToGame();
    _syncHudToGame();
    _recompute();
    _save();
  }

  void toggleAirResistance() {
    state = state.copyWith(airResistance: !state.airResistance);
    _recompute();
    _save();
  }

  void toggleSlowMotion() {
    final newVal = !state.slowMotion;
    state = state.copyWith(slowMotion: newVal);
    if (state.isRunning) _game.setSpeed(newVal ? 0.25 : 1.0);
    _save();
  }

  void toggleChallengeMode() {
    final enabled = !state.isChallengeMode;
    state = state.copyWith(isChallengeMode: enabled);
    if (enabled) {
      _generateTarget();
    } else {
      state = state.copyWith(clearTarget: true);
      _syncTargetToGame();
    }
    _save();
  }

  void toggleForces() {
    state = state.copyWith(showForces: !state.showForces);
    _syncVectorSettingsToGame();
    _save();
  }

  void toggleVelocity() {
    state = state.copyWith(showVelocity: !state.showVelocity);
    _syncVectorSettingsToGame();
    _save();
  }

  void _syncVectorSettingsToGame() {
    _game.vectorSettings(
      forces: state.showForces,
      velocity: state.showVelocity,
    );
  }

  void toggleMathSolver() {
    state = state.copyWith(showMathSolver: !state.showMathSolver);
    _save();
  }

  Future<void> unlockPro() async {
    // Note: Projectile Motion upgrade intent redirects to global plan dialog in the views.
    // If called directly, no-op or trigger global provider.
  }

  Future<void> restorePro() async {
    // Handled by global subscription service
  }

  void _generateTarget() {
    final random = math.Random();
    // Random target between 10m and 50m
    final distance = 10.0 + random.nextDouble() * 40.0;
    state = state.copyWith(targetDistance: distance);
    _syncTargetToGame();
  }

  void _recompute() {
    // Only recompute if we aren't currently playing/paused in the middle of a launch.
    // This provides a live "preview" of the trajectory results in the panel.
    if (state.status == SimulationStatus.idle ||
        state.status == SimulationStatus.completed) {
      final obj = objectById(state.selectedObjectId);
      final trajectory = ProjectilePhysics.computeTrajectory(
        v0: state.initialSpeed,
        angleDeg: state.angle,
        h0: state.initialHeight,
        gravity: state.gravity,
        airResistance: state.airResistance,
        object: obj,
      );
      state = state.copyWith(trajectory: trajectory);
    }
  }

  // ── Playback control ─────────────────────────────────────────────────────

  void launch() {
    final obj = objectById(state.selectedObjectId);
    final trajectory = ProjectilePhysics.computeTrajectory(
      v0: state.initialSpeed,
      angleDeg: state.angle,
      h0: state.initialHeight,
      gravity: state.gravity,
      airResistance: state.airResistance,
      object: obj,
    );

    state = state.copyWith(
      previousTrajectory: state.trajectory,
      trajectory: trajectory,
      status: SimulationStatus.running,
    );

    _syncAppearanceToGame();
    _syncHudToGame();
    _game.setAngle(state.angle);
    _game.loadTrajectory(
      trajectory,
      state.initialHeight,
      prev: state.previousTrajectory,
    );
    _game.startAnimation(state.slowMotion);
  }

  void pause() {
    state = state.copyWith(status: SimulationStatus.paused);
    _game.pauseAnimation();
  }

  void resume() {
    state = state.copyWith(status: SimulationStatus.running);
    _game.resumeAnimation(state.slowMotion);
  }

  void reset() {
    state = state.copyWith(
      status: SimulationStatus.idle,
      clearTrajectory: true,
    );
    _game.reset();
  }

  void _syncAppearanceToGame() {
    final obj = objectById(state.selectedObjectId);
    _game.setProjectileAppearance(
      Color(obj.colorValue),
      obj.visualRadius,
      obj.id,
    );
  }

  void _syncHudToGame() {
    final obj = objectById(state.selectedObjectId);
    final gravity = gravityById(state.selectedGravityId);
    _game.setHudData(
      gravity: gravity.value,
      planet: '${gravity.emoji} ${gravity.name}',
      object: '${obj.emoji} ${obj.name}',
      mass: obj.mass,
      gravityId: gravity.id,
    );
  }
}
