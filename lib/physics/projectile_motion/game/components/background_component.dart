import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../projectile_game.dart';

enum PlanetType { earth, moon, mars, jupiter, custom }

class BackgroundComponent extends Component
    with HasGameReference<ProjectileGame> {
  PlanetType _currentPlanet = PlanetType.earth;

  void updatePlanet(String gravityId) {
    switch (gravityId) {
      case 'earth':
        _currentPlanet = PlanetType.earth;
      case 'moon':
        _currentPlanet = PlanetType.moon;
      case 'mars':
        _currentPlanet = PlanetType.mars;
      case 'jupiter':
        _currentPlanet = PlanetType.jupiter;
      default:
        _currentPlanet = PlanetType.custom;
    }
  }

  @override
  void render(Canvas canvas) {
    final size = game.size;
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);

    switch (_currentPlanet) {
      case PlanetType.earth:
        _drawEarth(canvas, rect);
      case PlanetType.moon:
        _drawMoon(canvas, rect);
      case PlanetType.mars:
        _drawMars(canvas, rect);
      case PlanetType.jupiter:
        _drawJupiter(canvas, rect);
      case PlanetType.custom:
        _drawCustom(canvas, rect);
    }
  }

  void _drawEarth(Canvas canvas, Rect rect) {
    // Blue-ish sky gradient
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF0D1B2A),
          const Color(0xFF1B263B),
          const Color(0xFF415A77)
        ],
      ).createShader(rect);
    canvas.drawRect(rect, paint);

    // Subtle sun glow
    canvas.drawCircle(
      Offset(rect.width * 0.8, rect.height * 0.2),
      100,
      Paint()
        ..color = const Color(0x11E0E1DD)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50),
    );
  }

  void _drawMoon(Canvas canvas, Rect rect) {
    // Deep dark sky
    canvas.drawRect(rect, Paint()..color = const Color(0xFF000814));

    // Stars
    final starPaint = Paint()..color = const Color(0xAAFFFFFF);
    final offsets = [
      Offset(rect.width * 0.2, rect.height * 0.1),
      Offset(rect.width * 0.5, rect.height * 0.15),
      Offset(rect.width * 0.8, rect.height * 0.05),
      Offset(rect.width * 0.1, rect.height * 0.4),
      Offset(rect.width * 0.9, rect.height * 0.3),
      Offset(rect.width * 0.4, rect.height * 0.45),
      Offset(rect.width * 0.7, rect.height * 0.35),
    ];
    for (final offset in offsets) {
      canvas.drawCircle(offset, 1.2, starPaint);
    }

    // Earth hanging in the sky
    final earthOffset = Offset(rect.width * 0.75, rect.height * 0.2);
    canvas.drawCircle(
      earthOffset,
      30,
      Paint()
        ..shader = RadialGradient(
          colors: [const Color(0xFF0077B6), const Color(0xFF03045E)],
        ).createShader(Rect.fromCircle(center: earthOffset, radius: 30)),
    );
  }

  void _drawMars(Canvas canvas, Rect rect) {
    // Reddish dusty sky
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF3D1308),
          const Color(0xFF912F11),
          const Color(0xFFBD4522)
        ],
      ).createShader(rect);
    canvas.drawRect(rect, paint);

    // Haze layer
    canvas.drawRect(
      Rect.fromLTWH(0, rect.height * 0.6, rect.width, rect.height * 0.4),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, const Color(0x44FF9E00)],
        ).createShader(
            Rect.fromLTWH(0, rect.height * 0.6, rect.width, rect.height * 0.4)),
    );
  }

  void _drawJupiter(Canvas canvas, Rect rect) {
    // Atmospheric swirls
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF24140E),
          const Color(0xFF633D2E),
          const Color(0xFFD97706)
        ],
      ).createShader(rect);
    canvas.drawRect(rect, paint);

    // Stylized bands
    final bandPaint = Paint()..color = const Color(0x11FFFFFF);
    canvas.drawRect(
        Rect.fromLTWH(0, rect.height * 0.3, rect.width, 20), bandPaint);
    canvas.drawRect(
        Rect.fromLTWH(0, rect.height * 0.5, rect.width, 40), bandPaint);
    canvas.drawRect(
        Rect.fromLTWH(0, rect.height * 0.7, rect.width, 15), bandPaint);
  }

  void _drawCustom(Canvas canvas, Rect rect) {
    // Simple dark neutral gradient
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [const Color(0xFF101010), const Color(0xFF202020)],
      ).createShader(rect);
    canvas.drawRect(rect, paint);
  }
}
