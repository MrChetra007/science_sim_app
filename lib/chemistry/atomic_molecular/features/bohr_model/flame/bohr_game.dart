import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import '../../../core/models/element.dart';
import '../../../core/theme/app_colors.dart';
import 'nucleus_component.dart';
import 'shell_component.dart';

class BohrGame extends FlameGame with WidgetsBindingObserver {
  ChemElement _element;

  BohrGame({required ChemElement initialElement})
      : _element = initialElement;

  late NucleusComponent _nucleus;
  final List<ShellComponent> _shells = [];

  @override
  void onMount() {
    super.onMount();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) pauseEngine();
    if (state == AppLifecycleState.resumed) resumeEngine();
  }

  @override
  void onRemove() {
    WidgetsBinding.instance.removeObserver(this);
    super.onRemove();
  }

  @override
  Future<void> onLoad() async {
    _buildAtom(_element);
  }

  void _buildAtom(ChemElement el) {
    removeAll(children);
    _shells.clear();

    _nucleus = NucleusComponent(
      element: el,
      position: size / 2,
    );
    add(_nucleus);

    // Dynamic shell radii based on game size
    final double baseGap = size.x * 0.11;
    final double startRadius = 55.0;

    for (int i = 0; i < el.shells.length; i++) {
      final shell = ShellComponent(
        shellIndex: i,
        electronCount: el.shells[i],
        radius: startRadius + (i * baseGap),
        center: size / 2,
        color: AppColors.shellColors[i % AppColors.shellColors.length],
      );
      _shells.add(shell);
      add(shell);
    }
  }

  void switchElement(ChemElement el) {
    if (_element.atomicNumber == el.atomicNumber) return;
    _element = el;
    _buildAtom(el);
  }

  void exciteElectrons() {
    if (_shells.isNotEmpty) {
      _shells.last.triggerExcitation();
    }
  }
}
