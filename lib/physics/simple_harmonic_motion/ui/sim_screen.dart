import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../game/shm_game.dart';
import '../providers/sim_provider.dart';
import '../../../l10n/generated/app_localizations.dart';
import 'control_panel.dart';
import 'info_panel.dart';

class SimScreen extends ConsumerStatefulWidget {
  final SimMode initialMode;

  const SimScreen({super.key, this.initialMode = SimMode.spring});

  @override
  ConsumerState<SimScreen> createState() => _SimScreenState();
}

class _SimScreenState extends ConsumerState<SimScreen> with SingleTickerProviderStateMixin {
  late SHMGame _game;
  late Ticker _syncTicker;

  @override
  void initState() {
    super.initState();
    _game = SHMGame(mode: widget.initialMode);
    _syncTicker = createTicker(_onTick);
    _syncTicker.start();
  }

  @override
  void dispose() {
    _syncTicker.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    if (!mounted) return;
    ref.read(simProvider.notifier).syncFromGame(_game.state);
  }

  void _recreateGame(SimMode mode) {
    _game = SHMGame(mode: mode);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(simProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(state.mode == SimMode.spring ? l10n.shmSpringMode : l10n.shmPendulumMode),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          GameWidget(game: _game),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const InfoPanel(),
                ControlPanel(
                  state: state,
                  onSpringConstant: (v) {
                    _game.state.springConstant = v;
                    _game.state.time = 0;
                    _game.state.posHistory.clear();
                    _game.state.velHistory.clear();
                    _game.state.accHistory.clear();
                  },
                  onMass: (v) {
                    _game.state.mass = v;
                    _game.state.time = 0;
                    _game.state.posHistory.clear();
                    _game.state.velHistory.clear();
                    _game.state.accHistory.clear();
                  },
                  onAmplitude: (v) {
                    _game.state.amplitude = v;
                    _game.state.time = 0;
                    _game.state.posHistory.clear();
                    _game.state.velHistory.clear();
                    _game.state.accHistory.clear();
                  },
                  onPendulumLength: (v) {
                    _game.state.pendulumLength = v;
                    _game.state.time = 0;
                    _game.state.posHistory.clear();
                    _game.state.velHistory.clear();
                    _game.state.accHistory.clear();
                  },
                  onGravity: (v) {
                    _game.state.gravity = v;
                    _game.state.time = 0;
                    _game.state.posHistory.clear();
                    _game.state.velHistory.clear();
                    _game.state.accHistory.clear();
                  },
                  onInitialAngle: (v) {
                    _game.state.initialAngle = v;
                    _game.state.time = 0;
                    _game.state.posHistory.clear();
                    _game.state.velHistory.clear();
                    _game.state.accHistory.clear();
                  },
                  onModeToggle: () {
                    final newMode = state.mode == SimMode.spring ? SimMode.pendulum : SimMode.spring;
                    _recreateGame(newMode);
                  },
                  onPause: () => _game.togglePause(),
                  onReset: () => _game.reset(),
                  onToggleVectors: () => _game.toggleVectors(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
