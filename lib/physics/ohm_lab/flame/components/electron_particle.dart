import 'dart:ui';
import 'package:flame/components.dart';

class ElectronParticle extends Component {
  final List<Vector2> pathPoints;
  double speed = 1.0;
  final List<_Electron> _electrons = [];
  static const int electronCount = 20;

  ElectronParticle({required this.pathPoints});

  @override
  void onMount() {
    super.onMount();
    for (int i = 0; i < electronCount; i++) {
      _electrons.add(_Electron(
        pathOffset: i / electronCount,
        color: const Color(0xFF00FF88),
      ));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (final e in _electrons) {
      e.pathOffset = (e.pathOffset + speed * dt * 0.1) % 1.0;
      e.position = _interpolatePath(e.pathOffset);
    }
  }

  @override
  void render(Canvas canvas) {
    for (final e in _electrons) {
      final paint = Paint()
        ..color = e.color
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
      canvas.drawCircle(e.position.toOffset(), 4.0, paint);
    }
  }

  void updateSpeed(double current) {
    speed = current.clamp(0.05, 3.0);
    final color = current > 1.0
        ? const Color(0xFFFF4455)
        : current > 0.2
            ? const Color(0xFFF5A623)
            : const Color(0xFF00FF88);
    for (final e in _electrons) {
      e.color = color;
    }
  }

  Vector2 _interpolatePath(double t) {
    if (pathPoints.isEmpty) return Vector2.zero();
    
    // Simplified: treat path as a loop of segments
    int numSegments = pathPoints.length;
    double segmentT = t * numSegments;
    int index = segmentT.floor() % numSegments;
    double localT = segmentT - segmentT.floor();
    
    Vector2 p1 = pathPoints[index];
    Vector2 p2 = pathPoints[(index + 1) % numSegments];
    
    return p1 + (p2 - p1) * localT;
  }
}

class _Electron {
  double pathOffset;
  Color color;
  Vector2 position = Vector2.zero();

  _Electron({required this.pathOffset, required this.color});
}
