import 'dart:ui';
import 'package:flame/components.dart';
import '../projectile_game.dart';

class TargetComponent extends Component {
  final ProjectileGame game;
  double? _distance;

  TargetComponent({required this.game});

  void setDistance(double? d) => _distance = d;
  double? getDistance() => _distance;

  @override
  void render(Canvas canvas) {
    final d = _distance;
    final mapper = game.mapper;
    if (d == null || mapper == null) return;

    final s = mapper.toScreen(d, 0);

    // Draw Bullseye
    final paint = Paint()..style = PaintingStyle.fill;

    // Outer Glow
    canvas.drawCircle(
      s,
      25,
      Paint()
        ..color = const Color(0x44FF5252)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    // Ring 1 (Red)
    paint.color = const Color(0xFFFF5252);
    canvas.drawCircle(s, 15, paint);

    // Ring 2 (White)
    paint.color = const Color(0xFFFFFFFF);
    canvas.drawCircle(s, 10, paint);

    // Center (Red)
    paint.color = const Color(0xFFFF5252);
    canvas.drawCircle(s, 5, paint);

    // Indicator Line
    final linePaint = Paint()
      ..color = const Color(0x66FFFFFF)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
        s - const Offset(0, 10), s - const Offset(0, 40), linePaint);
  }
}
