import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import '../../models/trajectory_data.dart';
import '../../physics/projectile_objects.dart';
import '../projectile_game.dart';

/// Draws the projectile with a unique shape per object type.
class ProjectileComponent extends Component {
  final ProjectileGame game;
  TrajectoryData? _trajectory;
  double _currentTime = 0;
  bool isVisible = false;

  ProjectileComponent({required this.game});

  double _impactDoneTime = -1.0;

  void setTrajectory(TrajectoryData traj) {
    _trajectory = traj;
    isVisible = true;
    _impactDoneTime = -1.0;
  }

  void setTime(double t) => _currentTime = t;

  @override
  void render(Canvas canvas) {
    if (!isVisible) return;
    final mapper = game.mapper;
    final traj = _trajectory;
    if (mapper == null || traj == null) return;

    final pt = traj.interpolateAt(_currentTime);
    if (pt == null) return;

    final s = mapper.toScreen(pt.x, pt.y);
    final r = game.projectileRadius;

    // Glow
    canvas.drawCircle(
      Offset(s.dx, s.dy),
      r + 5,
      Paint()
        ..color = const Color(0x33FFFFFF)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Draw unique shape per object
    _drawShape(canvas, Offset(s.dx, s.dy), r, game.projectileObjectId);

    // Draw Force Vectors (Educational)
    if (game.showForces) {
      _drawForceVectors(canvas, Offset(s.dx, s.dy), pt);
    }

    // Draw Velocity Vectors (Educational)
    if (game.showVelocity) {
      _drawVelocityVectors(canvas, Offset(s.dx, s.dy), pt);
    }

    // Landing X marker & Impact effect
    if (_currentTime >= traj.hangTime - 0.015) {
      _drawLanding(canvas, mapper, traj);
      _drawImpact(canvas, s);
    }
  }

  void _drawImpact(Canvas canvas, Offset center) {
    if (_impactDoneTime < 0) _impactDoneTime = 0;
    // We can't easily track local time here since it's a Component,
    // but the game's _currentTime keeps increasing slightly or we can use dt.
    // Actually, let's use a simpler approach: use the hangTime overflow.

    final overflow = _currentTime - (_trajectory?.hangTime ?? 0);
    if (overflow < 0) return;

    final progress = (overflow / 0.5).clamp(0.0, 1.0); // 0.5s impact animation
    if (progress >= 1.0) return;

    final paint = Paint()
      ..color = const Color(0xFFFF5252).withValues(alpha: 1.0 - progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, 10 + progress * 40, paint);
  }

  void _drawShape(Canvas canvas, Offset c, double r, String objectId) {
    switch (objectId) {
      case 'cannonball':
        _drawCannonball(canvas, c, r);
      case 'golfball':
        _drawGolfball(canvas, c, r);
      case 'baseball':
        _drawBaseball(canvas, c, r);
      case 'bowlingball':
        _drawBowlingball(canvas, c, r);
      case 'pumpkin':
        _drawPumpkin(canvas, c, r);
      case 'human':
        _drawHuman(canvas, c, r);
      case 'piano':
        _drawPiano(canvas, c, r);
      case 'car':
        _drawCar(canvas, c, r);
      default:
        _drawCannonball(canvas, c, r);
    }
  }

  // ── Cannonball — black metallic sphere ───────────────────────────────────
  void _drawCannonball(Canvas canvas, Offset c, double r) {
    canvas.drawCircle(c, r, Paint()..color = const Color(0xFF3A3A3A));
    canvas.drawCircle(
        c,
        r,
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(-0.4, -0.4),
            radius: 0.7,
            colors: [const Color(0xFF888888), const Color(0xFF1A1A1A)],
          ).createShader(Rect.fromCircle(center: c, radius: r)));
  }

