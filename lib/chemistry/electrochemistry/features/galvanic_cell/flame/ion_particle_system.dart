import 'dart:ui';
import 'package:flame/components.dart';
import '../../../core/theme/app_colors.dart';

class IonParticleSystem extends Component {
  final Vector2 start;
  final Vector2 end;
  bool _active = true;
  double _voltage = 1.10;
  
  final List<_Ion> _ions = [];
  double _timer = 0.0;
  
  double get _spawnInterval => (1.2 / (_voltage.abs() + 0.1)).clamp(0.1, 0.8);
  double get _ionSpeed => (0.3 * (_voltage.abs() + 0.2)).clamp(0.1, 1.2);

  IonParticleSystem({required this.start, required this.end});

  void updateState(bool active, double voltage) {
    _active = active;
    _voltage = voltage;
    if (!_active) _ions.clear();
  }

  @override
  void update(double dt) {
    if (!_active) return;

    _timer += dt;
    if (_timer > _spawnInterval) {
      _timer = 0;
      // Cation (Red-orange) moves toward cathode
      _ions.add(_Ion(
        pos: start.clone(), 
        target: end.clone(), 
        color: AppColors.accentAmber, 
        speed: _ionSpeed
      ));
      // Anion (Blue) moves toward anode
      _ions.add(_Ion(
        pos: end.clone(), 
        target: start.clone(), 
        color: AppColors.accentElectric, 
        speed: _ionSpeed
      ));
    }

    for (final ion in _ions) {
      ion.update(dt);
    }
    _ions.removeWhere((ion) => ion.isDone);
  }

  @override
  void render(Canvas canvas) {
    if (!_active) return;
    
    for (final ion in _ions) {
      canvas.drawCircle(
        ion.pos.toOffset(),
        2.5,
        Paint()..color = ion.color.withValues(alpha: ion.opacity),
      );
    }
  }
}

class _Ion {
  Vector2 pos;
  final Vector2 target;
  final Color color;
  final double speed;
  double _progress = 0.0;

  _Ion({required this.pos, required this.target, required this.color, required this.speed});

  bool get isDone => _progress >= 1.0;
  double get opacity => (1.0 - (_progress - 0.75).clamp(0, 0.25) / 0.25);

  void update(double dt) {
    _progress = (_progress + dt * speed).clamp(0.0, 1.0);
    pos.setFrom(pos + (target - pos) * (dt * speed * 4).clamp(0, 1));
  }
}
