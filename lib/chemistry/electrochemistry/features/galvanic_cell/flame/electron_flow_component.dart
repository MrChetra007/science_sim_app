import 'dart:ui';
import 'package:flame/components.dart';
import '../../../core/theme/app_colors.dart';

class ElectronFlowComponent extends Component {
  final Vector2 from;
  final Vector2 to;
  bool _active = true;
  double _voltage = 1.10;

  final List<_Electron> _electrons = [];
  double _spawnTimer = 0.0;
  
  // Dynamic spawn interval based on voltage
  double get _spawnInterval => (0.5 / (_voltage.abs() + 0.1)).clamp(0.05, 0.4);
  double get _electronSpeed => (0.6 * (_voltage.abs() + 0.2)).clamp(0.2, 2.5);

  ElectronFlowComponent({required this.from, required this.to});

  void updateState(bool active, double voltage) {
    _active = active;
    _voltage = voltage;
    if (!_active) _electrons.clear();
  }

  @override
  void update(double dt) {
    if (!_active) return;

    _spawnTimer += dt;
    if (_spawnTimer >= _spawnInterval) {
      _spawnTimer = 0;
      _electrons.add(_Electron(
        pos: from.clone(), 
        target: to.clone(),
        speed: _electronSpeed,
      ));
    }

    for (final e in _electrons) {
      e.update(dt);
    }
    _electrons.removeWhere((e) => e.isDone);
  }

  @override
  void render(Canvas canvas) {
    if (!_active) return;
    
    for (final e in _electrons) {
      canvas.drawCircle(
        e.pos.toOffset(),
        3.0,
        Paint()..color = AppColors.accentElectric.withValues(alpha: e.opacity),
      );
    }
  }
}

class _Electron {
  Vector2 pos;
  final Vector2 target;
  final double speed;
  double _progress = 0.0;

  _Electron({required this.pos, required this.target, required this.speed});

  bool get isDone => _progress >= 1.0;
  double get opacity => (1.0 - (_progress - 0.85).clamp(0, 0.15) / 0.15);

  void update(double dt) {
    _progress = (_progress + dt * speed).clamp(0.0, 1.0);
    
    // Smooth interpolation
    pos.setFrom(pos + (target - pos) * (dt * speed * 4).clamp(0, 1));
  }
}
