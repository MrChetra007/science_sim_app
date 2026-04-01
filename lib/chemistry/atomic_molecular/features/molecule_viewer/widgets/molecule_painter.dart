import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import '../../../core/models/molecule.dart';
import '../../../core/theme/app_colors.dart';

class MoleculePainter extends CustomPainter {
  final Molecule molecule;
  final Matrix4 rotation;
  final double scale;

  const MoleculePainter({
    required this.molecule,
    required this.rotation,
    required this.scale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Transform all atoms into screen space
    final transformed = molecule.atoms.map((atom) {
      final pos4 = Vector4(
        atom.position.x * scale,
        atom.position.y * scale,
        atom.position.z * scale,
        1.0,
      );
      final rotated = rotation.transform(pos4);
      return _TransformedAtom(
        element: atom.element,
        color: atom.color,
        radius: atom.radius,
        screenPos: Offset(center.dx + rotated.x, center.dy - rotated.y),
        depth: rotated.z, // for depth sorting
      );
    }).toList();

    // Sort by depth (painter's algorithm — draw back first)
    transformed.sort((a, b) => a.depth.compareTo(b.depth));

    // Draw bonds (we map original atom indices to current indices)
    for (final bond in molecule.bonds) {
      final a = transformed[bond.atomA];
      final b = transformed[bond.atomB];
      _drawBond(canvas, a.screenPos, b.screenPos, bond.order);
    }

    // Draw atoms on top
    for (final atom in transformed) {
      _drawAtom(canvas, atom);
    }
  }

  void _drawAtom(Canvas canvas, _TransformedAtom atom) {
    // Depth-based size scaling
    final depthScale = (atom.depth / (scale * 3) + 1.0).clamp(0.7, 1.3);
    final r = atom.radius * depthScale;

    // Outer shadow for depth feel
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(atom.screenPos + const Offset(2, 2), r, shadowPaint);

    // Color fill
    final paint = Paint()..color = atom.color;
    canvas.drawCircle(atom.screenPos, r, paint);

    // Specular highlight
    final highlightPaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.white.withOpacity(0.6), Colors.white.withOpacity(0.0)],
        center: const Alignment(-0.35, -0.35),
        radius: 0.6,
      ).createShader(Rect.fromCircle(center: atom.screenPos, radius: r));
    canvas.drawCircle(atom.screenPos, r, highlightPaint);

    // Element symbol
    final tp = TextPainter(
      text: TextSpan(
        text: atom.element,
        style: TextStyle(
          fontSize: r * 0.8,
          fontWeight: FontWeight.bold,
          color: atom.color.computeLuminance() > 0.5 ? Colors.black87 : Colors.white,
          shadows: const [Shadow(blurRadius: 1, color: Colors.black26)],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, atom.screenPos - Offset(tp.width / 2, tp.height / 2));
  }

  void _drawBond(Canvas canvas, Offset a, Offset b, int order) {
    final dir = (b - a);
    final len = dir.distance;
    if (len < 5) return; // avoid drawing overlapping bonds

    final perp = Offset(-dir.dy, dir.dx) / len * 4.0;

    final List<Offset> offsets;
    switch (order) {
      case 1:
        offsets = [Offset.zero];
        break;
      case 2:
        offsets = [-perp, perp];
        break;
      default:
        offsets = [-perp * 1.5, Offset.zero, perp * 1.5];
    }

    final paint = Paint()
      ..color = AppColors.textSecondary.withOpacity(0.4)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (final off in offsets) {
      canvas.drawLine(a + off, b + off, paint);
    }
  }

  @override
  bool shouldRepaint(MoleculePainter old) =>
      old.rotation != rotation || old.molecule != molecule || old.scale != scale;
}

class _TransformedAtom {
  final String element;
  final Color color;
  final double radius;
  final Offset screenPos;
  final double depth;

  _TransformedAtom({
    required this.element,
    required this.color,
    required this.radius,
    required this.screenPos,
    required this.depth,
  });
}
