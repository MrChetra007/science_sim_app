import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';

class _Particle {
  Vector2 pos;
  Vector2 vel;
  double lifetime;
  double maxLifetime;
  double radius;

  _Particle({
    required this.pos,
    required this.vel,
    required this.lifetime,
  })  : maxLifetime = lifetime,
        radius = 1.0 + Random().nextDouble() * 2.0;

  bool get isDead => lifetime <= 0;
  double get opacity => (lifetime / maxLifetime).clamp(0.0, 1.0);

  void update(double dt) {
    pos += vel * dt;
    vel.y += 200 * dt; // gravity
    lifetime -= dt;
  }
}

class SplashParticles extends Component {
  final Vector2 position;
  final List<_Particle> _particles = [];

  SplashParticles({required this.position}) {
    final r = Random();
    for (int i = 0; i < 12; i++) {
      _particles.add(_Particle(
        pos: position.clone(),
        vel: Vector2(
          (r.nextDouble() - 0.5) * 150,
          -r.nextDouble() * 100 - 20,
        ),
        lifetime: 0.3 + r.nextDouble() * 0.3,
      ));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (final p in _particles) {
      p.update(dt);
    }
    _particles.removeWhere((p) => p.isDead);
    if (_particles.isEmpty) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    for (final p in _particles) {
      final paint = Paint()
        ..color = const Color(0xFF80C0FF).withOpacity(p.opacity);
      canvas.drawCircle(p.pos.toOffset(), p.radius, paint);
    }
  }
}
