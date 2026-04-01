import 'package:flutter/material.dart';
import '../constants/indicators.dart';

class IndicatorCalculator {
  static Color colorForPH(Indicator indicator, double ph) {
    if (ph < indicator.transitionLow) return indicator.acidColor;
    if (ph > indicator.transitionHigh) return indicator.baseColor;

    // Transition range interpolation
    final t = (ph - indicator.transitionLow) /
        (indicator.transitionHigh - indicator.transitionLow);

    // We interpolate from acid -> neutral -> base
    if (t < 0.5) {
      return Color.lerp(indicator.acidColor, indicator.neutralColor, t * 2)!;
    } else {
      return Color.lerp(
          indicator.neutralColor, indicator.baseColor, (t - 0.5) * 2)!;
    }
  }
}
