import 'package:flame/components.dart';

class ForceIntegrator {
  static void eulerIntegration({
    required Vector2 position,
    required Vector2 velocity,
    required Vector2 netForce,
    required double mass,
    required double dt,
  }) {
    if (mass <= 0) return;
    
    // a = F / m
    final acceleration = netForce / mass;
    
    // v += a * dt
    velocity.add(acceleration * dt);
    
    // pos += v * dt
    position.add(velocity * dt);
  }
}
