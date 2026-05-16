import 'dart:ui';
import 'package:flame/components.dart';

class EnergyBarComponent extends PositionComponent {
  final Paint _bgPaint = Paint()..color = const Color(0xFF1B1B1B);

  double _displayedKE = 0;
  double _displayedPE = 0;
  double _displayedTotal = 1;
  double kineticEnergy = 0;
  double potentialEnergy = 0;
  double totalEnergy = 1;

  @override
  void render(Canvas canvas) {
    final w = size.x;
    final h = size.y;
    if (w <= 0 || h <= 0) return;

    const lerpSpeed = 0.15;
    _displayedKE += (kineticEnergy - _displayedKE) * lerpSpeed;
    _displayedPE += (potentialEnergy - _displayedPE) * lerpSpeed;
    _displayedTotal += (totalEnergy - _displayedTotal) * lerpSpeed;

    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), _bgPaint);

    final total = _displayedTotal > 0 ? _displayedTotal : 1.0;
    const barHeight = 20.0;
    const spacing = 8.0;
    const labelW = 28.0;
    final barW = (w - labelW - 24) / 3;
    final topPad = (h - barHeight) / 2;

    _drawBar(canvas, 'KE', 12, topPad, _displayedKE / total, barW, barHeight, const Color(0xFFFF6F00));
    _drawBar(canvas, 'PE', 12 + barW + spacing, topPad, _displayedPE / total, barW, barHeight, const Color(0xFF42A5F5));
    _drawBar(canvas, 'E', 12 + 2 * (barW + spacing), topPad, 1.0, barW, barHeight, const Color(0xFFFFFFFF));
  }

  void _drawBar(Canvas canvas, String label, double x, double y, double fraction, double w, double h, Color color) {
    final barRect = Rect.fromLTWH(x, y, w, h);
    canvas.drawRect(barRect, Paint()..color = const Color(0xFF2A2A2A));

    final fillW = (w * fraction).clamp(0.0, w).toDouble();
    if (fillW > 0) {
      canvas.drawRect(
        Rect.fromLTWH(x, y, fillW, h),
        Paint()..color = color,
      );
    }

    final tp = ParagraphBuilder(ParagraphStyle(textAlign: TextAlign.center))
      ..pushStyle(TextStyle(color: const Color(0xFFFFFFFF), fontSize: 10))
      ..addText(label);
    final para = tp.build()..layout(const ParagraphConstraints(width: 28));
    canvas.drawParagraph(para, Offset(x + w / 2 - 14, y + h / 2 - 6));

    final valTp = ParagraphBuilder(ParagraphStyle(textAlign: TextAlign.center))
      ..pushStyle(TextStyle(color: color, fontSize: 8))
      ..addText('${(fraction * totalEnergy).toStringAsFixed(3)} J');
    final valPara = valTp.build()..layout(ParagraphConstraints(width: w));
    canvas.drawParagraph(valPara, Offset(x, y + h + 1));
  }
}
