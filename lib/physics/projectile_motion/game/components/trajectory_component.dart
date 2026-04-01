import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import '../../models/trajectory_data.dart';
import '../projectile_game.dart';

/// Draws the trajectory arc — revealing it progressively as [currentTime] advances.
class TrajectoryComponent extends Component {
  final ProjectileGame game;
  final bool isGhost;
  final Color color;
  TrajectoryData? _trajectory;
  double _revealedTime = 0;

  TrajectoryComponent({
    required this.game,
    this.isGhost = false,
    this.color = const Color(0xFFFFD54F),
  });

  late final Paint _pathPaint = Paint()
    ..color = color.withValues(alpha: isGhost ? 0.2 : 0.8)
    ..strokeWidth = isGhost ? 2.0 : 3.0
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  late final Paint _glowPaint = Paint()
    ..color = color.withValues(alpha: isGhost ? 0.05 : 0.25)
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

  late final Paint _dotPaint = Paint()
    ..color = color.withValues(alpha: isGhost ? 0.1 : 0.4);

  double _pulseTime = 0;

  void setTrajectory(TrajectoryData traj) {
    _trajectory = traj;
    _revealedTime = 0;
    _pulseTime = 0;
  }

  @override
  void update(double dt) {
    _pulseTime += dt * 5;
  }

  void setRevealedTime(double t) => _revealedTime = t;

  void clear() {
    _trajectory = null;
    _revealedTime = 0;
  }

  @override
  void render(Canvas canvas) {
    final mapper = game.mapper;
    final traj = _trajectory;
    if (mapper == null || traj == null || traj.points.isEmpty) return;

    final path = Path();
    bool started = false;

    for (final pt in traj.points) {
      if (pt.t > _revealedTime + 0.001) break;
      final s = mapper.toScreen(pt.x, pt.y);
      if (!started) {
        path.moveTo(s.dx, s.dy);
        started = true;
      } else {
        path.lineTo(s.dx, s.dy);
      }
    }

    if (started) {
      // Draw pulsating glow
      final pulse = (0.5 + 0.5 * math.sin(_pulseTime)).clamp(0.0, 1.0);
      _glowPaint.strokeWidth = 6.0 + pulse * 4.0;
      _glowPaint.color =
          const Color(0xFFFFD54F).withValues(alpha: 0.1 + pulse * 0.2);
      canvas.drawPath(path, _glowPaint);

      // Draw primary path
      canvas.drawPath(path, _pathPaint);

      // Draw small dots at sample points for PhET-style visual
      for (final pt in traj.points) {
        if (pt.t > _revealedTime + 0.001) break;
        final s = mapper.toScreen(pt.x, pt.y);
        canvas.drawCircle(Offset(s.dx, s.dy), 2.5, _dotPaint);
      }
    }

    // Full ghost arc (faint) to show complete trajectory before animation ends
    if (_revealedTime < traj.hangTime * 0.05) {
      // Don't show ghost at start
    } else {
      final ghostPaint = Paint()
        ..color = const Color(0x22FFD54F)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;

      final ghostPath = Path();
      bool gStarted = false;
      for (final pt in traj.points) {
        final s = mapper.toScreen(pt.x, pt.y);
        if (!gStarted) {
          ghostPath.moveTo(s.dx, s.dy);
          gStarted = true;
        } else {
          ghostPath.lineTo(s.dx, s.dy);
        }
      }
      if (gStarted) canvas.drawPath(ghostPath, ghostPaint);
    }
  }
}
