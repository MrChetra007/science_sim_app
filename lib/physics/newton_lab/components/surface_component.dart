import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../physics/friction_model.dart';
import '../core/constants.dart';

class SurfaceComponent extends PositionComponent {
  SurfaceType surfaceType;
  
  SurfaceComponent({
    required this.surfaceType,
    super.position,
    super.size,
  });

  double get frictionCoefficient => FrictionModel.getCoefficient(surfaceType);

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Determine color based on surface type
    Color groundColor;
    switch (surfaceType) {
      case SurfaceType.ice:
        groundColor = const Color(0xFFB3E5FC); // Soft Ice Blue
        break;
      case SurfaceType.wood:
        groundColor = const Color(0xFF8D6E63); // Wood Brown
        break;
      case SurfaceType.rubber:
        groundColor = const Color(0xFF37474F); // Rubber Grey
        break;
      case SurfaceType.sand:
        groundColor = const Color(0xFFFFD54F); // Sand Yellow
        break;
    }

    // Draw the ground
    final paint = Paint()..color = groundColor.withOpacity(0.4);
    canvas.drawRect(size.toRect(), paint);
    
    // Optional: Draw hatched lines to indicate roughness based on friction
    final linePaint = Paint()
      ..color = AppColors.gridLines
      ..strokeWidth = 2;
      
    double spacing = 20.0 - (frictionCoefficient * 10.0); // Denser lines for higher friction
    if (spacing < 5.0) spacing = 5.0;
    
    for (double i = 0; i < size.x; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i + 10, 10), linePaint);
    }
  }
}
