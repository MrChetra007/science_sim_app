import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import '../providers/ac_provider.dart';
import 'components/sine_wave_component.dart';
import 'components/phasor_component.dart';
import 'components/wire_component.dart';
import 'components/bulb_component.dart';
import 'components/dcac_compare_component.dart';
import 'components/transformer_component.dart';

class ACGame extends FlameGame {
  final ACProvider provider;
  ACGame({required this.provider});

  late SineWaveComponent sineWave;
  late PhasorComponent phasor;
  late WireComponent wire;
  late BulbComponent bulb;
  late DCAcCompareComponent dcacCompare;
  late TransformerComponent transformer;

  bool _initialized = false;
  bool showOnlyTransformer = false;
  double lastPhase = 0;

  @override
  Future<void> onLoad() async {
    sineWave = SineWaveComponent();
    phasor = PhasorComponent();
    wire = WireComponent();
    bulb = BulbComponent();
    dcacCompare = DCAcCompareComponent();
    transformer = TransformerComponent();
    addAll([sineWave, phasor, wire, bulb, dcacCompare, transformer]);
    _initialized = true;
    _layoutComponents(size);
  }

  @override
  void update(double dt) {
    super.update(dt);
    provider.tick(dt);
    
    if (provider.isRunning) {
      if (provider.humEnabled) {
          final phase = provider.state.phaseDeg;
          // Trigger light haptic at peaks (twice per cycle)
          if ((lastPhase < 90 && phase >= 90) || (lastPhase < 270 && phase >= 270) || (phase < lastPhase && phase < 90 && lastPhase > 270)) {
               HapticFeedback.selectionClick();
          }
          lastPhase = phase;
      }
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (_initialized) {
      _layoutComponents(size);
    }
  }

  void _layoutComponents(Vector2 size) {
    if (!_initialized) return;

    if (showOnlyTransformer) {
      transformer.size = size;
      transformer.position = Vector2.zero();
      sineWave.size = Vector2.zero();
      phasor.size = Vector2.zero();
      wire.size = Vector2.zero();
      bulb.size = Vector2.zero();
      dcacCompare.size = Vector2.zero();
      return;
    }

    final isPortrait = size.y > size.x;
    
    if (isPortrait) {
      // Top section: Sine Wave
      sineWave.size = Vector2(size.x, size.y * 0.4);
      sineWave.position = Vector2(0, 0);
      
      // Middle section: Phasor and Wire side-by-side
      phasor.size = Vector2(size.x * 0.35, size.y * 0.3);
      phasor.position = Vector2(0, size.y * 0.4);
      
      wire.size = Vector2(size.x * 0.4, size.y * 0.3);
      wire.position = Vector2(size.x * 0.35, size.y * 0.4);

      bulb.size = Vector2(size.x * 0.25, size.y * 0.3);
      bulb.position = Vector2(size.x * 0.75, size.y * 0.4);

      dcacCompare.size = Vector2(size.x, size.y * 0.3);
      dcacCompare.position = Vector2(0, size.y * 0.7);
    } else {
      sineWave.size = Vector2(size.x * 0.5, size.y * 0.4);
      sineWave.position = Vector2(0, 0);
      
      phasor.size = Vector2(size.x * 0.5, size.y * 0.4);
      phasor.position = Vector2(size.x * 0.5, 0);

      wire.size = Vector2(size.x * 0.4, size.y * 0.3);
      wire.position = Vector2(0, size.y * 0.4);

      bulb.size = Vector2(size.x * 0.2, size.y * 0.3);
      bulb.position = Vector2(size.x * 0.4, size.y * 0.4);

      dcacCompare.size = Vector2(size.x * 0.4, size.y * 0.6);
      dcacCompare.position = Vector2(size.x * 0.6, size.y * 0.4);

      transformer.size = Vector2.zero();
      transformer.position = Vector2.zero();
    }
  }
}
