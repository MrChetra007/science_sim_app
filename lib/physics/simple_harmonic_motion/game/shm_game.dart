import 'dart:math';
import 'dart:ui' show Offset;
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import '../providers/sim_provider.dart' show SimMode;
import 'components/spring_component.dart';
import 'components/mass_component.dart';
import 'components/pendulum_rod_component.dart';
import 'components/pendulum_bob_component.dart';
import 'components/graph_component.dart';
import 'components/energy_bar_component.dart';
import 'components/vector_arrow_component.dart';
import 'components/equilibrium_line_component.dart';

class GameState {
  SimMode mode;
  double springConstant;
  double mass;
  double amplitude;
  double pendulumLength;
  double gravity;
  double initialAngle;
  double time;
  double position;
  double velocity;
  double accel;
  double kineticEnergy;
  double potentialEnergy;
  double totalEnergy;
  double period;
  double omega;
  bool isRunning;
  bool showVectors;
  List<double> posHistory;
  List<double> velHistory;
  List<double> accHistory;

  GameState({
    this.mode = SimMode.spring,
    this.springConstant = 20.0,
    this.mass = 0.5,
    this.amplitude = 0.15,
    this.pendulumLength = 1.0,
    this.gravity = 9.8,
    this.initialAngle = 15.0,
    this.time = 0.0,
    this.position = 0.15,
    this.velocity = 0.0,
    this.accel = 0.0,
    this.kineticEnergy = 0.0,
    this.potentialEnergy = 0.0,
    this.totalEnergy = 0.0,
    this.period = 0.0,
    this.omega = 0.0,
    this.isRunning = true,
    this.showVectors = true,
    List<double>? posHistory,
    List<double>? velHistory,
    List<double>? accHistory,
  })  : posHistory = posHistory ?? [],
        velHistory = velHistory ?? [],
        accHistory = accHistory ?? [];
}

class SHMGame extends FlameGame {
  final SimMode mode;
  final GameState state;
  late SpringComponent spring;
  late MassComponent mass;
  late PendulumRodComponent rod;
  late PendulumBobComponent bob;
  late GraphComponent graph;
  late EnergyBarComponent energyBars;
  late VectorArrowComponent vectors;
  late EquilibriumLineComponent equilibriumLine;

  double _pixelsPerMeter = 200.0;
  double _pendulumPixels = 200.0;

  SHMGame({required this.mode})
      : state = GameState(mode: mode) {
    spring = SpringComponent();
    mass = MassComponent();
    rod = PendulumRodComponent();
    bob = PendulumBobComponent();
    graph = GraphComponent();
    energyBars = EnergyBarComponent();
    vectors = VectorArrowComponent();
    equilibriumLine = EquilibriumLineComponent();
    _recompute();
  }

