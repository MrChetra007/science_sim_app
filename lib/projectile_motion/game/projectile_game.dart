import 'dart:math' as math;
import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import '../models/trajectory_data.dart';
import 'components/ground_component.dart';
import 'components/cannon_component.dart';
import 'components/trajectory_component.dart';
import 'components/projectile_component.dart';
import 'components/hud_component.dart';
import 'components/background_component.dart';
import 'components/target_component.dart';
import '../services/audio_service.dart';
import 'package:flame/particles.dart';
import 'package:flame/components.dart';

/// Maps physical coordinates (meters) to screen coordinates (pixels).
class CoordinateMapper {
  final double scale; // pixels per meter
  final double originX; // screen x of physical x=0
  final double originY; // screen y of physical y=0 (ground)

  const CoordinateMapper({
    required this.scale,
    required this.originX,
    required this.originY,
  });

  /// Physical → Screen
  Offset toScreen(double px, double py) =>
      Offset(originX + px * scale, originY - py * scale);
}

/// Main Flame game for the projectile simulator.
class ProjectileGame extends FlameGame {
  CoordinateMapper? mapper;

  // Current simulation data
  TrajectoryData? _trajectory;
  double _currentTime = 0;
  bool _isPlaying = false;
  double _playbackSpeed = 1.0;
  double _initialHeight = 0.0;
  double _angleDeg = 45.0;

  // Projectile appearance & metadata
  Color projectileColor = const Color(0xFF4A4A4A);
  double projectileRadius = 8.0;
  String projectileObjectId = 'cannonball';

  // HUD data (updated by SimulationNotifier)
  double gravityValue = 9.81;
  String planetName = '🌍 Earth';
  String objectName = '💣 Cannonball';
  double objectMass = 4.0;

  // Visualization settings
  bool showForces = true;
  bool showVelocity = false;

  // Callbacks to Flutter layer
  VoidCallback? onSimulationComplete;

  // Components
  BackgroundComponent? _bg;
  GroundComponent? _ground;
  CannonComponent? _cannon;
  TrajectoryComponent? _trajectoryComp;
  TrajectoryComponent? _ghostTrajectoryComp;
  ProjectileComponent? _projectileComp;
  HudComponent? _hud;
  TargetComponent? _target;

  @override
  Color backgroundColor() => const Color(0xFF0D1B2A);

  @override
  Future<void> onLoad() async {
    // Initialize components first
    _bg = BackgroundComponent();
    _ground = GroundComponent(game: this);
    _cannon = CannonComponent(game: this);
    _trajectoryComp = TrajectoryComponent(game: this);
    _ghostTrajectoryComp = TrajectoryComponent(
        game: this, isGhost: true, color: const Color(0xFF90A4AE));
    _projectileComp = ProjectileComponent(game: this);
    _hud = HudComponent(game: this);
    _target = TargetComponent(game: this);

    // Now safe to build mapper
    _buildMapper(size);

    await addAll([
      _bg!,
      _ground!,
      _target!,
      _ghostTrajectoryComp!,
      _trajectoryComp!,
      _cannon!,
      _projectileComp!,
      _hud!,
    ]);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _buildMapper(size);
  }

  void _buildMapper(Vector2 size) {
    final w = size.x;
    final h = size.y;

    final groundScreenY = h * 0.82;
    final originX = w * 0.12;

    // Default minimum view bounds
    double maxRange = 100.0;
    double maxAbsH = 50.0;

    // Expand bounds to fit the current trajectory
    if (_trajectory != null && !_trajectory!.isEmpty) {
      // Add a small margin (15%) so the ball doesn't hit the very edge
      maxRange = math.max(maxRange, _trajectory!.range * 1.15);
      maxAbsH = math.max(maxAbsH, _trajectory!.maxHeight * 1.15);
    }

    // Expand bounds to fit the target if it exists
    final targetDist = _target?.getDistance();
    if (targetDist != null) {
      maxRange = math.max(maxRange, targetDist + 20); // 20m padding for target
    }

    final availW = w * 0.80;
    final availH =
        groundScreenY - h * 0.10; // Extra top padding for better view

    final scaleX = availW / maxRange;
    final scaleY = availH / math.max(maxAbsH, 1.0);

    // Choose the smaller scale to fit everything on screen
    final scale = math.min(scaleX, scaleY);

    mapper = CoordinateMapper(
      scale: scale,
      originX: originX,
      originY: groundScreenY,
    );
  }

  // ── Public API called by SimulationNotifier ──────────────────────────────

  void setAngle(double deg) {
    _angleDeg = deg;
    _cannon?.setAngle(deg);
  }

  double get angleDeg => _angleDeg;
  double get initialHeight => _initialHeight;

