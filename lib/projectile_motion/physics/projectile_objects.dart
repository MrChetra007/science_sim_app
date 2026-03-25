import '../models/projectile_object.dart';

const List<ProjectileObject> projectileObjects = [
  ProjectileObject(
    id: 'cannonball',
    name: 'Cannonball',
    mass: 4.0,
    dragCoefficient: 0.47,
    radius: 0.0891,
    emoji: '💣',
    colorValue: 0xFF4A4A4A,
  ),
  ProjectileObject(
    id: 'golfball',
    name: 'Golf Ball',
    mass: 0.05,
    dragCoefficient: 0.25,
    radius: 0.02134,
    emoji: '⛳',
    colorValue: 0xFFFFFFFF,
  ),
  ProjectileObject(
    id: 'baseball',
    name: 'Baseball',
    mass: 0.142,
    dragCoefficient: 0.35,
    radius: 0.0365,
    emoji: '⚾',
    colorValue: 0xFFF5F5DC,
  ),
  ProjectileObject(
    id: 'bowlingball',
    name: 'Bowling Ball',
    mass: 6.35,
    dragCoefficient: 0.47,
    radius: 0.108,
    emoji: '🎳',
    colorValue: 0xFF1A1A2E,
  ),
  ProjectileObject(
    id: 'pumpkin',
    name: 'Pumpkin',
    mass: 5.0,
    dragCoefficient: 0.47,
    radius: 0.15,
    emoji: '🎃',
    colorValue: 0xFFFF6B35,
  ),
];

ProjectileObject objectById(String id) => projectileObjects.firstWhere(
      (o) => o.id == id,
      orElse: () => projectileObjects.first,
    );