  @override
  Future<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.topLeft;
    if (mode == SimMode.spring) {
      await addAll([equilibriumLine, spring, vectors, mass, energyBars, graph]);
    } else {
      await addAll([equilibriumLine, rod, vectors, bob, energyBars, graph]);
    }
  }

  void _recompute() {
    if (state.mode == SimMode.spring) {
      _computeSpringPhysics();
    } else {
      _computePendulumPhysics();
    }
  }

  void _computeSpringPhysics() {
    final s = state;
    s.omega = sqrt(s.springConstant / s.mass);
    s.period = 2 * pi * sqrt(s.mass / s.springConstant);
    s.totalEnergy = 0.5 * s.springConstant * s.amplitude * s.amplitude;

    s.position = s.amplitude * cos(s.omega * s.time);
    s.velocity = -s.amplitude * s.omega * sin(s.omega * s.time);
    s.accel = -s.omega * s.omega * s.position;

    s.kineticEnergy = 0.5 * s.mass * s.velocity * s.velocity;
    s.potentialEnergy = 0.5 * s.springConstant * s.position * s.position;
  }

  void _computePendulumPhysics() {
    final s = state;
    final theta0 = s.initialAngle * pi / 180.0;
    s.omega = sqrt(s.gravity / s.pendulumLength);
    s.period = 2 * pi * sqrt(s.pendulumLength / s.gravity);
    s.totalEnergy = s.mass * s.gravity * s.pendulumLength * (1 - cos(theta0));

    final theta = theta0 * cos(s.omega * s.time);
    final dTheta = -theta0 * s.omega * sin(s.omega * s.time);

    s.position = s.pendulumLength * theta;
    s.velocity = s.pendulumLength * dTheta;
    s.accel = -s.omega * s.omega * s.position;

    s.kineticEnergy = 0.5 * s.mass * s.pendulumLength * s.pendulumLength * dTheta * dTheta;
    s.potentialEnergy = s.mass * s.gravity * s.pendulumLength * (1 - cos(theta));
  }

  void _appendHistory() {
    final s = state;
    if (s.posHistory.length >= GraphComponent.maxPoints) {
      s.posHistory.removeAt(0);
      s.velHistory.removeAt(0);
      s.accHistory.removeAt(0);
    }
    s.posHistory.add(s.position);
    s.velHistory.add(s.velocity);
    s.accHistory.add(s.accel);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!state.isRunning) return;

    state.time += dt;
    _recompute();
    _appendHistory();
    _syncComponents();
  }

  void _syncComponents() {
    final s = state;
    final gameSize = size;
    final w = gameSize.x;
    final h = gameSize.y;

    final graphPct = 0.32;
    final energyPct = 0.06;
    final simPct = 0.40;

    graph.posHistory = s.posHistory;
    graph.velHistory = s.velHistory;
    graph.accHistory = s.accHistory;
    graph.size = Vector2(w, h * graphPct);
    graph.detectAnnotations();

    energyBars.kineticEnergy = s.kineticEnergy;
    energyBars.potentialEnergy = s.potentialEnergy;
    energyBars.totalEnergy = s.totalEnergy;
    energyBars.size = Vector2(w, h * energyPct);
    energyBars.position.y = h * graphPct;

    vectors.velocity = s.velocity;
    vectors.acceleration = s.accel;
    vectors.force = -s.springConstant * s.position;
    vectors.visible = s.showVectors;

    final simAreaTop = h * (graphPct + energyPct);
    final simAreaHeight = h * simPct;

    final centerX = w / 2;

    _pendulumPixels = simAreaHeight * 0.75;
    _pixelsPerMeter = simAreaHeight * 0.7;

    equilibriumLine.size = Vector2(w, simAreaHeight);
    equilibriumLine.position.y = simAreaTop;

    if (s.mode == SimMode.spring) {
      final ceilingY = simAreaTop;
      final restLength = simAreaHeight * 0.4;
      final equilibriumY = ceilingY + restLength;
      final massY = equilibriumY + s.position * _pixelsPerMeter;

      mass.position = Vector2(centerX, massY);
      mass.massValue = s.mass;
      mass.updateTrail(s.velocity, Offset(centerX, massY));
      spring.centerX = centerX;
      spring.ceilingY = ceilingY;
      spring.restLength = restLength;
      spring.displacement = s.position;
      spring.updateStretch(restLength + s.position * _pixelsPerMeter);
      vectors.position = Vector2(centerX, massY);
    } else {
      final pivotX = centerX;
      final pivotY = simAreaTop;
      final theta = s.position / s.pendulumLength;
      final bobX = pivotX + _pendulumPixels * sin(theta);
      final bobY = pivotY + _pendulumPixels * cos(theta);

      rod.pivotX = pivotX;
      rod.pivotY = pivotY;
      rod.bobX = bobX;
      rod.bobY = bobY;
      bob.position = Vector2(bobX, bobY);
      bob.updateTrail(s.velocity, Offset(bobX, bobY));
      vectors.position = Vector2(bobX, bobY);
    }
  }

  void togglePause() {
    state.isRunning = !state.isRunning;
  }

  void toggleVectors() {
    state.showVectors = !state.showVectors;
  }

  void reset() {
    state.time = 0;
    state.posHistory.clear();
    state.velHistory.clear();
    state.accHistory.clear();
    state.position = state.amplitude;
    state.velocity = 0;
    _recompute();
    _syncComponents();
  }
}
