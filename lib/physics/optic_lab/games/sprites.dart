import 'dart:ui';

import 'package:flame/cache.dart';

class SpriteAssets {
  static const String candle =
      'assets/images/Lit_candle_on_white_background_20260915104321-removebg-preview.png';
  static const String pencil =
      'assets/images/Wooden_pencil_standing_upright_20260915104311-removebg-preview.png';
  static const String pen =
      'assets/images/Blue_ballpoint_pen_isolated_20260915104314-removebg-preview.png';
  static const String book =
      'assets/images/Closed_book_standing_upright_20260915104324-removebg-preview.png';
  static const String mirrorStrip =
      'assets/images/Thin_mirror_viewed_from_side_20260915105931-removebg-preview.png';
  static const String mirrorConcave =
      'assets/images/Convex_mirror_strip_curving_outward_20260915110314-removebg-preview.png';
  static const String mirrorConvex =
      'assets/images/Concave_mirror_strip_curving_inward_20260915110127-removebg-preview.png';
}

enum ObjectSprite { arrow, candle, pencil, pen, book }

extension ObjectSpriteInfo on ObjectSprite {
  String get label => switch (this) {
        ObjectSprite.arrow => 'Arrow',
        ObjectSprite.candle => 'Candle',
        ObjectSprite.pencil => 'Pencil',
        ObjectSprite.pen => 'Pen',
        ObjectSprite.book => 'Book',
      };

  String? get asset => switch (this) {
        ObjectSprite.arrow => null,
        ObjectSprite.candle => SpriteAssets.candle,
        ObjectSprite.pencil => SpriteAssets.pencil,
        ObjectSprite.pen => SpriteAssets.pen,
        ObjectSprite.book => SpriteAssets.book,
      };
}

class SpriteLoader {
  SpriteLoader(this._images);

  /// Per-game image cache, so disposing a game never disposes sprites that
  /// a replacement game is still drawing.
  final Images _images;

  final Map<String, Image> _cache = {};

  Future<void> ensure(List<String> paths) async {
    for (final p in paths) {
      if (!_cache.containsKey(p)) {
        // Flame's image cache already prefixes paths with "assets/images/".
        final flamePath =
            p.startsWith('assets/images/') ? p.substring(14) : p;
        _cache[p] = await _images.load(flamePath);
      }
    }
  }

  Image? get(String path) => _cache[path];
}