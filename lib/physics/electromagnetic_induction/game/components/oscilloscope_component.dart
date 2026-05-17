import 'package:flutter/painting.dart';
import 'package:flame/components.dart';

enum AnnotationType { peak, zeroCrossing, reversal }

class _Annotation {
  final AnnotationType type;
  final double x;
  final double age;

  const _Annotation(this.type, this.x, this.age);
}

class OscilloscopeComponent extends PositionComponent {
  List<double> _emfHistory = [];
  List<double> _fluxHistory = [];
  double _currentEmf = 0;
  double _currentFlux = 0;
  final List<_Annotation> _annotations = [];
  double _emfSlope = 0;

  OscilloscopeComponent() {
    anchor = Anchor.topLeft;
    position = Vector2.zero();
  }

  void updateData(
    List<double> emfHistory,
    List<double> fluxHistory,
    double emf,
    double flux,
  ) {
    _emfHistory = emfHistory;
    _fluxHistory = fluxHistory;
    _currentEmf = emf;
    _currentFlux = flux;

    _detectEvents();
  }

  void _detectEvents() {
    if (_emfHistory.length < 3) return;

    final w = size.x;
    if (w <= 0) return;

    const maxSamples = 300;
    final stepX = w / maxSamples;

    final i = _emfHistory.length - 1;
    final prev = _emfHistory[i - 1];
    final curr = _emfHistory[i];
    final prevSlope = _emfSlope;
    _emfSlope = curr - prev;

    if (i >= 2) {
      final prevPrev = _emfHistory[i - 2];
      if (prevPrev.sign != prev.sign && prev.abs() < 0.3) {
        final lastAnn = _annotations.isEmpty ? null : _annotations.last;
        if (lastAnn == null || lastAnn.type != AnnotationType.zeroCrossing || lastAnn.age < 20) {
          final annX = w - (_emfHistory.length - i + 1) * stepX;
          _annotations.add(_Annotation(AnnotationType.zeroCrossing, annX, 0));
        }
      }
    }

    if (prevSlope > 0 && _emfSlope < 0 && curr.abs() > 0.5) {
      final lastAnn = _annotations.isEmpty ? null : _annotations.last;
      if (lastAnn == null || lastAnn.type != AnnotationType.peak || lastAnn.age < 20) {
        final annX = w - (_emfHistory.length - i) * stepX;
        _annotations.add(_Annotation(AnnotationType.peak, annX, 0));
      }
    }
  }

  @override
  void render(Canvas canvas) {
    final w = size.x;
    final h = size.y;
    if (w <= 0 || h <= 0) return;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()..color = const Color(0xFF1B1B1B),
    );

    final midY = h / 2;

