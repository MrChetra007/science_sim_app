import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../components/physics_body.dart';
import '../../components/force_arrow.dart';
import '../../components/data_hud.dart';
import '../../physics/collision_resolver.dart';
import '../../core/constants.dart';
import '../../components/particle_effects.dart';
import 'package:flame_audio/flame_audio.dart';

enum Law3SceneType { collision, rocket }

class Law3Game extends FlameGame {
  // Collision components
  late PhysicsBody boxA;
  late PhysicsBody boxB;
  late ForceArrow impulseArrowA; // Cyan (Action)
  late ForceArrow impulseArrowB; // Pink (Reaction)
  late DataHUD hudA;
  late DataHUD hudB;

  // Rocket components
  late RocketComponent rocket;
  late ForceArrow thrustArrow; // Cyan (Action - exhaust)
  late ForceArrow reactionArrow; // Pink (Reaction - lift)

  Law3SceneType currentSceneType = Law3SceneType.collision;

  double massA = 10.0;
  double massB = 10.0;
  double bounciness = 1.0; // 0 to 1
  bool isPlaying = false;
  bool collisionHandled = false;

  Vector2 get startPosA => Vector2(50, size.y * 0.5 - 50);
  Vector2 get startPosB => Vector2(size.x - 100, size.y * 0.5 - 50);

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    // Collision Surface
    add(
      LaneComponent(
        position: Vector2(0, size.y * 0.5),
        size: Vector2(size.x, 2),
      ),
    );

    _setupBoxes();
    _setupRocket();

    _setVisibilities();
  }

  void switchScene(Law3SceneType type) {
    if (isPlaying) return;
    currentSceneType = type;
    _setVisibilities();
  }

  void _setVisibilities() {
    final showCollision = currentSceneType == Law3SceneType.collision;

    // Collision visibility
    boxA.scale = showCollision ? Vector2.all(1) : Vector2.all(0);
    boxB.scale = showCollision ? Vector2.all(1) : Vector2.all(0);
    hudA.scale = showCollision ? Vector2.all(1) : Vector2.all(0);
    hudB.scale = showCollision ? Vector2.all(1) : Vector2.all(0);
    impulseArrowA.scale = showCollision ? Vector2.all(1) : Vector2.all(0);
    impulseArrowB.scale = showCollision ? Vector2.all(1) : Vector2.all(0);

    // Rocket visibility
    rocket.scale = !showCollision ? Vector2.all(1) : Vector2.all(0);
    thrustArrow.scale = !showCollision ? Vector2.all(1) : Vector2.all(0);
    reactionArrow.scale = !showCollision ? Vector2.all(1) : Vector2.all(0);
  }

  void _setupBoxes() {
    double sizeA = 30.0 + (massA * 0.5);
    boxA = PhysicsBody(
      mass: massA,
      position: startPosA.clone(),
      size: Vector2.all(sizeA),
    );

    // Action Force arrow (Cyan)
    impulseArrowA = ForceArrow(
      direction: Vector2(1, 0),
      magnitude: 0,
      color: AppColors.primaryAccent,
      label: 'F_AB',
    );
    impulseArrowA.position = Vector2(0, boxA.size.y / 2); // Center left
    boxA.add(impulseArrowA);
    boxA.add(MassLabel(mass: massA));

    double sizeB = 30.0 + (massB * 0.5);
    boxB = PhysicsBody(
      mass: massB,
      position: startPosB.clone(),
      size: Vector2.all(sizeB),
    );

    // Reaction Force arrow (Pink)
    impulseArrowB = ForceArrow(
      direction: Vector2(-1, 0),
      magnitude: 0,
      color: AppColors.secondaryAccent,
      label: 'F_BA',
    );
    impulseArrowB.position = Vector2(
      boxB.size.x,
      boxB.size.y / 2,
    ); // Center right
    boxB.add(impulseArrowB);
    boxB.add(MassLabel(mass: massB));

    hudA = DataHUD(target: boxA, position: Vector2(20, 20));
    hudB = DataHUD(target: boxB, position: Vector2(size.x - 150, 20));

    add(boxA);
    add(boxB);
    add(hudA);
    add(hudB);
  }

  void _setupRocket() {
    rocket = RocketComponent(
      position: Vector2(size.x / 2, size.y * 0.7),
      size: Vector2(40, 80),
    );

    thrustArrow = ForceArrow(
      direction: Vector2(0, 1), // Down
      magnitude: 0,
      color: AppColors.primaryAccent, // Action
      label: 'Exhaust',
    );
    thrustArrow.position = Vector2(rocket.size.x / 2, rocket.size.y);
    rocket.add(thrustArrow);

    reactionArrow = ForceArrow(
      direction: Vector2(0, -1), // Up
      magnitude: 0,
      color: AppColors.secondaryAccent, // Reaction
      label: 'Thrust',
    );
    reactionArrow.position = Vector2(rocket.size.x / 2, 0);
    rocket.add(reactionArrow);

    add(rocket);
  }

  void updateParameters(double mA, double mB, double bounce) {
    if (isPlaying) return;

    massA = mA;
    massB = mB;
    bounciness = bounce;

    boxA.mass = massA;
    boxA.size = Vector2.all(30.0 + (massA * 0.5));
    (boxA.children.firstWhere((c) => c is MassLabel) as MassLabel).mass = massA;

    boxB.mass = massB;
    boxB.size = Vector2.all(30.0 + (massB * 0.5));
    (boxB.children.firstWhere((c) => c is MassLabel) as MassLabel).mass = massB;

    boxB.position = startPosB.clone(); // Adjust position if size changes
  }

  void launch() {
    if (currentSceneType == Law3SceneType.collision) {
      boxA.velocity = Vector2(150, 0);
      boxB.velocity = Vector2(-150, 0);
    } else {
      rocket.velocity = Vector2(0, -200); // Fly up
      rocket.isThrusting = true;
      thrustArrow.magnitude = 50;
      reactionArrow.magnitude = 50;
    }
    isPlaying = true;
    collisionHandled = false;
    impulseArrowA.magnitude = 0;
    impulseArrowB.magnitude = 0;
  }

  void resetSimulation() {
    isPlaying = false;
    collisionHandled = false;

    boxA.position = startPosA.clone();
    boxA.velocity = Vector2.zero();
    boxB.position = startPosB.clone();
    boxB.velocity = Vector2.zero();
    impulseArrowA.magnitude = 0;
    impulseArrowB.magnitude = 0;

    rocket.position = Vector2(size.x / 2, size.y * 0.7);
    rocket.velocity = Vector2.zero();
    rocket.isThrusting = false;
    thrustArrow.magnitude = 0;
    reactionArrow.magnitude = 0;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!isPlaying) return;

    if (currentSceneType == Law3SceneType.collision && !collisionHandled) {
      if (boxA.toRect().overlaps(boxB.toRect())) {
        final vRel = boxB.velocity.x - boxA.velocity.x;
        final j = -(1 + bounciness) * vRel / ((1 / massA) + (1 / massB));

        final visualForceMag = j.abs() / 2;
        impulseArrowA.magnitude = visualForceMag;
        impulseArrowA.direction = (boxA.x < boxB.x)
            ? Vector2(-1, 0)
            : Vector2(1, 0);

        impulseArrowB.magnitude = visualForceMag;
        impulseArrowB.direction = (boxB.x > boxA.x)
            ? Vector2(1, 0)
            : Vector2(-1, 0);

        CollisionResolver.resolve1DCollision(
          posA: boxA.position,
          velA: boxA.velocity,
          massA: boxA.mass,
          posB: boxB.position,
          velB: boxB.velocity,
          massB: boxB.mass,
          restitution: bounciness,
        );

        // Visual Impact Effect
        final midX = (boxA.x + boxB.x) / 2 + 20; // Approx collision point
        add(
          ParticleFactory.createImpactBurst(
            position: Vector2(midX, boxA.y + 20),
            color: AppColors.primaryAccent,
          ),
        );

        // Audio Impact Effect
        try {
          FlameAudio.play('collision.wav');
        } catch (e) {
          debugPrint('Audio asset collision.wav not found, skipping sound.');
        }

        collisionHandled = true;

        Future.delayed(const Duration(seconds: 1), () {
          impulseArrowA.magnitude = 0;
          impulseArrowB.magnitude = 0;
        });
      }
    } else if (currentSceneType == Law3SceneType.rocket) {
      // Loop rocket vertically
      if (rocket.position.y < -rocket.size.y) {
        rocket.position.y = size.y;
      }
    }
  }
}

