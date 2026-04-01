import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../components/physics_body.dart';
import '../../components/force_arrow.dart';
import '../../components/data_hud.dart';
import '../../core/constants.dart';

class Law2Game extends FlameGame {
  late PhysicsBody boxA;
  late PhysicsBody boxB;
  late ForceArrow forceArrowA;
  late ForceArrow forceArrowB;
  late DataHUD hudA;
  late DataHUD hudB;

  double massA = 10.0;
  double massB = 30.0;
  double appliedForce = 50.0;
  bool isPlaying = false;

  final Vector2 startPosA = Vector2(50, 100);
  final Vector2 startPosB = Vector2(50, 300);

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    // Add lanes and finish line
    add(LaneComponent(position: Vector2(0, 150), size: Vector2(size.x, 2)));
    add(LaneComponent(position: Vector2(0, 350), size: Vector2(size.x, 2)));

    final finishLineX = size.x - 100;
    add(
      FinishLineComponent(
        position: Vector2(finishLineX, 50),
        size: Vector2(4, 350),
      ),
    );

    _setupBoxA();
    _setupBoxB();
  }

  void _setupBoxA() {
    double sizeA = 30.0 + (massA * 0.5); // Visual scaling
    boxA = PhysicsBody(
      mass: massA,
      position: startPosA.clone(),
      size: Vector2.all(sizeA),
    );

    forceArrowA = ForceArrow(
      direction: Vector2(1, 0),
      magnitude: 0,
      color: AppColors.primaryAccent,
      label: 'F',
    );
    forceArrowA.position = Vector2(boxA.size.x, boxA.size.y / 2);
    boxA.add(forceArrowA);

    boxA.add(MassLabel(mass: massA));

    hudA = DataHUD(target: boxA, position: Vector2(20, 20));
    add(boxA);
    add(hudA);
  }

  void _setupBoxB() {
    double sizeB = 30.0 + (massB * 0.5);
    boxB = PhysicsBody(
      mass: massB,
      position: startPosB.clone(),
      size: Vector2.all(sizeB),
    );

    forceArrowB = ForceArrow(
      direction: Vector2(1, 0),
      magnitude: 0,
      color: AppColors.primaryAccent,
      label: 'F',
    );
    forceArrowB.position = Vector2(boxB.size.x, boxB.size.y / 2);
    boxB.add(forceArrowB);

    boxB.add(MassLabel(mass: massB));

    hudB = DataHUD(target: boxB, position: Vector2(20, 220));
    add(boxB);
    add(hudB);
  }

  void updateParameters(double force, double m1, double m2) {
    if (isPlaying) return;

    appliedForce = force;
    massA = m1;
    massB = m2;

    boxA.mass = massA;
    boxA.size = Vector2.all(30.0 + (massA * 0.5));
    forceArrowA.position = Vector2(boxA.size.x, boxA.size.y / 2);
    (boxA.children.firstWhere((c) => c is MassLabel) as MassLabel).mass = massA;

    boxB.mass = massB;
    boxB.size = Vector2.all(30.0 + (massB * 0.5));
    forceArrowB.position = Vector2(boxB.size.x, boxB.size.y / 2);
    (boxB.children.firstWhere((c) => c is MassLabel) as MassLabel).mass = massB;
  }

  void applyForce(double force) {
    appliedForce = force;
    isPlaying = true;
    forceArrowA.magnitude = force;
    forceArrowB.magnitude = force;
  }

  void resetSimulation() {
    isPlaying = false;
    boxA.position = startPosA.clone();
    boxA.velocity = Vector2.zero();
    boxB.position = startPosB.clone();
    boxB.velocity = Vector2.zero();
    forceArrowA.magnitude = 0;
    forceArrowB.magnitude = 0;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isPlaying) {
      // Apply constant force to both boxes
      boxA.applyForce(
        Vector2(appliedForce * 10, 0),
      ); // Scaled up for visual speed
      boxB.applyForce(Vector2(appliedForce * 10, 0));
    }

    // Loop objects when they go off screen
    if (boxA.position.x > size.x) boxA.position.x = -boxA.size.x;
    if (boxB.position.x > size.x) boxB.position.x = -boxB.size.x;
  }
}

class LaneComponent extends PositionComponent {
  LaneComponent({required super.position, required super.size});

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), Paint()..color = AppColors.gridLines);
  }
}

class FinishLineComponent extends PositionComponent {
  FinishLineComponent({required super.position, required super.size});

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = AppColors.secondaryAccent.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    // Draw checkered pattern
    for (int i = 0; i < size.y / 20; i++) {
      if (i % 2 == 0) {
        canvas.drawRect(Rect.fromLTWH(0, i * 20.0, size.x, 20), paint);
      }
    }
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
