import 'package:flutter/material.dart';

class FormulaTriangle extends StatelessWidget {
  final double voltage;
  final double current;
  final double resistance;

  const FormulaTriangle({
    super.key,
    required this.voltage,
    required this.current,
    required this.resistance,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: CustomPaint(
        painter: TrianglePainter(
          voltage: voltage,
          current: current,
          resistance: resistance,
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final double voltage;
  final double current;
  final double resistance;

  TrianglePainter({
    required this.voltage,
    required this.current,
    required this.resistance,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Horizontal divider
    final hDividerY = size.height * 0.6;
    canvas.drawLine(
      Offset(size.width * 0.2, hDividerY),
      Offset(size.width * 0.8, hDividerY),
      paint,
    );

    // Vertical divider
    canvas.drawLine(
      Offset(size.width / 2, hDividerY),
      Offset(size.width / 2, size.height),
      paint,
    );

    // Labels
    _drawText(canvas, "V", Offset(size.width / 2, size.height * 0.3), const Color(0xFFF5A623), 32);
    _drawText(canvas, "I", Offset(size.width * 0.3, size.height * 0.8), const Color(0xFF00CFFF), 28);
    _drawText(canvas, "R", Offset(size.width * 0.7, size.height * 0.8), const Color(0xFF00FF88), 28);
  }

  void _drawText(Canvas canvas, String text, Offset center, Color color, double fontSize) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          fontFamily: 'Orbitron',
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
