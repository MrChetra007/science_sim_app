import 'package:flame/game.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'piston_component.dart';
import 'molecule_system.dart';
import '../providers/gas_provider.dart';

class PistonGame extends FlameGame {
  final WidgetRef ref;
  late PistonComponent piston;
  late MoleculeSystem moleculeSystem;

  PistonGame(this.ref);

  @override
  Future<void> onLoad() async {
    final state = ref.read(gasProvider);

    moleculeSystem = MoleculeSystem(
      count: 35,
      temperature: state.temperature,
    );
    add(moleculeSystem);

    piston = PistonComponent(volume: state.volume);
    piston.size = Vector2(size.x, 15);
    add(piston);

    _updatePistonScale(state.volume);
  }

  void _updatePistonScale(double volume) {
    piston.size.x = size.x;
    piston.updateVolume(volume, size.y);
  }

  @override
  void update(double dt) {
    super.update(dt);
    final state = ref.read(gasProvider);

    _updatePistonScale(state.volume);
    moleculeSystem.updateTemperature(state.temperature);

    // Collision handling for molecules with the variable piston position
    for (final m in moleculeSystem.children.whereType<Molecule>()) {
        if (m.position.y < piston.position.y + 15) {
            m.position.y = piston.position.y + 16;
            m.velocity.y = m.velocity.y.abs(); // bounce down
        }
    }
  }
}
