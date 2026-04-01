import 'dart:math' as math;

class TrajectoryPoint {
  final double x; // meters (horizontal from launch)
  final double y; // meters (above ground)
  final double t; // seconds
  final double vx; // m/s
  final double vy; // m/s

  const TrajectoryPoint({
    required this.x,
    required this.y,
    required this.t,
    required this.vx,
    required this.vy,
  });

  double get speed => math.sqrt(vx * vx + vy * vy);
}

class TrajectoryData {
  final List<TrajectoryPoint> points;
  final double range; // horizontal distance at landing (m)
  final double maxHeight; // max absolute height above ground (m)
  final double hangTime; // total flight time (s)

  const TrajectoryData({
    required this.points,
    required this.range,
    required this.maxHeight,
    required this.hangTime,
  });

  bool get isEmpty => points.isEmpty;

  /// Interpolate position at a given simulation time
  TrajectoryPoint? interpolateAt(double t) {
    if (points.isEmpty) return null;
    if (t <= 0) return points.first;
    if (t >= hangTime) return points.last;

    // Binary search for the surrounding points
    int lo = 0;
    int hi = points.length - 1;
    while (lo < hi - 1) {
      final mid = (lo + hi) ~/ 2;
      if (points[mid].t <= t) {
        lo = mid;
      } else {
        hi = mid;
      }
    }

    final p0 = points[lo];
    final p1 = points[hi];
    if (p1.t == p0.t) return p0;

    final frac = (t - p0.t) / (p1.t - p0.t);
    return TrajectoryPoint(
      x: p0.x + (p1.x - p0.x) * frac,
      y: p0.y + (p1.y - p0.y) * frac,
      t: t,
      vx: p0.vx + (p1.vx - p0.vx) * frac,
      vy: p0.vy + (p1.vy - p0.vy) * frac,
    );
  }
}
