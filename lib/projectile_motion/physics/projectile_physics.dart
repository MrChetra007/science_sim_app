import 'dart:math' as math;
import '../models/trajectory_data.dart';
import '../models/projectile_object.dart';
import 'air_resistance.dart';

/// Core projectile physics engine.
/// Uses analytical solution when air resistance is OFF (exact).
/// Delegates to [AirResistancePhysics] when air resistance is ON (Euler).
class ProjectilePhysics {
  /// Compute a full trajectory [TrajectoryData] from launch parameters.
  static TrajectoryData computeTrajectory({
    required double v0, // initial speed (m/s)
    required double angleDeg, // launch angle (degrees, 0–90)
    required double h0, // initial height above ground (m)
    required double gravity, // gravitational acceleration (m/s²)
    bool airResistance = false,
    ProjectileObject? object,
  }) {
    if (airResistance && object != null) {
      return AirResistancePhysics.computeTrajectory(
        v0: v0,
        angleDeg: angleDeg,
        h0: h0,
        gravity: gravity,
        mass: object.mass,
        dragCoefficient: object.dragCoefficient,
        crossSectionalArea: object.crossSectionalArea,
      );
    }
    return _analyticalTrajectory(v0, angleDeg, h0, gravity);
  }

  static TrajectoryData _analyticalTrajectory(
    double v0,
    double angleDeg,
    double h0,
    double gravity,
  ) {
    final angleRad = angleDeg * math.pi / 180.0;
    final vx = v0 * math.cos(angleRad);
    final vy = v0 * math.sin(angleRad);

    // Hang time from: h0 + vy*t - 0.5*g*t² = 0  →  quadratic
    // t = (vy + sqrt(vy² + 2*g*h0)) / g
    final discriminant = vy * vy + 2 * gravity * h0;
    final hangTime =
        discriminant >= 0 ? (vy + math.sqrt(discriminant)) / gravity : 0.0;

    // Peak time and peak height
    final tPeak = gravity > 0 ? vy / gravity : 0.0;
    final peakHeight =
        tPeak > 0 ? h0 + vy * tPeak - 0.5 * gravity * tPeak * tPeak : h0;
    final maxHeight = peakHeight > h0 ? peakHeight : h0;

    final range = vx * hangTime;

    // Sample trajectory into evenly-spaced time steps
    const int targetSamples = 120;
    final dt = hangTime > 0 ? hangTime / targetSamples : 0.0;
    final points = <TrajectoryPoint>[];

    for (int i = 0; i <= targetSamples; i++) {
      final t = i * dt;
      final x = vx * t;
      final y =
          (h0 + vy * t - 0.5 * gravity * t * t).clamp(0.0, double.infinity);
      final currentVy = vy - gravity * t;
      points.add(TrajectoryPoint(x: x, y: y, t: t, vx: vx, vy: currentVy));
    }

    // Ensure final point is exactly at ground (x = range, y = 0)
    if (points.isNotEmpty) {
      final last = points.last;
      points[points.length - 1] = TrajectoryPoint(
        x: range,
        y: 0,
        t: hangTime,
        vx: last.vx,
        vy: last.vy,
      );
    }

    return TrajectoryData(
      points: points,
      range: range,
      maxHeight: maxHeight,
      hangTime: hangTime,
    );
  }

  /// Compute range for a single angle (used for Range vs Angle graph).
  static double rangeForAngle({
    required double v0,
    required double angleDeg,
    required double h0,
    required double gravity,
  }) {
    final angleRad = angleDeg * math.pi / 180.0;
    final vx = v0 * math.cos(angleRad);
    final vy = v0 * math.sin(angleRad);
    final disc = vy * vy + 2 * gravity * h0;
    if (disc < 0) return 0;
    final hangTime = (vy + math.sqrt(disc)) / gravity;
    return vx * hangTime;
  }
}
