import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class CyclePathPainter extends Component with HasGameReference {
  final double Th;
  final double Tc;

  CyclePathPainter({required this.Th, required this.Tc});

  @override
  void render(Canvas canvas) {
    // Draw Background Grid for a "Technical" look
    _drawGrid(canvas);

    final paint = Paint()
      ..color = AppColors.accentCarnot.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    
    // Cycle Boundaries
    const v1 = 0.5;
    const v2 = 1.2; // tighter boundaries for simulation area
    const v3 = 2.0; 
    const v4 = 0.8;

    _moveTo(path, v1, _P(v1, Th));
    _isothermalTo(path, v1, v2, Th);
    _adiabaticTo(path, v2, v3, Th, Tc);
    _isothermalTo(path, v3, v4, Tc);
    _adiabaticTo(path, v4, v1, Tc, Th);
    
    // Slight shadow/glow effect
    canvas.drawPath(path, paint..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2));
    canvas.drawPath(path, paint..maskFilter = null);

    // Subtle area fill
    final fillPaint = Paint()
      ..color = AppColors.accentCarnot.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);
  }

  void _drawGrid(Canvas canvas) {
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1;
    
    for (double i = 0; i < game.size.x; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(i, game.size.y), gridPaint);
    }
    for (double i = 0; i < game.size.y; i += 20) {
      canvas.drawLine(Offset(0, i), Offset(game.size.x, i), gridPaint);
    }
  }

  double _P(double V, double T) => (T / 100) / V;

  void _moveTo(Path path, double V, double P) {
    path.moveTo(_mapV(V), _mapP(P));
  }

  void _isothermalTo(Path path, double startV, double endV, double T) {
    final steps = (endV - startV).abs() * 10;
    for (int i = 0; i <= steps; i++) {
        final v = startV + (endV - startV) * (i / steps);
        path.lineTo(_mapV(v), _mapP(_P(v, T)));
    }
  }

  void _adiabaticTo(Path path, double startV, double endV, double startT, double endT) {
    for (double i = 0; i <= 1.0; i += 0.1) {
      final v = startV + (endV - startV) * i;
      final t = startT + (endT - startT) * i;
      path.lineTo(_mapV(v), _mapP(_P(v, t)));
    }
  }

  // Adjusted scaling for the simulation area (top container)
  double _mapV(double V) => (V / 2.5) * game.size.x;
  double _mapP(double P) => game.size.y - (P / 16.0) * game.size.y;
}
