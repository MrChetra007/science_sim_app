import 'dart:async';
import 'dart:ui';

import 'package:flame/cache.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'sprites.dart';

/// Shared base for all simulation games. Provides canvas helpers, sprite
/// loading and a UI refresh hook so the bottom-sheet readouts stay in sync.
abstract class BaseOpticsGame extends FlameGame {
  /// Short headline shown in the floating badge over the canvas.
  String get headline;

  /// Readout table shown in the bottom sheet.
  List<(String, String)> get readoutRows;

  BaseOpticsGame() {
    // Private per-game image cache: a game's dispose() must not clear the
    // global cache and dispose sprites that other games still draw.
    images = Images();
  }

  late final SpriteLoader sprites = SpriteLoader(images);
  VoidCallback? onUiChanged;

  double get gw => size.x;
  double get gh => size.y;

  void uiChanged() => onUiChanged?.call();

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (kDebugMode) {
      // Debug-only safety net: a render exception must never be swallowed
      // silently. It paints the error onto the canvas so the failure is
      // visible and prints the trace for `flutter run` consoles.
      try {
        renderScene(canvas);
      } catch (e, st) {
        debugPrint('[$runtimeType] render error: $e');
        debugPrintStack(stackTrace: st);
        paintRenderError(canvas, e);
      }
    } else {
      renderScene(canvas);
    }
  }

  int _ticks = 0;

  @override
  void update(double dt) {
    super.update(dt);
    _ticks++;
    if (_ticks % 90 == 0) {
      debugPrint(
          '[$runtimeType] loop ALIVE tick#$_ticks dt=${dt.toStringAsFixed(3)}');
    }
  }

  /// Each mode draws its scene here. Kept separate from [render] so the base
  /// can surface and diagnose failures.
  void renderScene(Canvas canvas);

  /// Paints a translucent error overlay describing a render failure.
  void paintRenderError(Canvas canvas, Object error) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, gw, gh),
      Paint()..color = const Color(0x33EF4444),
    );
    final tp = TextPainter(
      text: TextSpan(
        text: 'render() failed:\n$error',
        style: const TextStyle(color: Color(0xFFF87171), fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: gw > 0 ? gw - 40 : 200);
    tp.paint(canvas, const Offset(20, 20));
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    debugPrint('[$runtimeType] game size: ${this.size.x.toStringAsFixed(1)}x'
        '${this.size.y.toStringAsFixed(1)}');
  }

  /// Kicks off sprite preloading without blocking the game's load future.
  /// The canvas mounts immediately and falls back to drawn geometry until
  /// each sprite arrives.
  void preloadSprites(List<String> paths) {
    unawaited(Future<void>.delayed(Duration.zero, () async {
      try {
        await sprites.ensure(paths);
      } catch (_) {
        // Sprites are optional; drawn fallbacks remain visible.
      }
      uiChanged();
    }));
  }

  void clearCanvas(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, gw, gh),
      Paint()..color = const Color(0xFF090D16),
    );
  }

  // Gesture hooks driven from the widget layer.
  void startDrag(double x, double y) {}
  void updateDrag(double x, double y) {}
  void endDrag() {}

  Image? objectImage(ObjectSprite sprite) {
    if (sprite == ObjectSprite.arrow) return null;
    final asset = sprite.asset;
    return asset == null ? null : sprites.get(asset);
  }
}