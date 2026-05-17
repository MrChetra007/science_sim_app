import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'components/magnet_component.dart';
import 'components/coil_component.dart';
import 'components/oscilloscope_component.dart';
import 'components/flux_line_component.dart';
import 'components/current_arrow_component.dart';

class InductionGame extends FlameGame {
  final void Function(double dt) onTick;

  late final MagnetComponent magnet;
  late final CoilComponent coil;
  late final FluxLineComponent fluxLines;
  late final CurrentArrowComponent currentArrow;
  late final OscilloscopeComponent oscilloscope;

  InductionGame({
    required this.onTick,
    required void Function(double deltaY) onMagnetDrag,
  }) : _onMagnetDrag = onMagnetDrag;

  final void Function(double deltaY) _onMagnetDrag;

  @override
  Future<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.topLeft;

    final w = size.x;
    final h = size.y;
    final coilCenterY = h * 0.55;

    oscilloscope = OscilloscopeComponent()
      ..position = Vector2(0, 0)
      ..size = Vector2(w, h * 0.3);

    fluxLines = FluxLineComponent()
      ..position = Vector2(0, coilCenterY - 80)
      ..size = Vector2(w, 160);

    coil = CoilComponent(turns: 10)
      ..position = Vector2(w / 2, coilCenterY)
      ..size = Vector2(w * 0.7, 110);

    currentArrow = CurrentArrowComponent()
      ..position = Vector2(w / 2, coilCenterY)
      ..size = Vector2(w * 0.7, 110);

    magnet = MagnetComponent(
      onDragStartCallback: null,
      onDragUpdateCallback: _onMagnetDrag,
      onDragEndCallback: null,
    )
      ..position = Vector2(w / 2, coilCenterY)
      ..size = Vector2(60, 100);

    await addAll([
      fluxLines,
      coil,
      currentArrow,
      magnet,
      oscilloscope,
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    onTick(dt);
  }
}
