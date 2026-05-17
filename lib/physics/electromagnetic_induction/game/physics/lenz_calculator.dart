class LenzCalculator {
  static int currentDirection(double emf) =>
      emf > 0 ? 1 : (emf < 0 ? -1 : 0);

  static bool isClockwise(double emf) => emf > 0;
}
