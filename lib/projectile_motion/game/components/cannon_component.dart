import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import '../projectile_game.dart';

/// Draws the cannon — a base wheel, body, and a rotatable barrel.
class CannonComponent extends Component {
  final ProjectileGame game;
  double _angleDeg = 45.0;

  CannonComponent({required this.game});

  double _recoilOffset = 0.0;

  void setAngle(double deg) => _angleDeg = deg.clamp(0.0, 90.0);

  void playRecoil() => _recoilOffset = 15.0;

  @override
  void update(double dt) {
    if (_recoilOffset > 0) {
      _recoilOffset -= dt * 60; // Decay speed
      if (_recoilOffset < 0) _recoilOffset = 0;
    }
  }

  final Paint _wheelPaint = Paint()..color = const Color(0xFF5D4037);
  final Paint _bodyPaint = Paint()..color = const Color(0xFF4A4A4A);
  final Paint _barrelPaint = Paint()..color = const Color(0xFF333333);
  final Paint _rimPaint = Paint()
    ..color = const Color(0xFF757575)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  @override
  void render(Canvas canvas) {
    final mapper = game.mapper;
    if (mapper == null) return;

    // Cannon origin in screen space (at physical x=0, y=initialHeight)
    final pos = mapper.toScreen(0, game.initialHeight);
    final cx = pos.dx;
    final cy = pos.dy;
    final groundPos = mapper.toScreen(0, 0);

    // ── SUPPORT STAND (Fixes "floating" look) ────────────────────────────────
    if (game.initialHeight >= 0) {
      const standWidth = 24.0;
      final standRect = Rect.fromLTRB(
        cx - standWidth / 2,
        cy + 10, // Start slightly below cannon center
        cx + standWidth / 2,
        groundPos.dy,
      );

      // Main pipe/stand body
      canvas.drawRect(
        standRect,
        Paint()..color = const Color(0xFF2C2C2C),
      );

      // Stand details (Mechanical ribs/shading)
      final detailPaint = Paint()
        ..color = const Color(0xFF1A1A1A)
        ..strokeWidth = 2;
      for (double y = cy + 20; y < groundPos.dy; y += 15) {
        canvas.drawLine(
          Offset(cx - standWidth / 2, y),
          Offset(cx + standWidth / 2, y),
          detailPaint,
        );
      }

      // Stand Border
      canvas.drawRect(
        standRect,
        Paint()
          ..color = const Color(0xFF4A4A4A)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );

      // Height Label background bubble
      if (game.initialHeight > 0) {
        _drawLabel(
          canvas,
          '${game.initialHeight.toStringAsFixed(0)}m',
          cx + standWidth / 2 + 10,
          (cy + groundPos.dy) / 2,
        );
      }
    }

    // Wheel
    canvas.drawCircle(Offset(cx, cy + 4), 14, _wheelPaint);
    canvas.drawCircle(Offset(cx, cy + 4), 14, _rimPaint);
    canvas.drawCircle(Offset(cx, cy + 4), 5, _rimPaint);

    // Cannon body
    canvas.save();
    canvas.translate(cx, cy);
    final rect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(-14, -10, 28, 20),
      const Radius.circular(4),
    );
    canvas.drawRRect(rect, _bodyPaint);
    canvas.restore();

    // Barrel — rotated by launch angle
    final angleRad = -_angleDeg * math.pi / 180.0;
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(angleRad);
    final barrelRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(-_recoilOffset, -6, 42, 12),
      const Radius.circular(3),
    );
    canvas.drawRRect(barrelRect, _barrelPaint);
    // Barrel highlight
    final highlightPaint = Paint()
      ..color = const Color(0x33FFFFFF)
      ..strokeWidth = 2;
    canvas.drawLine(const Offset(4, -3), const Offset(38, -3), highlightPaint);
    canvas.restore();
  }

  void _drawLabel(Canvas canvas, String text, double x, double y) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Color(0xFF80DEEA),
          fontSize: 10,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(x, y - tp.height / 2));
  }
}
