import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/painting.dart';

double degToRad(double deg) => deg * math.pi / 180.0;
double radToDeg(double rad) => rad * 180.0 / math.pi;

void paintText(Canvas canvas, String text, double x, double y, Color color,
    {double size = 12, bool bold = false, TextAlign align = TextAlign.left}) {
  final tp = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
      ),
    ),
    textDirection: TextDirection.ltr,
    textAlign: align,
  )..layout();
  var dx = x;
  if (align == TextAlign.right) dx = x - tp.width;
  if (align == TextAlign.center) dx = x - tp.width / 2;
  tp.paint(canvas, Offset(dx, y));
}

void drawArrow(Canvas canvas, double fx, double fy, double tx, double ty,
    Color color,
    {double arrowSize = 9, double width = 2.5}) {
  final angle = math.atan2(ty - fy, tx - fx);
  final line = Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = StrokeCap.round;
  canvas.drawLine(Offset(fx, fy), Offset(tx, ty), line);
  final head = Path()
    ..moveTo(tx, ty)
    ..lineTo(tx - arrowSize * math.cos(angle - math.pi / 6),
        ty - arrowSize * math.sin(angle - math.pi / 6))
    ..lineTo(tx - arrowSize * math.cos(angle + math.pi / 6),
        ty - arrowSize * math.sin(angle + math.pi / 6))
    ..close();
  canvas.drawPath(head, Paint()..color = color);
}

void drawDashedLine(Canvas canvas, double x1, double y1, double x2, double y2,
    Color color,
    {List<double> pattern = const [5, 4], double width = 1.4}) {
  final dx = x2 - x1;
  final dy = y2 - y1;
  final dist = math.sqrt(dx * dx + dy * dy);
  if (dist < 1e-9) return;
  final ux = dx / dist;
  final uy = dy / dist;
  final paint = Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = width;
  var t = 0.0;
  var di = 0;
  var on = true;
  while (t < dist) {
    final seg = pattern[di % pattern.length];
    final end = math.min(t + seg, dist);
    if (on) {
      canvas.drawLine(Offset(x1 + ux * t, y1 + uy * t),
          Offset(x1 + ux * end, y1 + uy * end), paint);
    }
    t = end;
    di++;
    on = !on;
  }
}

void drawAngleArc(Canvas canvas, double cx, double cy, double a1, double a2,
    double radius, String label, Color color) {
  var start = a1;
  var end = a2;
  var diff = (end - start) % (2 * math.pi);
  if (diff < 0) diff += 2 * math.pi;
  if (diff > math.pi) {
    final t = start;
    start = end;
    end = t;
  }
  final paint = Paint()
    ..color = color
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;
  canvas.drawArc(
    Rect.fromCircle(center: Offset(cx, cy), radius: radius),
    start,
    end - start,
    false,
    paint,
  );
  final mid = start + (end - start) / 2;
  final lx = cx + (radius + 18) * math.cos(mid);
  final ly = cy + (radius + 18) * math.sin(mid);
  paintText(canvas, label, lx - 20, ly + 4, color, size: 12, bold: true);
}

void drawFocalMarker(Canvas canvas, double x, double y, String label) {
  canvas.drawCircle(Offset(x, y), 4, Paint()..color = const Color(0xFFE2E8F0));
  paintText(canvas, label, x - 4, y + 18, const Color(0xFFE2E8F0),
      size: 12, bold: true);
}

void drawObjectArrow(Canvas canvas, double x, double baseY, double tipY,
    Color color, String label) {
  drawArrow(canvas, x, baseY, x, tipY, color, arrowSize: 12, width: 3.5);
  paintText(canvas, label, x - 35, tipY - 10, color, size: 12);
  canvas.drawCircle(Offset(x, tipY), 5, Paint()..color = const Color(0xFFFFFFFF));
}

void drawArrowHead(Canvas canvas, double tipX, double tipY, double angle,
    Color color,
    {double arrowSize = 12}) {
  final head = Path()
    ..moveTo(tipX, tipY)
    ..lineTo(tipX - arrowSize * math.cos(angle - math.pi / 6),
        tipY - arrowSize * math.sin(angle - math.pi / 6))
    ..lineTo(tipX - arrowSize * math.cos(angle + math.pi / 6),
        tipY - arrowSize * math.sin(angle + math.pi / 6))
    ..close();
  canvas.drawPath(head, Paint()..color = color);
}

void drawImageArrow(Canvas canvas, double x, double baseY, double tipY,
    Color color, String label,
    {bool isDashed = false}) {
  final angle = math.atan2(tipY - baseY, 0.0);
  if (isDashed) {
    drawDashedLine(canvas, x, baseY, x, tipY,
        color.withValues(alpha: 0.85),
        pattern: const [5, 4], width: 2);
  } else {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;
    canvas.drawLine(Offset(x, baseY), Offset(x, tipY), paint);
  }
  drawArrowHead(canvas, x, tipY, angle, color, arrowSize: 12);
  paintText(canvas, label, x, tipY + (tipY > baseY ? 18 : -10), color,
      size: 12, align: TextAlign.center);
}

void drawImageRect(Canvas canvas, Image img, Rect dst,
    {double alpha = 1.0, bool flipX = false, bool flipY = false}) {
  final src = Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble());
  final paint = Paint()..filterQuality = FilterQuality.medium;
  if (alpha < 1.0) {
    paint.color = const Color(0xFFFFFFFF).withValues(alpha: alpha);
  }
  canvas.save();
  if (flipX || flipY) {
    canvas.translate(dst.center.dx, dst.center.dy);
    canvas.scale(flipX ? -1 : 1, flipY ? -1 : 1);
    canvas.drawImageRect(
      img,
      src,
      Rect.fromCenter(
          center: Offset.zero, width: dst.width, height: dst.height),
      paint,
    );
  } else {
    canvas.drawImageRect(img, src, dst, paint);
  }
  canvas.restore();
}

void drawSpriteObject(Canvas canvas, Image img, double x, double baseY,
    double topY,
    {String? label, Color labelColor = const Color(0xFFFACC15)}) {
  final hei = baseY - topY;
  final wid = hei * img.width / img.height;
  drawImageRect(
      canvas, img,
      Rect.fromCenter(
          center: Offset(x, (baseY + topY) / 2), width: wid, height: hei));
  if (label != null) {
    paintText(canvas, label, x - 35, topY - 7, labelColor, size: 12);
  }
  canvas.drawCircle(Offset(x, topY), 5, Paint()..color = const Color(0xFFFFFFFF));
}

void drawSpriteImage(Canvas canvas, Image img, double x, double baseY,
    double topY, Color color,
    {bool isVirtual = false, bool flipX = false}) {
  final h = baseY - topY;
  final ah = h.abs();
  final wid = ah * img.width / img.height;
  final src = Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble());
  canvas.save();
  canvas.translate(x, baseY);
  if (flipX) canvas.scale(-1, 1);
  if (h < 0) canvas.rotate(math.pi);
  var paint = Paint()..filterQuality = FilterQuality.medium;
  if (isVirtual) {
    paint = paint..color =
        const Color(0xFFFFFFFF).withValues(alpha: 0.5);
  }
  canvas.drawImageRect(img, src, Rect.fromLTWH(-wid / 2, -ah, wid, ah), paint);
  canvas.restore();
  final topYpos = baseY - h;
  paintText(
      canvas,
      isVirtual ? 'Virtual Image' : 'Real Image',
      x - 25,
      topYpos + (topYpos > baseY ? 18 : -10),
      color,
      size: 12);
}