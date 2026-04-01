import 'package:flame/components.dart';

class CollisionResolver {
  static void resolve1DCollision({
    required Vector2 posA,
    required Vector2 velA,
    required double massA,
    required Vector2 posB,
    required Vector2 velB,
    required double massB,
    required double restitution, // 0 = inelastic, 1 = perfectly elastic
  }) {
    // Relative velocity
    final vRel = velB.x - velA.x;

    // Check if separating
    if (vRel > 0) return;

    // J = -(1 + e) * v_rel / (1/mA + 1/mB)
    final j = -(1 + restitution) * vRel / ((1 / massA) + (1 / massB));

    // Apply impulses
    velA.x -= j / massA; // Object A moves left or slows down
    velB.x += j / massB; // Object B moves right or speeds up
  }
}