  // ── Golf Ball — white with dimple dots ───────────────────────────────────
  void _drawGolfball(Canvas canvas, Offset c, double r) {
    canvas.drawCircle(c, r, Paint()..color = const Color(0xFFEEEEEE));
    final dimplePaint = Paint()..color = const Color(0xFFCCCCCC);
    final offsets = [
      Offset(-r * 0.3, -r * 0.3),
      Offset(r * 0.3, -r * 0.3),
      Offset(0, r * 0.35),
      Offset(-r * 0.45, r * 0.1),
      Offset(r * 0.45, r * 0.1),
    ];
    for (final o in offsets) {
      canvas.drawCircle(c + o, r * 0.18, dimplePaint);
    }
    canvas.drawCircle(
        c,
        r,
        Paint()
          ..color = const Color(0x22FFFFFF)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));
  }

  // ── Baseball — off-white with red stitches ───────────────────────────────
  void _drawBaseball(Canvas canvas, Offset c, double r) {
    canvas.drawCircle(c, r, Paint()..color = const Color(0xFFF5F5DC));
    final stitch = Paint()
      ..color = const Color(0xFFCC0000)
      ..strokeWidth = r * 0.12
      ..style = PaintingStyle.stroke;
    // Left curve
    final lPath = Path()
      ..moveTo(c.dx - r * 0.1, c.dy - r * 0.6)
      ..cubicTo(c.dx - r * 0.5, c.dy - r * 0.2, c.dx - r * 0.5, c.dy + r * 0.2,
          c.dx - r * 0.1, c.dy + r * 0.6);
    canvas.drawPath(lPath, stitch);
    // Right curve
    final rPath = Path()
      ..moveTo(c.dx + r * 0.1, c.dy - r * 0.6)
      ..cubicTo(c.dx + r * 0.5, c.dy - r * 0.2, c.dx + r * 0.5, c.dy + r * 0.2,
          c.dx + r * 0.1, c.dy + r * 0.6);
    canvas.drawPath(rPath, stitch);
  }

  // ── Bowling Ball — dark with 3 holes ─────────────────────────────────────
  void _drawBowlingball(Canvas canvas, Offset c, double r) {
    canvas.drawCircle(c, r, Paint()..color = const Color(0xFF1A1A2E));
    canvas.drawCircle(
        c,
        r,
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(-0.3, -0.3),
            radius: 0.8,
            colors: [const Color(0xFF3A3A5E), const Color(0xFF050510)],
          ).createShader(Rect.fromCircle(center: c, radius: r)));
    final holePaint = Paint()..color = const Color(0xFF000000);
    canvas.drawCircle(
        Offset(c.dx - r * 0.2, c.dy - r * 0.3), r * 0.15, holePaint);
    canvas.drawCircle(
        Offset(c.dx + r * 0.25, c.dy - r * 0.25), r * 0.11, holePaint);
    canvas.drawCircle(
        Offset(c.dx + r * 0.05, c.dy - r * 0.5), r * 0.11, holePaint);
  }

  // ── Pumpkin — orange oval ─────────────────────────────────────────────────
  void _drawPumpkin(Canvas canvas, Offset c, double r) {
    final segments = [
      Offset(c.dx - r * 0.35, c.dy),
      Offset(c.dx, c.dy),
      Offset(c.dx + r * 0.35, c.dy),
    ];
    final colors = [
      const Color(0xFFE55A00),
      const Color(0xFFFF6B35),
      const Color(0xFFE55A00),
    ];
    for (int i = 0; i < 3; i++) {
      canvas.drawOval(
        Rect.fromCenter(center: segments[i], width: r * 0.9, height: r * 1.7),
        Paint()..color = colors[i],
      );
    }
    // Stem
    canvas.drawRect(
      Rect.fromLTWH(c.dx - r * 0.07, c.dy - r * 1.1, r * 0.14, r * 0.4),
      Paint()..color = const Color(0xFF4A7C3F),
    );
  }

  // ── Human — stick figure ──────────────────────────────────────────────────
  void _drawHuman(Canvas canvas, Offset c, double r) {
    final p = Paint()
      ..color = const Color(0xFFFFB366)
      ..strokeWidth = r * 0.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Head
    canvas.drawCircle(Offset(c.dx, c.dy - r * 0.65), r * 0.28,
        Paint()..color = const Color(0xFFFFB366));
    // Body
    canvas.drawLine(
        Offset(c.dx, c.dy - r * 0.35), Offset(c.dx, c.dy + r * 0.2), p);
    // Arms
    canvas.drawLine(Offset(c.dx - r * 0.45, c.dy - r * 0.1),
        Offset(c.dx + r * 0.45, c.dy - r * 0.1), p);
    // Legs
    canvas.drawLine(Offset(c.dx, c.dy + r * 0.2),
        Offset(c.dx - r * 0.3, c.dy + r * 0.75), p);
    canvas.drawLine(Offset(c.dx, c.dy + r * 0.2),
        Offset(c.dx + r * 0.3, c.dy + r * 0.75), p);
  }

  // ── Piano — dark rectangle with keys ─────────────────────────────────────
  void _drawPiano(Canvas canvas, Offset c, double r) {
    // Body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: c, width: r * 2.2, height: r * 1.6),
        Radius.circular(r * 0.15),
      ),
      Paint()..color = const Color(0xFF1A1A1A),
    );
    // White keys
    final keyW = r * 0.25;
    for (int i = 0; i < 6; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
              c.dx - r * 0.9 + i * keyW + 1, c.dy - r * 0.6, keyW - 2, r * 0.9),
          const Radius.circular(2),
        ),
        Paint()..color = const Color(0xFFEEEEEE),
      );
    }
    // Black keys
    final bOffsets = [0.18, 0.62, 1.35, 1.78, 2.22];
    for (final bx in bOffsets) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
              c.dx - r * 0.9 + bx * keyW, c.dy - r * 0.6, keyW * 0.6, r * 0.55),
          const Radius.circular(2),
        ),
        Paint()..color = const Color(0xFF000000),
      );
    }
  }

  // ── Car — rectangle with wheels ───────────────────────────────────────────
  void _drawCar(Canvas canvas, Offset c, double r) {
    // Body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(c.dx - r, c.dy - r * 0.45, r * 2, r * 0.9),
        Radius.circular(r * 0.15),
      ),
      Paint()..color = const Color(0xFF3A86FF),
    );
    // Cabin
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(c.dx - r * 0.55, c.dy - r * 0.9, r * 1.1, r * 0.5),
        Radius.circular(r * 0.15),
      ),
      Paint()..color = const Color(0xFF2E76EF),
    );
    // Windows
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(c.dx - r * 0.5, c.dy - r * 0.85, r * 0.42, r * 0.35),
        Radius.circular(r * 0.08),
      ),
      Paint()..color = const Color(0xFF87CEEB).withValues(alpha: 0.8),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(c.dx + r * 0.05, c.dy - r * 0.85, r * 0.42, r * 0.35),
        Radius.circular(r * 0.08),
      ),
      Paint()..color = const Color(0xFF87CEEB).withValues(alpha: 0.8),
    );
    // Wheels
    final wPaint = Paint()..color = const Color(0xFF222222);
    final rPaint = Paint()..color = const Color(0xFF888888);
    for (final wx in [c.dx - r * 0.55, c.dx + r * 0.55]) {
      canvas.drawCircle(Offset(wx, c.dy + r * 0.4), r * 0.28, wPaint);
      canvas.drawCircle(Offset(wx, c.dy + r * 0.4), r * 0.14, rPaint);
    }
  }

  void _drawLanding(
      Canvas canvas, CoordinateMapper mapper, TrajectoryData traj) {
    final land = mapper.toScreen(traj.range, 0);
    final p = Paint()
      ..color = const Color(0xFFFF5252)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    const sz = 10.0;
    canvas.drawLine(Offset(land.dx - sz, land.dy - sz),
        Offset(land.dx + sz, land.dy + sz), p);
    canvas.drawLine(Offset(land.dx + sz, land.dy - sz),
        Offset(land.dx - sz, land.dy + sz), p);
    // Range label
    final tp = TextPainter(
      text: TextSpan(
        text: '${traj.range.toStringAsFixed(1)} m',
        style: const TextStyle(
            color: Color(0xFFFF5252),
            fontSize: 11,
            fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(land.dx - tp.width / 2, land.dy + 10));
  }

  void _drawForceVectors(Canvas canvas, Offset center, TrajectoryPoint pt) {
    final obj = objectById(game.projectileObjectId);
    final g = game.gravityValue;

    // 1. Gravity (Down)
    // Fg = m * g. Let's scale it so it looks meaningful on screen.
    // Base length: 1m in pixels roughly? No, let's normalize.
    final fgMagnitude = obj.mass * g;
    // Visually scale: 10 pixels for 10N? Let's use a log or relative scale.
    final fgLen = (fgMagnitude * 0.5).clamp(20.0, 100.0);
    _drawArrow(canvas, center, center + Offset(0, fgLen),
        const Color(0xFF00E5FF), 'Fg');

    // 2. Air Resistance (Opposite to velocity)
    if (_trajectory?.points.first.vx != 0 ||
        _trajectory?.points.first.vy != 0) {
      // Basic drag formula for visualization: Fd = 0.5 * rho * v² * Cd * A
      const rho = 1.225;
      final speedSq = pt.vx * pt.vx + pt.vy * pt.vy;
      final fdMagnitude =
          0.5 * rho * speedSq * obj.dragCoefficient * obj.crossSectionalArea;

      if (fdMagnitude > 0.1) {
        final speed = math.sqrt(speedSq);
        final dirX = -pt.vx / speed;
        final dirY =
            pt.vy / speed; // vy is positive up, screen Y is positive down
        // Screen direction: opposite to velocity.
        // Screen Vx positive is Right. Screen Vy positive is Down.
        // Physical Vx positive is Right. Physical Vy positive is Up.
        // So Screen direction = (-vx, vy)
        final fdLen = (fdMagnitude * 2.0).clamp(5.0, 80.0);
        _drawArrow(canvas, center, center + Offset(dirX * fdLen, dirY * fdLen),
            const Color(0xFFFF5252), 'Fd');
      }
    }
  }

  void _drawArrow(
      Canvas canvas, Offset start, Offset end, Color color, String label) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, paint);

    // Tip
    final dir = (end - start);
    final len = dir.distance;
    if (len < 5) return;

    final unit = dir / len;
    final normal = Offset(-unit.dy, unit.dx);
    const arrowSize = 6.0;

    final path = Path()
      ..moveTo(end.dx, end.dy)
      ..lineTo(end.dx - unit.dx * arrowSize + normal.dx * arrowSize * 0.6,
          end.dy - unit.dy * arrowSize + normal.dy * arrowSize * 0.6)
      ..lineTo(end.dx - unit.dx * arrowSize - normal.dx * arrowSize * 0.6,
          end.dy - unit.dy * arrowSize - normal.dy * arrowSize * 0.6)
      ..close();

    canvas.drawPath(path, Paint()..color = color);

    // Label
    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style:
            TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, end + unit * 5);
  }

  void _drawVelocityVectors(Canvas canvas, Offset center, TrajectoryPoint pt) {
    // Scale velocity vectors so they are visible but not overwhelming.
    // 3 pixels per m/s seems reasonable.
    const vScale = 3.0;

    // 1. Horizontal Velocity (Vx) - Green
    if (pt.vx.abs() > 0.1) {
      _drawArrow(canvas, center, center + Offset(pt.vx * vScale, 0),
          const Color(0xFF69FF47), 'Vx');
    }

    // 2. Vertical Velocity (Vy) - Blue
    if (pt.vy.abs() > 0.1) {
      // Physical Vy positive is UP. Screen Y positive is DOWN.
      _drawArrow(canvas, center, center + Offset(0, -pt.vy * vScale),
          const Color(0xFF448AFF), 'Vy');
    }

    // 3. Resultant Velocity (V) - White
    final speed = math.sqrt(pt.vx * pt.vx + pt.vy * pt.vy);
    if (speed > 0.1) {
      _drawArrow(
          canvas,
          center,
          center + Offset(pt.vx * vScale, -pt.vy * vScale),
          const Color(0xFFFFFFFF),
          'V');
    }
  }
}
