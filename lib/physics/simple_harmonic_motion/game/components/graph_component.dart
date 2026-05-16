import 'dart:ui';
import 'package:flame/components.dart';

class GraphComponent extends PositionComponent {
  final Paint _bgPaint = Paint()..color = const Color(0xFF1B1B1B);
  final Paint _gridPaint = Paint()
    ..color = const Color(0xFF2D5A27)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.5;

  final _traces = <_TraceData>[
    _TraceData(color: const Color(0xFF00FF41), label: 'x'),
    _TraceData(color: const Color(0xFFFFA000), label: 'v'),
    _TraceData(color: const Color(0xFF00E5FF), label: 'a'),
  ];

  final Paint _legendBg = Paint()..color = const Color(0x88000000);

  List<double> posHistory = [];
  List<double> velHistory = [];
  List<double> accHistory = [];
  static const int maxPoints = 500;

  final List<_Annotation> _annotations = [];

  @override
  void render(Canvas canvas) {
    final w = size.x;
    final h = size.y;
    if (w <= 0 || h <= 0) return;

    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), _bgPaint);

    final gridSpacing = h / 4;
    for (int i = 0; i <= 4; i++) {
      final y = i * gridSpacing;
      canvas.drawLine(Offset(0, y), Offset(w, y), _gridPaint);
    }

    final histories = [posHistory, velHistory, accHistory];

    double maxAbs = 0.001;
    for (final hist in histories) {
      for (final v in hist) {
        final absV = v.abs();
        if (absV > maxAbs) maxAbs = absV;
      }
    }
    final range = maxAbs * 1.1;

    for (int t = 0; t < 3; t++) {
      final hist = histories[t];
      if (hist.length < 2) continue;

      final trace = _traces[t];
      final path = Path();
      final stepX = w / maxPoints;

      for (int i = 0; i < hist.length; i++) {
        final x = w - (hist.length - 1 - i) * stepX;
        final normalized = hist[i] / range;
        final y = h / 2 - normalized * (h / 2 - 8);

        if (i == 0) {
          path.moveTo(x.clamp(0, w).toDouble(), y.clamp(0, h).toDouble());
        } else {
          final prevX = w - (hist.length - 1 - (i - 1)) * stepX;
          final prevNormalized = hist[i - 1] / range;
          final prevY = h / 2 - prevNormalized * (h / 2 - 8);
          final midX = (prevX + x) / 2;
          final midY = (prevY + y) / 2;
          path.quadraticBezierTo(
            midX.clamp(0, w).toDouble(),
            midY.clamp(0, h).toDouble(),
            x.clamp(0, w).toDouble(),
            y.clamp(0, h).toDouble(),
          );
        }
      }

      trace.paint.strokeWidth = 1.5;
      canvas.drawPath(path, trace.paint);
    }

    _drawAnnotations(canvas, w, h, range);
    _drawLegend(canvas, w, h);
  }

  void detectAnnotations() {
    if (posHistory.length < 3) return;
    final i = posHistory.length - 1;
    final prev = posHistory[i - 1];
    final curr = posHistory[i];

    if (prev > 0 && curr <= 0) {
      _annotations.add(_Annotation(
        text: 'ZERO',
        color: const Color(0xFF00FF41),
        age: 0,
      ));
    }
    if (prev < 0 && curr >= 0) {
      _annotations.add(_Annotation(
        text: 'ZERO',
        color: const Color(0xFF00FF41),
        age: 0,
      ));
    }
    if (prev < curr && (i < 2 || posHistory[i - 2] < prev)) {
      _annotations.add(_Annotation(
        text: 'PEAK',
        color: const Color(0xFFFFD600),
        age: 0,
      ));
    }
    if (prev > curr && (i < 2 || posHistory[i - 2] > prev)) {
      _annotations.add(_Annotation(
        text: 'PEAK',
        color: const Color(0xFFFFD600),
        age: 0,
      ));
    }
  }

  void _drawAnnotations(Canvas canvas, double w, double h, double range) {
    _annotations.removeWhere((a) => a.age > 80);

    for (final a in _annotations) {
      a.age++;
      final alpha = ((1 - a.age / 80) * 255).round().clamp(0, 255);
      final color = a.color.withValues(alpha: alpha / 255.0);
      final tp = ParagraphBuilder(ParagraphStyle(textAlign: TextAlign.center))
        ..pushStyle(TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold))
        ..addText(a.text);
      final para = tp.build()..layout(const ParagraphConstraints(width: 40));
      canvas.drawParagraph(para, Offset(w - 50, 4 + (80 - a.age) % 40));
    }
  }

  void _drawLegend(Canvas canvas, double w, double h) {
    const legendW = 90.0;
    const legendH = 60.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w - legendW - 8, 4, legendW, legendH),
        const Radius.circular(4),
      ),
      _legendBg,
    );

    for (int i = 0; i < 3; i++) {
      final trace = _traces[i];
      final y = 16.0 + i * 18.0;
      canvas.drawLine(
        Offset(w - legendW, y),
        Offset(w - legendW + 14, y),
        trace.paint,
      );
      final tp = ParagraphBuilder(ParagraphStyle(textAlign: TextAlign.left))
        ..pushStyle(TextStyle(color: trace.paint.color, fontSize: 10))
        ..addText(trace.label);
      final para = tp.build()
        ..layout(const ParagraphConstraints(width: 60));
      canvas.drawParagraph(para, Offset(w - legendW + 18, y - 6));
    }
  }
}

class _TraceData {
  final Paint paint;
  final String label;
  _TraceData({required Color color, required this.label})
    : paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke;
}

class _Annotation {
  final String text;
  final Color color;
  int age;
  _Annotation({required this.text, required this.color, required this.age});
}
