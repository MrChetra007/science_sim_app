import 'dart:math' as math;
import '../../../l10n/generated/app_localizations.dart';

String generateFullDerivation({
  required double v0,
  required double angleDeg,
  required double h0,
  required double g,
  required bool airResistance,
  required AppLocalizations l10n,
}) {
  if (airResistance) {
    return r'''
# ''' + l10n.pAirResistanceBreakdown + r'''
''' + l10n.pDoesMassMatter + r'''
**''' + l10n.pYes + r'''!** ''' + l10n.pInTheRealWorld + r''', mass determines how much an object "resists" being slowed down by the air (Inertia). 
- **''' + l10n.pHigherMass + r''': ''' + l10n.pFurtherRange + r'''
- **''' + l10n.pLowerMass + r''': ''' + l10n.pShorterRange + r'''

### ''' + l10n.pHowItsCalculated + r'''
''' + l10n.pWeUseEuler + r''':
1. ''' + l10n.pAtEachTimeStep + r'''
2. ''' + l10n.pCalculateDragForce + r'''
3. ''' + l10n.pUpdateAcceleration + r'''
4. ''' + l10n.pUpdateVelocity + r'''

''' + l10n.pBowlingBall + r'''
''';
  }

  final angleRad = angleDeg * math.pi / 180.0;
  final vx = v0 * math.cos(angleRad);
  final vy = v0 * math.sin(angleRad);
  final tPeak = vy / g;
  final peakH = h0 + (vy * vy) / (2 * g);

  final disc = vy * vy + 2 * g * h0;
  final hangTime = (vy + math.sqrt(disc)) / g;
  final range = vx * hangTime;

  final v0Str = v0.toStringAsFixed(1);
  return r'''
# ''' + l10n.pStepByStepDerivation + r''' (''' + l10n.pIdealCase + r''')

> [!NOTE]
> **''' + l10n.pGalileoPrinciple + r'''**
> ''' + l10n.pInVacuum + r''', mass does **not** affect the trajectory. Whether you launch a golf ball or a bowling ball, gravity accelerates them at the same rate (g = ''' + g.toStringAsFixed(2) + r''' m/s²).

### ''' + l10n.pVelocityComponents + r'''
Break initial velocity (v_0 = ''' + v0Str + r''' m/s) into Horizontal (v_x) and Vertical (v_y) components using trigonometry:
- v_x = v_0 · cos(''' + angleDeg.toStringAsFixed(0) + r'''°) = ''' + vx.toStringAsFixed(2) + r''' m/s
- v_y = v_0 · sin(''' + angleDeg.toStringAsFixed(0) + r'''°) = ''' + vy.toStringAsFixed(2) + r''' m/s

### ''' + l10n.pTimeToPeakHeight + r'''
''' + l10n.pAtThePeak + r''', vertical velocity v_y is 0. Solving v_y = v_y0 - g t:
- 0 = ''' + vy.toStringAsFixed(2) + r''' - ''' + g.toStringAsFixed(2) + r''' · t_peak
- t_peak = ''' + vy.toStringAsFixed(2) + r''' / ''' + g.toStringAsFixed(2) + r''' = ''' + tPeak.toStringAsFixed(3) + r''' s

### ''' + l10n.pMaximumHeight + r'''
''' + l10n.pUsingDisplacement + r''':
- y_max = ''' + h0.toStringAsFixed(1) + r''' + (''' + vy.toStringAsFixed(2) + r''' · ''' + tPeak.toStringAsFixed(3) + r''') - (0.5 · ''' + g.toStringAsFixed(2) + r''' · ''' + tPeak.toStringAsFixed(3) + r'''²)
- y_max = ''' + peakH.toStringAsFixed(2) + r''' m

### ''' + l10n.pTotalHangTime + r'''
''' + l10n.pSolveQuadratic + r''':
$$0 = h_0 + v_y t - ½ g t^2$$
$$0 = ''' + h0.toStringAsFixed(1) + r''' + ''' + vy.toStringAsFixed(2) + r''' t - ''' + (g / 2).toStringAsFixed(2) + r''' t^2$$

''' + l10n.pUsingQuadraticFormula + r''':
- t = (''' + vy.toStringAsFixed(2) + r''' + √(''' + vy.toStringAsFixed(2) + r''')² + 2 · ''' + g.toStringAsFixed(2) + r''' · ''' + h0.toStringAsFixed(1) + r''')) / ''' + g.toStringAsFixed(2) + r'''
- t_total = ''' + hangTime.toStringAsFixed(3) + r''' s

### ''' + l10n.pHorizontalRange + r'''
''' + l10n.pInIdealCase + r''', horizontal velocity v_x is constant.
- R = v_x · t_total
- R = ''' + vx.toStringAsFixed(2) + r''' · ''' + hangTime.toStringAsFixed(3) + r'''
- R = ''' + range.toStringAsFixed(2) + r''' m
''';
}