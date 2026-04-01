import 'dart:math' as math;

class ProjectileObject {
  final String id;
  final String name;
  final double mass; // kg
  final double dragCoefficient; // Cd (dimensionless)
  final double radius; // m
  final String emoji;
  final int colorValue; // for rendering

  const ProjectileObject({
    required this.id,
    required this.name,
    required this.mass,
    required this.dragCoefficient,
    required this.radius,
    required this.emoji,
    required this.colorValue,
  });

  /// Cross-sectional area = π * r²
  double get crossSectionalArea => math.pi * radius * radius;

  /// Visual radius on screen (clamped to a sensible range)
  double get visualRadius => (radius * 10).clamp(4.0, 20.0);
}
