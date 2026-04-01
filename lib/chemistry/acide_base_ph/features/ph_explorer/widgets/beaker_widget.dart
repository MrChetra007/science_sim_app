import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../flame/beaker_game.dart';
import '../providers/ph_provider.dart';

class BeakerWidget extends ConsumerStatefulWidget {
  const BeakerWidget({super.key});

  @override
  ConsumerState<BeakerWidget> createState() => _BeakerWidgetState();
}

class _BeakerWidgetState extends ConsumerState<BeakerWidget> {
  late final BeakerGame _game;

  @override
  void initState() {
    super.initState();
    _game = BeakerGame();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to pH changes and push to Flame game
    ref.listen<PHState>(phProvider, (_, state) {
      _game.updatePH(state.ph);
    });

    return Container(
      width: 180,
      height: 240,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
        child: GameWidget(game: _game),
      ),
    );
  }
}
