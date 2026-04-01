import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ForceArrow extends PositionComponent {
  Vector2 direction;
  double magnitude;
  Color color;
  String label;

  ForceArrow({
    required this.direction,
    required this.magnitude,
    required this.color,
    required this.label,
    super.position,
  });

  @override
  void render(Canvas canvas) {
    if (magnitude < 0.1) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final directionNormalized = direction.normalized();
    final vectorEnd = directionNormalized * magnitude;
    
    // Draw the main line
    canvas.drawLine(Offset.zero, Offset(vectorEnd.x, vectorEnd.y), paint);

    // Arrowhead logic - Calculated based on vector direction
    final double arrowHeadSize = 12.0;
    
    // Vector perpendicular to direction (rotated 90 degrees)
    final perp = Vector2(-directionNormalized.y, directionNormalized.x);
    
    // Back points of the triangle
    final backCenter = vectorEnd - (directionNormalized * arrowHeadSize);
    final point1 = backCenter + (perp * (arrowHeadSize / 2));
    final point2 = backCenter - (perp * (arrowHeadSize / 2));

    final path = Path()
      ..moveTo(vectorEnd.x, vectorEnd.y) // Tip
      ..lineTo(point1.x, point1.y)
      ..lineTo(point2.x, point2.y)
      ..close();

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);

    // Text Label logic
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: color, 
          fontSize: 14, 
          fontWeight: FontWeight.bold,
          fontFamily: 'JetBrainsMono',
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    
    // Position label based on direction to avoid overlap
    final midPoint = vectorEnd / 2;
    double offsetX = midPoint.x - (textPainter.width / 2);
    double offsetY = midPoint.y - 20;

    // Adjust for vertical vectors
    if (directionNormalized.y.abs() > 0.8) {
      offsetX = midPoint.x + 10;
      offsetY = midPoint.y - (textPainter.height / 2);
    }

    textPainter.paint(canvas, Offset(offsetX, offsetY));
  }
}
