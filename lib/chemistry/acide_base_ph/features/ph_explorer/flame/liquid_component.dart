import 'dart:ui';
import 'package:flame/components.dart';
import '../../../core/theme/ph_colors.dart';

class LiquidComponent extends PositionComponent {
  double _ph = 7.0;
  Color _currentColor = const Color(0xFF209090);
  Color _targetColor = const Color(0xFF209090);

  @override
  void update(double dt) {
    super.update(dt);
    // Smoothly interpolate liquid color toward target
    _currentColor = Color.lerp(_currentColor, _targetColor, dt * 3.0)!;
  }

  @override
  void render(Canvas canvas) {
    // Draw the liquid rectangle inside beaker bounds
    final paint = Paint()..color = _currentColor.withOpacity(0.8);

    // Draw main liquid body
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0, size.y * 0.2, size.x, size.y * 0.8),
        bottomLeft: const Radius.circular(20),
        bottomRight: const Radius.circular(20),
        topLeft: const Radius.circular(4),
        topRight: const Radius.circular(4),
      ),
      paint,
    );

    // Draw surface ripple line
    final ripple = Paint()
      ..color = const Color(0xFFFFFFFF).withOpacity(0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(8, size.y * 0.2),
      Offset(size.x - 8, size.y * 0.2),
      ripple,
    );
  }

  void updatePH(double ph) {
    _ph = ph;
    _targetColor = PHColors.forPH(ph);
  }
}
