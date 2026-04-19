import 'dart:typed_data';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../ac_game.dart';

import 'package:flame/events.dart';

class SineWaveComponent extends Component with HasGameReference<ACGame>, TapCallbacks, DragCallbacks {
  static const int trailLength = 400; // Increased for better resolution
  final Float32List vTrail = Float32List(trailLength);
  final Float32List iTrail = Float32List(trailLength);
  int trailIndex = 0;

  Vector2? cursorPosition;

  Vector2 size = Vector2.zero();
  Vector2 position = Vector2.zero();

  final Paint vPaint = Paint()
    ..color = Colors.amber
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.5
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

  final Paint iPaint = Paint()
    ..color = Colors.cyan
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

  @override
  void update(double dt) {
    if (!game.provider.isRunning) return;
    
    final state = game.provider.state;
    vTrail[trailIndex % trailLength] = state.vt.toDouble();
    iTrail[trailIndex % trailLength] = state.it.toDouble();
    trailIndex++;
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(position.x, position.y);
    
    final provider = game.provider;
    final vScale = size.y / (10 * provider.voltsPerDiv); // 10 divisions vertically
    final iScale = vScale * 10; // Simple ratio for current for now

    _drawGrid(canvas, provider.voltsPerDiv);
    _drawWave(canvas, vTrail, vPaint, scale: vScale); 
    _drawWave(canvas, iTrail, iPaint, scale: iScale); 
    
    if (cursorPosition != null) {
        _drawCursor(canvas, vScale);
    }

    _drawLabels(canvas);
    
    canvas.restore();
  }

  void _drawGrid(Canvas canvas, double voltsPerDiv) {
    final gridPaint = Paint()..color = const Color(0xFF151921);
    final midY = size.y / 2;
    
    // Horizontal grid (Voltage)
    for (int i = -5; i <= 5; i++) {
        double y = midY + (size.y / 10 * i);
        canvas.drawLine(Offset(0, y), Offset(size.x, y), gridPaint);
    }
    
    // Vertical grid (Time)
    for (int i = 0; i <= 10; i++) {
        double x = size.x / 10 * i;
        canvas.drawLine(Offset(x, 0), Offset(x, size.y), gridPaint);
    }
    
    // Center line
    canvas.drawLine(Offset(0, midY), Offset(size.x, midY), Paint()..color = Colors.white10);
  }

  void _drawWave(Canvas canvas, Float32List trail, Paint paint, {required double scale}) {
    final path = Path();
    final midY = size.y / 2;
    bool started = false;

    for (int i = 0; i < trailLength; i++) {
      int idx = (trailIndex - trailLength + i) % trailLength;
      if (idx < 0) idx += trailLength;
      
      double x = size.x * i / trailLength;
      double y = midY - (trail[idx] * scale);

      if (!started) {
        path.moveTo(x, y);
        started = true;
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
    
    // Draw "Live" dot at the end
    if (started) {
        int lastIdx = (trailIndex - 1) % trailLength;
        if (lastIdx < 0) lastIdx += trailLength;
        canvas.drawCircle(Offset(size.x, midY - (trail[lastIdx] * scale)), 4, paint..style = PaintingStyle.fill);
    }
  }

  void _drawLabels(Canvas canvas) {
    final style = const TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold);
    _drawText(canvas, "VOLTAGE (V)", const Offset(5, 5), style.copyWith(color: Colors.amber.withValues(alpha: 0.5)));
    _drawText(canvas, "CURRENT (A)", Offset(5, size.y - 15), style.copyWith(color: Colors.cyan.withValues(alpha: 0.5)));
  }

  void _drawCursor(Canvas canvas, double vScale) {
    final paint = Paint()
      ..color = Colors.white54
      ..strokeWidth = 1.0;
    
    final midY = size.y / 2;
    final x = cursorPosition!.x;
    
    // Vertical Line
    canvas.drawLine(Offset(x, 0), Offset(x, size.y), paint);

    // Find nearest point in trail
    int dataIdx = ((x / size.x) * trailLength).floor();
    if (dataIdx >= 0 && dataIdx < trailLength) {
        int idx = (trailIndex - trailLength + dataIdx) % trailLength;
        if (idx < 0) idx += trailLength;
        
        double voltage = vTrail[idx];
        double y = midY - (voltage * vScale);
        
        // Horizontal Line
        canvas.drawLine(Offset(0, y), Offset(size.x, y), paint);
        
        // Dot at intersection
        canvas.drawCircle(Offset(x, y), 5, Paint()..color = Colors.blueAccent);
        
        // Value Text
        _drawText(canvas, "${voltage.toStringAsFixed(1)}V", Offset(x + 10, y - 20), const TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    cursorPosition = event.localStartPosition;
  }


  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    cursorPosition = event.localPosition;
  }

  void _drawText(Canvas canvas, String text, Offset offset, TextStyle style) {
    final tp = TextPainter(text: TextSpan(text: text, style: style), textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, offset);
  }
}