  void setInitialHeight(double h) {
    _initialHeight = h;
    _buildMapper(size);
  }

  void setProjectileAppearance(Color color, double radius, String objectId) {
    projectileColor = color;
    projectileRadius = radius;
    projectileObjectId = objectId;
  }

  void setHudData({
    required double gravity,
    required String planet,
    required String object,
    required double mass,
    required String gravityId,
  }) {
    gravityValue = gravity;
    planetName = planet;
    objectName = object;
    objectMass = mass;
    _bg?.updatePlanet(gravityId);
  }

  void vectorSettings({required bool forces, required bool velocity}) {
    showForces = forces;
    showVelocity = velocity;
  }

  void setTarget(double? distance) {
    _target?.setDistance(distance);
    if (distance != null) {
      // Rebuild mapper if target is further than current view
      _buildMapper(size);
    }
  }

  void loadTrajectory(TrajectoryData traj, double h0, {TrajectoryData? prev}) {
    _trajectory = traj;
    _initialHeight = h0;
    _currentTime = 0;
    _isPlaying = false;
    _buildMapper(size);
    _trajectoryComp?.setTrajectory(traj);
    if (prev != null) {
      _ghostTrajectoryComp?.setTrajectory(prev);
      _ghostTrajectoryComp?.setRevealedTime(prev.hangTime);
    } else {
      _ghostTrajectoryComp?.clear();
    }
    _projectileComp?.setTrajectory(traj);
    _projectileComp?.setTime(0);
    _projectileComp?.isVisible = true;
  }

  void startAnimation(bool slowMotion) {
    _isPlaying = true;
    _playbackSpeed = slowMotion ? 0.25 : 1.0;
    _cannon?.playRecoil();
    AudioService.playLaunch();
    _triggerLaunchParticles();
  }

  void pauseAnimation() => _isPlaying = false;

  void resumeAnimation(bool slowMotion) {
    _isPlaying = true;
    _playbackSpeed = slowMotion ? 0.25 : 1.0;
  }

  void setSpeed(double speed) => _playbackSpeed = speed;

  void reset() {
    _trajectory = null;
    _currentTime = 0;
    _isPlaying = false;
    _trajectoryComp?.clear();
    _ghostTrajectoryComp?.clear();
    if (_projectileComp != null) {
      _projectileComp!.isVisible = false;
    }
    _buildMapper(size);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_isPlaying && _trajectory != null) {
      _currentTime += dt * _playbackSpeed;
      final totalTime = _trajectory!.hangTime;
      if (_currentTime >= totalTime) {
        _currentTime = totalTime;
        _isPlaying = false;
        AudioService.playImpact();
        _triggerImpactParticles();
        onSimulationComplete?.call();
      }
      _projectileComp?.setTime(_currentTime);
      _trajectoryComp?.setRevealedTime(_currentTime);
    }
  }

  void _triggerLaunchParticles() {
    if (mapper == null) return;
    final muzzle = mapper!.toScreen(0, _initialHeight);
    // Slightly offset muzzle center based on angle
    final angleRad = _angleDeg * math.pi / 180;
    final offset = Offset(math.cos(angleRad) * 40, -math.sin(angleRad) * 40);
    final spawnPos = muzzle + offset;

    add(
      ParticleSystemComponent(
        particle: Particle.generate(
          count: 15,
          lifespan: 0.8,
          generator: (i) => AcceleratedParticle(
            acceleration: Vector2(0, -20),
            speed: Vector2(
                  math.cos(angleRad + (i - 7) * 0.1) * 100,
                  -math.sin(angleRad + (i - 7) * 0.1) * 100,
                ) *
                (0.5 + math.Random().nextDouble()),
            position: Vector2(spawnPos.dx, spawnPos.dy),
            child: CircleParticle(
              radius: 2.0 + math.Random().nextDouble() * 4.0,
              paint: Paint()..color = const Color(0x88EEEEEE),
            ),
          ),
        ),
      ),
    );
  }

  void _triggerImpactParticles() {
    if (mapper == null || _trajectory == null) return;
    final land = mapper!.toScreen(_trajectory!.range, 0);

    add(
      ParticleSystemComponent(
        particle: Particle.generate(
          count: 20,
          lifespan: 0.6,
          generator: (i) => AcceleratedParticle(
            acceleration: Vector2(0, 200), // Gravity
            speed: Vector2(
              (math.Random().nextDouble() - 0.5) * 150,
              -math.Random().nextDouble() * 200,
            ),
            position: Vector2(land.dx, land.dy),
            child: CircleParticle(
              radius: 1.5 + math.Random().nextDouble() * 3.0,
              paint: Paint()
                ..color = const Color(0xFFFFD54F).withValues(alpha: 0.8),
            ),
          ),
        ),
      ),
    );
  }
}
