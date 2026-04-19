import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../physics/force_integrator.dart';

class PhysicsBody extends PositionComponent {
  double mass;
  Vector2 velocity;
  Vector2 acceleration;
  Vector2 netForce;
  Color color;

  // Trail settings
  final List<Vector2> _trail = [];
  static const int _maxTrailPoints = 15;
  static const double _trailInterval = 0.05;
  double _trailTimer = 0;

  PhysicsBody({
    required this.mass,
    this.color = const Color(0xFFE0E0FF),
    super.position,
    super.size,
  })  : velocity = Vector2.zero(),
        acceleration = Vector2.zero(),
        netForce = Vector2.zero();

  void applyForce(Vector2 force) {
    netForce.add(force);
  }

  @override
  void update(double dt) {
    final oldPos = position.clone();
    super.update(dt);
    
    ForceIntegrator.eulerIntegration(
      position: position,
      velocity: velocity,
      netForce: netForce,
      mass: mass,
      dt: dt,
    );
    
    acceleration = netForce / mass;
    netForce.setZero();

    // Update trail
    _trailTimer += dt;
    if (_trailTimer >= _trailInterval) {
      _trailTimer = 0;
      
      // Clear trail if we jumped (screen loop)
      if (position.distanceTo(oldPos) > size.x * 2) {
        _trail.clear();
      }

      _trail.add(position.clone());
      if (_trail.length > _maxTrailPoints) {
        _trail.removeAt(0);
      }
    }
  }

  @override
  void render(Canvas canvas) {
    _renderTrail(canvas);
    _render3DBox(canvas);
  }

  void _renderTrail(Canvas canvas) {
    for (int i = 0; i < _trail.length; i++) {
      final point = _trail[i];
      // Calculate opacity and scaling factor
      final progress = i / _maxTrailPoints;
      final opacity = progress * 0.4;
      if (opacity <= 0) continue;

      final trailPaint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.fill;
      
      // Draw trailing rectangles that shrink and fade
      final trailSize = size * (0.5 + 0.5 * progress);
      final offset = (point - position).toOffset();
      
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(offset.dx, offset.dy, trailSize.x, trailSize.y),
          const Radius.circular(4),
        ),
        trailPaint,
      );
    }
  }

  void _render3DBox(Canvas canvas) {
    final rect = size.toRect();
    const depth = 6.0;

    // 1. Right side (shadow)
    final shadowPaint = Paint()..color = _adjustColor(color, -0.2);
    final shadowPath = Path()
      ..moveTo(rect.right, rect.top)
      ..lineTo(rect.right + depth, rect.top - depth)
      ..lineTo(rect.right + depth, rect.bottom - depth)
      ..lineTo(rect.right, rect.bottom)
      ..close();
    canvas.drawPath(shadowPath, shadowPaint);

    // 2. Top side (highlight)
    final highlightPaint = Paint()..color = _adjustColor(color, 0.2);
    final highlightPath = Path()
      ..moveTo(rect.left, rect.top)
      ..lineTo(rect.left + depth, rect.top - depth)
      ..lineTo(rect.right + depth, rect.top - depth)
      ..lineTo(rect.right, rect.top)
      ..close();
    canvas.drawPath(highlightPath, highlightPaint);

    // 3. Front face (main)
    final frontPaint = Paint()..color = color;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      frontPaint,
    );

    // 4. Glossy highlight overlay on front
    final glossPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.3),
          Colors.white.withOpacity(0.0),
        ],
      ).createShader(rect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(4)),
      glossPaint,
    );
  }

  Color _adjustColor(Color c, double amount) {
    final hsl = HSLColor.fromColor(c);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }
}
