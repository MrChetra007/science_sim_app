import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import '../projectile_game.dart';

/// Draws the ground stripe and horizontal distance tick marks.
class GroundComponent extends Component {
  final ProjectileGame game;
  GroundComponent({required this.game});

  final Paint _groundPaint = Paint()..color = const Color(0xFF2D5016);
  final Paint _stripePaint = Paint()..color = const Color(0xFF3D7A1F);
  final Paint _tickPaint = Paint()
    ..color = const Color(0xFF8BC34A)
    ..strokeWidth = 1.0;
  final Paint _gridPaint = Paint()
    ..color = const Color(0x22FFFFFF)
    ..strokeWidth = 0.5;

  @override
  void render(Canvas canvas) {
    final mapper = game.mapper;
    if (mapper == null) return;

    final w = game.size.x;
    final h = game.size.y;
    final groundY = mapper.originY;

    // Ground fill
    canvas.drawRect(
      Rect.fromLTWH(0, groundY, w, h - groundY),
      _groundPaint,
    );

    // Ground stripe / top edge
    canvas.drawRect(
      Rect.fromLTWH(0, groundY, w, 4),
      _stripePaint,
    );

    // Vertical grid lines and distance labels
    final tickSpacing = _niceTickSpacing(mapper.scale);
    if (tickSpacing <= 0) return;

    double phyX = 0;
    while (true) {
      final screenX = mapper.originX + phyX * mapper.scale;
      if (screenX > w + 20) break;

      // Grid line
      canvas.drawLine(
        Offset(screenX, mapper.originY - 4),
        Offset(screenX, 20),
        _gridPaint,
      );

      // Tick & label
      canvas.drawLine(
        Offset(screenX, groundY),
        Offset(screenX, groundY + 6),
        _tickPaint,
      );

      _drawLabel(canvas, '${phyX.toInt()}m', screenX, groundY + 14);

      phyX += tickSpacing;
    }
  }

  double _niceTickSpacing(double scale) {
    // Choose a tick spacing so we get ~5-8 ticks on screen
    final nice = [
      1,
      2,
      5,
      10,
      20,
      50,
      100,
      200,
      500,
      1000,
      2000,
      5000,
      10000,
      20000,
      50000
    ].firstWhere(
      (v) => v * scale >= 60,
      orElse: () => 100000,
    );
    return nice.toDouble();
  }

  void _drawLabel(Canvas canvas, String text, double x, double y) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Color(0xFFB0BEC5),
          fontSize: 9,
          fontFamily: 'monospace',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(x - tp.width / 2, y));
  }
}
