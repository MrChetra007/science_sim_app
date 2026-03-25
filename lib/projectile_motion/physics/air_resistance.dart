import 'dart:math' as math;
import '../models/trajectory_data.dart';

/// Air density at sea level (kg/m³)
const double _rho = 1.225;

class AirResistancePhysics {
  /// Compute trajectory with drag force using Euler numerical integration.
  /// F_drag = 0.5 × ρ × Cd × A × v²
  static TrajectoryData computeTrajectory({
    required double v0,
    required double angleDeg,
    required double h0,
    required double gravity,
    required double mass,
    required double dragCoefficient,
    required double crossSectionalArea,
    double dt = 0.02,
  }) {
    final angleRad = angleDeg * math.pi / 180.0;
    double x = 0;
    double y = h0;
    double vx = v0 * math.cos(angleRad);
    double vy = v0 * math.sin(angleRad);
    double t = 0;

    double maxY = h0;
    final points = <TrajectoryPoint>[
      TrajectoryPoint(x: x, y: y, t: t, vx: vx, vy: vy),
    ];

    while (y >= -0.001 && t < 2000) {
      final speed = math.sqrt(vx * vx + vy * vy);
      double ax = 0;
      double ay = -gravity;

      if (speed > 1e-9) {
        final dragMag =
            0.5 * _rho * dragCoefficient * crossSectionalArea * speed * speed;
        ax = -dragMag * vx / (speed * mass);
        ay += -dragMag * vy / (speed * mass);
      }

      vx += ax * dt;
      vy += ay * dt;
      x += vx * dt;
      y += vy * dt;
      t += dt;

      if (y > maxY) maxY = y;

      if (y < 0) {
        // Interpolate exact landing point
        final prev = points.last;
        final frac = prev.y / (prev.y - y);
        final landX = prev.x + (x - prev.x) * frac;
        final landT = prev.t + (t - prev.t) * frac;
        points.add(TrajectoryPoint(x: landX, y: 0, t: landT, vx: vx, vy: vy));
        return TrajectoryData(
          points: points,
          range: landX,
          maxHeight: maxY,
          hangTime: landT,
        );
      }

      points.add(TrajectoryPoint(x: x, y: y, t: t, vx: vx, vy: vy));
    }

    return TrajectoryData(
      points: points,
      range: points.last.x,
      maxHeight: maxY,
      hangTime: points.last.t,
    );
  }
}
