import 'package:flame/game.dart';
import 'components/wire_component.dart';
import 'components/battery_component.dart';
import 'components/resistor_component.dart';
import 'components/ammeter_component.dart';
import 'components/electron_particle.dart';

class CircuitGame extends FlameGame {
  late WireComponent topWire, bottomWire, leftWire, rightWire;
  late BatteryComponent battery;
  late ResistorComponent resistor;
  late AmmeterComponent ammeter;
  late ElectronParticle electronParticles;

  double voltage = 12.0;
  double resistance = 100.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Circuit rectangle coordinates
    final left = size.x * 0.15;
    final top = size.y * 0.25;
    final right = size.x * 0.85;
    final bottom = size.y * 0.75;
    
    final topLeft = Vector2(left, top);
    final topRight = Vector2(right, top);
    final bottomRight = Vector2(right, bottom);
    final bottomLeft = Vector2(left, bottom);

    // Wires
    topWire = WireComponent(start: topLeft, end: topRight);
    rightWire = WireComponent(start: topRight, end: bottomRight);
    bottomWire = WireComponent(start: bottomRight, end: bottomLeft);
    leftWire = WireComponent(start: bottomLeft, end: topLeft);

    add(topWire);
    add(rightWire);
    add(bottomWire);
    add(leftWire);

    // Battery on left wire
    battery = BatteryComponent(
      position: Vector2(left, (top + bottom) / 2),
      size: Vector2(60, 80),
    );
    add(battery);

    // Resistor on top wire
    resistor = ResistorComponent(
      position: Vector2((left + right) / 2, top),
      size: Vector2(100, 40),
    );
    add(resistor);

    // Ammeter on right wire
    ammeter = AmmeterComponent(
      position: Vector2(right, (top + bottom) / 2),
      size: Vector2(60, 60),
    );
    add(ammeter);

    // Electrons
    electronParticles = ElectronParticle(pathPoints: [
      topLeft,
      topRight,
      bottomRight,
      bottomLeft,
    ]);
    add(electronParticles);
    
    updateValues(voltage, resistance);
  }

  double _current = 0;
  final _random = Vector2.zero();

  @override
  void update(double dt) {
    super.update(dt);
    if (_current > 2.0) {
      // Manual shake/jitter effect
      _random.setValues(
        (0.5 - (DateTime.now().millisecond % 100) / 100) * 4,
        (0.5 - (DateTime.now().microsecond % 100) / 100) * 4,
      );
      camera.viewfinder.position = _random;
    } else {
      camera.viewfinder.position = Vector2.zero();
    }
  }

  void updateValues(double v, double r) {
    voltage = v;
    resistance = r;
    _current = v / r;

    if (!isLoaded) return;
    
    electronParticles.updateSpeed(_current);
    topWire.setCurrentLevel(_current);
    rightWire.setCurrentLevel(_current);
    bottomWire.setCurrentLevel(_current);
    leftWire.setCurrentLevel(_current);
  }
}
