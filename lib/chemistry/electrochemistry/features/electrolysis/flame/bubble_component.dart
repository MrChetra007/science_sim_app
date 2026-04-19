import 'dart:ui';
import 'package:flame/components.dart';

class BubbleComponent extends Component {
  Vector2 position;
  final Color color;
  final double speed;
  final double _lifetime;
  double _elapsed = 0.0;
  double _radius;

  BubbleComponent({
    required this.position,
    required this.color,
    this.speed = 40.0,
    double lifetime = 2.0,
    double radius = 4.0,
  })  : _lifetime = lifetime,
        _radius = radius;

  bool get isDead => _elapsed >= _lifetime;

  @override
  void update(double dt) {
    _elapsed += dt;
    position.y -= dt * speed;
    
    // Wiggle effect
    position.x += (dt * 15.0) * (position.y % 10 < 5 ? 1 : -1);
    
    _radius = (_radius - dt * 0.8).clamp(1.0, 10.0);
  }

  @override
  void render(Canvas canvas) {
    final opacity = (1.0 - _elapsed / _lifetime).clamp(0.0, 1.0);
    canvas.drawCircle(
      position.toOffset(),
      _radius,
      Paint()
        ..color = color.withValues(alpha: opacity * 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
  }
}
