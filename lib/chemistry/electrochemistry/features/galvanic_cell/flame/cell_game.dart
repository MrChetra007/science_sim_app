import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import '../providers/galvanic_state.dart';
import 'electrode_components.dart';
import 'electron_flow_component.dart';
import 'ion_particle_system.dart';
import '../../../core/theme/app_colors.dart';

class CellGame extends FlameGame {
  GalvanicState state;
  AnodeComponent? anode;
  CathodeComponent? cathode;
  ElectronFlowComponent? electronFlow;
  IonParticleSystem? saltBridgeIons;

  CellGame({required this.state});

  @override
  Future<void> onLoad() async {
    final canvasSize = size;

    // 1. Setup Electrodes
    anode = AnodeComponent(
      position: Vector2(canvasSize.x * 0.2, canvasSize.y * 0.35),
      electrode: state.anode,
    );

    cathode = CathodeComponent(
      position: Vector2(canvasSize.x * 0.7, canvasSize.y * 0.35),
      electrode: state.cathode,
    );

    // 2. Setup Electron Flow (Anode Top -> Cathode Top)
    electronFlow = ElectronFlowComponent(
      from: Vector2(canvasSize.x * 0.24, canvasSize.y * 0.35),
      to:   Vector2(canvasSize.x * 0.74, canvasSize.y * 0.35),
    );
    electronFlow!.updateState(state.isSpontaneous, state.cellPotential);

    // 3. Setup Salt Bridge (Anode Side -> Cathode Side)
    saltBridgeIons = IonParticleSystem(
      start: Vector2(canvasSize.x * 0.40, canvasSize.y * 0.55),
      end:   Vector2(canvasSize.x * 0.60, canvasSize.y * 0.55),
    );
    saltBridgeIons!.updateState(state.isSpontaneous, state.cellPotential);

    if (saltBridgeIons != null && electronFlow != null && anode != null && cathode != null) {
      await addAll([saltBridgeIons!, electronFlow!, anode!, cathode!]);
    }
  }

  void updateState(GalvanicState newState) {
    state = newState;
    anode?.updateElectrode(state.anode);
    cathode?.updateElectrode(state.cathode);
    electronFlow?.updateState(state.isSpontaneous, state.cellPotential);
    saltBridgeIons?.updateState(state.isSpontaneous, state.cellPotential);
  }

  @override
  void render(Canvas canvas) {
    _drawBackground(canvas);
    super.render(canvas);
  }

  void _drawBackground(Canvas canvas) {
    final paint = Paint()
      ..color = AppColors.borderDefault.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw Wire
    final wirePath = Path()
      ..moveTo(size.x * 0.24, size.y * 0.35)
      ..lineTo(size.x * 0.24, size.y * 0.20)
      ..lineTo(size.x * 0.74, size.y * 0.20)
      ..lineTo(size.x * 0.74, size.y * 0.35);
    canvas.drawPath(wirePath, paint);

    // Draw Salt Bridge
    final bridgePath = Path()
      ..moveTo(size.x * 0.35, size.y * 0.55)
      ..lineTo(size.x * 0.35, size.y * 0.45)
      ..lineTo(size.x * 0.65, size.y * 0.45)
      ..lineTo(size.x * 0.65, size.y * 0.55);
    canvas.drawPath(bridgePath, paint..strokeWidth = 10.0);
  }
}