    _drawGrid(canvas, w, h, midY);
    _drawWaveform(canvas, w, midY, _emfHistory, const Color(0xFF00FF41), -1);
    _drawWaveform(canvas, w, midY, _fluxHistory, const Color(0xFF42A5F5), 1);
    _drawDivider(canvas, w, midY);
    _drawAnnotations(canvas, w, midY);
    _drawLabels(canvas, w, midY);
  }

  void _drawGrid(Canvas canvas, double w, double h, double midY) {
    final gridPaint = Paint()
      ..color = const Color(0xFF2D5A27)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (int i = 0; i <= 4; i++) {
      final y = midY * i / 4;
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
      canvas.drawLine(Offset(0, midY + y), Offset(w, midY + y), gridPaint);
    }
    for (int i = 0; i <= 8; i++) {
      final x = w * i / 8;
      canvas.drawLine(Offset(x, 0), Offset(x, h), gridPaint);
    }

    final zeroPaint = Paint()
      ..color = const Color(0xFF3A6B3A)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, midY), Offset(w, midY), zeroPaint);
  }

  void _drawDivider(Canvas canvas, double w, double midY) {
    final divPaint = Paint()
      ..color = const Color(0xFF4A4A4A)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, midY), Offset(w, midY), divPaint);
  }

  void _drawWaveform(
    Canvas canvas,
    double w,
    double midY,
    List<double> data,
    Color color,
    int sign,
  ) {
    if (data.length < 2) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    const maxSamples = 300;
    final stepX = w / maxSamples;
    final scaleY = midY / 4;

    for (int i = 0; i < data.length; i++) {
      final x = w - (data.length - i) * stepX;
      final y = midY + sign * data[i] * scaleY;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  void _drawAnnotations(Canvas canvas, double w, double midY) {
    final toRemove = <_Annotation>[];
    for (final ann in _annotations) {
      ann.age;
      final age = ann.age + 1;

      if (ann.x < 0 || ann.x > w || age > 80) {
        toRemove.add(ann);
        continue;
      }

      final fade = (1.0 - age / 80).clamp(0.0, 1.0);
      final alpha = (fade * 200).toInt();

      final dashPaint = Paint()
        ..color = Color.fromARGB(alpha, 255, 255, 255)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5;

      double dy = 0;
      while (dy < size.y) {
        canvas.drawLine(
          Offset(ann.x, dy),
          Offset(ann.x, (dy + 4).clamp(0, size.y)),
          dashPaint,
        );
        dy += 8;
      }

      final label = _labelFor(ann.type);
      final tagColor = _colorFor(ann.type);
      final tagPaint = Paint()
        ..color = tagColor.withValues(alpha: fade)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(ann.x, midY), 3, tagPaint);

      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: tagColor.withValues(alpha: fade),
            fontSize: 9,
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final labelX = (ann.x + tp.width + 8 > w) ? ann.x - tp.width - 4 : ann.x + 6;
      tp.paint(canvas, Offset(labelX, midY - tp.height - 4));
    }

    for (final ann in toRemove) {
      _annotations.remove(ann);
    }

    for (int i = 0; i < _annotations.length; i++) {
      final ann = _annotations[i];
      _annotations[i] = _Annotation(ann.type, ann.x, ann.age + 1);
    }

    _annotations.removeWhere((a) => a.x < 0 || a.x > w || a.age > 80);
  }

  String _labelFor(AnnotationType type) {
    switch (type) {
      case AnnotationType.peak:
        return 'PEAK';
      case AnnotationType.zeroCrossing:
        return 'ZERO';
      case AnnotationType.reversal:
        return 'REVERSAL';
    }
  }

  Color _colorFor(AnnotationType type) {
    switch (type) {
      case AnnotationType.peak:
        return const Color(0xFFFFD740);
      case AnnotationType.zeroCrossing:
        return const Color(0xFF69F0AE);
      case AnnotationType.reversal:
        return const Color(0xFFFF7043);
    }
  }

  void _drawLabels(Canvas canvas, double w, double midY) {
    final emfLabel = TextPainter(
      text: TextSpan(
        text: 'EMF: ${_currentEmf.toStringAsFixed(2)} V',
        style: const TextStyle(
          color: Color(0xFF00FF41),
          fontSize: 12,
          fontFamily: 'monospace',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    emfLabel.paint(canvas, const Offset(6, 4));

    final fluxLabel = TextPainter(
      text: TextSpan(
        text: 'Φ: ${_currentFlux.toStringAsFixed(3)} Wb',
        style: const TextStyle(
          color: Color(0xFF42A5F5),
          fontSize: 12,
          fontFamily: 'monospace',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    fluxLabel.paint(canvas, Offset(6, midY + 4));

    final emfTag = TextPainter(
      text: const TextSpan(
        text: 'EMF',
        style: TextStyle(
          color: Color(0xFF00FF41),
          fontSize: 10,
          fontFamily: 'monospace',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    emfTag.paint(canvas, Offset(w - emfTag.width - 6, 6));

    final fluxTag = TextPainter(
      text: const TextSpan(
        text: 'FLUX',
        style: TextStyle(
          color: Color(0xFF42A5F5),
          fontSize: 10,
          fontFamily: 'monospace',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    fluxTag.paint(canvas, Offset(w - fluxTag.width - 6, midY + 6));
  }
}
