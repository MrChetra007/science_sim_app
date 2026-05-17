import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flame/game.dart' hide Game;
import '../game/induction_game.dart';
import '../providers/sim_provider.dart';
import 'control_panel.dart';
import 'info_panel.dart';

class SimScreen extends ConsumerStatefulWidget {
  const SimScreen({super.key});

  @override
  ConsumerState<SimScreen> createState() => _SimScreenState();
}

class _SimScreenState extends ConsumerState<SimScreen> {
  InductionGame? _game;
  bool _isDragging = false;

  void _onTick(double dt) {
    ref.read(simProvider.notifier).tick(dt);
    final state = ref.read(simProvider);

    final h = _game!.size.y;
    final coilCenterY = h * 0.55;
    final magnetWorldY = coilCenterY + state.magnetY * 120;

    _game!.magnet.position.y = magnetWorldY;
    _game!.magnet.updateEmf(state.emf);
    _game!.magnet.setIsDragging(_isDragging);

    final fluxLocalY = magnetWorldY - _game!.fluxLines.position.y;
    _game!.fluxLines.updateFlux(state.flux, fluxLocalY);

    _game!.currentArrow.updateEMF(state.emf);
    _game!.coil.turns = state.turns;
    _game!.coil.tick(dt, state.emf);
    _game!.oscilloscope.updateData(
      state.oscHistory,
      state.fluxHistory,
      state.emf,
      state.flux,
    );
  }

  void _onDragStart(DragStartDetails details) {
    _isDragging = true;
    ref.read(simProvider.notifier).startManual();
    _game!.magnet.setIsDragging(true);
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final magnetWorldY = _game!.magnet.position.y + details.delta.dy;
    final h = _game!.size.y;
    final coilCenterY = h * 0.55;
    final newMagnetY = (magnetWorldY - coilCenterY) / 120;
    ref.read(simProvider.notifier).setManualPosition(newMagnetY);
  }

  void _onDragEnd(DragEndDetails details) {
    _isDragging = false;
    _game!.magnet.setIsDragging(false);
    ref.read(simProvider.notifier).resumeAuto();
  }

  @override
  Widget build(BuildContext context) {
    _game ??= InductionGame(
      onTick: _onTick,
      onMagnetDrag: (deltaY) {
        final magnetWorldY = _game!.magnet.position.y + deltaY;
        final h = _game!.size.y;
        final coilCenterY = h * 0.55;
        final newMagnetY = (magnetWorldY - coilCenterY) / 120;
        ref.read(simProvider.notifier).setManualPosition(newMagnetY);
      },
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onPanStart: _onDragStart,
                    onPanUpdate: _onDragUpdate,
                    onPanEnd: _onDragEnd,
                    child: GameWidget(game: _game!),
                  ),
                ),
                const ControlPanel(),
                const InfoPanel(),
              ],
            ),
            Positioned(
              top: 4,
              left: 4,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white54, size: 22),
                onPressed: () => Navigator.pop(context),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black38,
                  padding: const EdgeInsets.all(8),
                  minimumSize: const Size(36, 36),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
