import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../../components/physics_body.dart';
import '../../components/surface_component.dart';
import '../../components/force_arrow.dart';
import '../../components/data_hud.dart';
import '../../core/constants.dart';
import '../../physics/friction_model.dart';
import 'package:flame/components.dart';

class Law1Game extends FlameGame {
  late PhysicsBody puck;
  late SurfaceComponent surface;
  late ForceArrow velocityArrow;
  late ForceArrow frictionArrow;
  late DataHUD dataHud;

  SurfaceType currentSurface = SurfaceType.ice;
  bool isGravityOn = true;
  bool isPlaying = false;

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    // Setup surface
    surface = SurfaceComponent(
      surfaceType: currentSurface,
      position: Vector2(0, size.y * 0.5),
      size: Vector2(size.x, size.y * 0.5),
    );
    add(surface);

    // Setup puck
    puck = PhysicsBody(
      mass: 5.0,
      position: Vector2(50, size.y * 0.5 - 40),
      size: Vector2(40, 40),
    );
    add(puck);

    // Setup velocity arrow attached to puck
    velocityArrow = ForceArrow(
      direction: Vector2(1, 0),
      magnitude: 0,
      color: Colors.white,
      label: 'v',
    );
    velocityArrow.position = Vector2(puck.size.x / 2, puck.size.y / 2);
    puck.add(velocityArrow);

    // Setup friction arrow attached to puck
    frictionArrow = ForceArrow(
      direction: Vector2(-1, 0),
      magnitude: 0,
      color: AppColors.secondaryAccent,
      label: 'Ff',
    );
    frictionArrow.position = Vector2(puck.size.x / 2, puck.size.y / 2);
    puck.add(frictionArrow);

    // Setup HUD
    dataHud = DataHUD(target: puck, position: Vector2(20, 20));
    add(dataHud);
  }

  void launchPuck(double speed, SurfaceType type, bool gravity) {
    puck.position = Vector2(50, size.y * 0.5 - 40);
    puck.velocity = Vector2(speed * 20, 0); // Visual scaling
    puck.acceleration = Vector2.zero();
    currentSurface = type;
    surface.surfaceType = type;
    isGravityOn = gravity;
    isPlaying = true;
  }

  void updateSurface(SurfaceType type) {
    currentSurface = type;
    surface.surfaceType = type;
  }

  void resetPuck() {
    puck.position = Vector2(50, size.y * 0.5 - 40);
    puck.velocity = Vector2.zero();
    puck.acceleration = Vector2.zero();
    isPlaying = false;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isPlaying) {
      if (isGravityOn && puck.velocity.x > 0) {
        // F = -μ * m * g
        final frictionForceMag =
            surface.frictionCoefficient * puck.mass * PhysicsConstants.g;
        // Visual scaling for the force application
        puck.applyForce(Vector2(-frictionForceMag * 10, 0));
      }

      // Stop puck if speed is very low
      if (puck.velocity.x <= 0.5) {
        puck.velocity.x = 0;
        puck.acceleration.x = 0;
      }
    }

    // Update arrows corresponding to the actual vectors
    if (puck.velocity.x > 0) {
      velocityArrow.magnitude = puck.velocity.x / 2;

      if (isGravityOn) {
        frictionArrow.magnitude =
            (surface.frictionCoefficient * puck.mass * PhysicsConstants.g) * 2;
      } else {
        frictionArrow.magnitude = 0;
      }
    } else {
      velocityArrow.magnitude = 0;
      frictionArrow.magnitude = 0;
    }

    // Loop puck if it goes off screen
    if (puck.position.x > size.x) {
      puck.position.x = -puck.size.x;
    }
  }
}
