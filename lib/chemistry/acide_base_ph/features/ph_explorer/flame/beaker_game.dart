import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'liquid_component.dart';
import 'bubble_system.dart';

class BeakerGame extends FlameGame {
  double _ph = 7.0;
  late final LiquidComponent _liquid;
  late final BubbleSystem _bubbles;
  bool _isInitialized = false;

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    // Add components in order (layering)
    _liquid = LiquidComponent()
      ..size = Vector2(172, 180)  // Adjusted to fill 180px beaker with 4px side padding
      ..position = Vector2(4, 30);
    
    _bubbles = BubbleSystem();
    
    add(_liquid);
    add(_bubbles);
    
    // Initial color set
    _liquid.updatePH(_ph);
    _bubbles.updatePH(_ph);

    _isInitialized = true;
  }

  void updatePH(double ph) {
    _ph = ph;
    if (!_isInitialized) return;
    _liquid.updatePH(ph);
    _bubbles.updatePH(ph);
  }
}
