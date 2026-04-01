enum SurfaceType {
  ice,
  wood,
  rubber,
  sand
}

class FrictionModel {
  static double getCoefficient(SurfaceType type) {
    switch (type) {
      case SurfaceType.ice: return 0.02;
      case SurfaceType.wood: return 0.30;
      case SurfaceType.rubber: return 0.60;
      case SurfaceType.sand: return 0.85;
    }
  }

  static String getName(SurfaceType type) {
    switch (type) {
      case SurfaceType.ice: return "Ice (μ=0.02)";
      case SurfaceType.wood: return "Wood (μ=0.30)";
      case SurfaceType.rubber: return "Rubber (μ=0.60)";
      case SurfaceType.sand: return "Sand (μ=0.85)";
    }
  }
}
