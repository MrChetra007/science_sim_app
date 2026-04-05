import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class Molecule extends PositionComponent with HasGameReference {
  Vector2 velocity;
  double speed;

  Molecule({
    required Vector2 position,
    required this.velocity,
    required this.speed,
  }) : super(position: position, size: Vector2.all(6));

  @override
  void update(double dt) {
    position += velocity * speed * dt;

    // Bounce off left/right walls
    if (position.x < 0) {
      position.x = 0;
      velocity.x *= -1;
    } else if (position.x > game.size.x) {
      position.x = game.size.x;
      velocity.x *= -1;
    }

    // Bounce off top/bottom (bottom is fixed, top is piston)
    // Note: The piston position is managed by PistonGame/PistonComponent
    // But for simplicity, we'll bounce within the game size for now
    // and let PistonGame handle the specific piston bounce.
    if (position.y < 0) {
      position.y = 0;
      velocity.y *= -1;
    } else if (position.y > game.size.y) {
      position.y = game.size.y;
      velocity.y *= -1;
    }
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = AppColors.accentGas.withOpacity(0.8);
    canvas.drawCircle(Offset.zero, 3, paint);
  }
}

class MoleculeSystem extends Component with HasGameReference {
  final int count;
  double temperature;
  final Random _random = Random();

  MoleculeSystem({required this.count, required this.temperature});

  @override
  Future<void> onLoad() async {
    for (int i = 0; i < count; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      add(
        Molecule(
          position: Vector2(
            _random.nextDouble() * game.size.x,
            _random.nextDouble() * game.size.y,
          ),
          velocity: Vector2(cos(angle), sin(angle)),
          speed: _calculateSpeed(temperature),
        ),
      );
    }
  }

  double _calculateSpeed(double temp) {
    // Basic root-mean-square speed simulation: v ∝ √T
    return sqrt(temp) * 15.0;
  }

  void updateTemperature(double newTemp) {
    temperature = newTemp;
    for (final m in children.whereType<Molecule>()) {
      m.speed = _calculateSpeed(temperature);
    }
  }

  // Handle piston bounce
  void handlePistonBounce(double pistonY) {
    for (final m in children.whereType<Molecule>()) {
        if (m.position.y < pistonY) {
            m.position.y = pistonY;
            m.velocity.y = m.velocity.y.abs(); // bounce down
        }
    }
  }
}
