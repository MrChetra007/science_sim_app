import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/events.dart';
import 'drop_component.dart';
import 'particle_system.dart';
import '../../ph_explorer/flame/liquid_component.dart';
import '../../../core/services/audio_service.dart';

class TitrationGame extends FlameGame with TapCallbacks {
  final Function(double) onDropLanded;
  late final LiquidComponent _beakerLiquid;
  late final double _surfaceY;
  bool _isInitialized = false;

  TitrationGame({required this.onDropLanded});

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    // Beaker body placeholder
    _surfaceY = size.y * 0.6;
    
    _beakerLiquid = LiquidComponent()
      ..size = Vector2(size.x * 0.6, size.y * 0.4)
      ..position = Vector2(size.x * 0.2, _surfaceY);
    
    add(_beakerLiquid);
    
    // Add a simple "Burette" visual
    add(RectangleComponent()
      ..size = Vector2(10, 80)
      ..position = Vector2(size.x / 2 - 5, 0)
      ..paint.color = Colors.white.withOpacity(0.3));

    _isInitialized = true;
  }

  void spawnDrop() {
    add(DropComponent(
      startY: 80,
      targetY: _surfaceY + 5,
      x: size.x / 2,
      onLand: () {
        onDropLanded(1.0); // 1.0 mL per drop for simplicity
        AudioService.playDrop();
        add(SplashParticles(position: Vector2(size.x / 2, _surfaceY + 5)));
      },
    ));
  }

  void updateColor(Color color) {
    _beakerLiquid.updatePH(7.0); // This is a hack because updatePH uses ph
    // Let's modify LiquidComponent or just use a direct color update
  }
  
  // Actually, let's just use the pH value directly
  void updatePH(double ph) {
    if (!_isInitialized) return;
    _beakerLiquid.updatePH(ph);
  }
}