class LaneComponent extends PositionComponent {
  LaneComponent({required super.position, required super.size});
  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), Paint()..color = AppColors.gridLines);
  }
}

class MassLabel extends PositionComponent {
  double mass;
  MassLabel({required this.mass}) {
    position = Vector2(0, -20);
  }
  @override
  void render(Canvas canvas) {
    final painter = TextPainter(
      text: TextSpan(
        text: '${mass.toStringAsFixed(1)} kg',
        style: const TextStyle(
          color: AppColors.warning,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    painter.layout();
    painter.paint(canvas, Offset.zero);
  }
}

class RocketComponent extends PositionComponent {
  bool isThrusting = false;
  Vector2 velocity = Vector2.zero();

  RocketComponent({required super.position, required super.size});

  @override
  void update(double dt) {
    super.update(dt);
    if (isThrusting) {
      position.add(velocity * dt);

      // Add smoke particles
      parent?.add(
        ParticleFactory.createRocketSmoke(
          position: Vector2(position.x + size.x / 2, position.y + size.y),
          speed: 50.0,
        ),
      );
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Rocket body
    final paint = Paint()..color = const Color(0xFFE0E0FF);
    canvas.drawRRect(
      RRect.fromRectAndRadius(size.toRect(), const Radius.circular(20)),
      paint,
    );

    // Simple nose cone
    final path = Path()
      ..moveTo(size.x / 2, -20)
      ..lineTo(0, 0)
      ..lineTo(size.x, 0)
      ..close();
    canvas.drawPath(path, paint);

    // Thruster exhaust
    if (isThrusting) {
      final exhaustPaint = Paint()
        ..color = AppColors.primaryAccent.withOpacity(0.8)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(size.x / 2, size.y + 10), 10, exhaustPaint);
      canvas.drawCircle(Offset(size.x / 2, size.y + 25), 6, exhaustPaint);
    }
  }
}
