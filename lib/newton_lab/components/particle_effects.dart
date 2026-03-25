import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ParticleFactory {
  /// Creates a smoke particle effect for the rocket
  static ParticleSystemComponent createRocketSmoke({
    required Vector2 position,
    double speed = 100,
  }) {
    final random = Random();
    return ParticleSystemComponent(
      particle: Particle.generate(
        count: 3,
        lifespan: 0.8,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(random.nextDouble() * 20 - 10, 10),
          speed: Vector2(random.nextDouble() * 10 - 5, speed),
          position: position.clone(),
          child: CircleParticle(
            radius: 2.0 + random.nextDouble() * 3.0,
            paint: Paint()..color = Colors.grey.withOpacity(0.3),
          ),
        ),
      ),
    );
  }

  /// Creates a burst impact effect for collisions
  static ParticleSystemComponent createImpactBurst({
    required Vector2 position,
    required Color color,
  }) {
    final random = Random();
    return ParticleSystemComponent(
      particle: Particle.generate(
        count: 12,
        lifespan: 0.4,
        generator: (i) {
          final angle = random.nextDouble() * 2 * pi;
          final force = random.nextDouble() * 120 + 40;
          return AcceleratedParticle(
            acceleration: Vector2.zero(),
            speed: Vector2(cos(angle) * force, sin(angle) * force),
            position: position.clone(),
            child: CircleParticle(
              radius: 1.0 + random.nextDouble() * 2.0,
              paint: Paint()..color = color.withOpacity(0.8),
            ),
          );
        },
      ),
    );
  }
}
