import 'dart:math' as math;

/// Utility to generate step-by-step mathematical derivations for the simulation.
class MathSolver {
  final double v0;
  final double angleDeg;
  final double h0;
  final double g;
  final bool airResistance;

  MathSolver({
    required this.v0,
    required this.angleDeg,
    required this.h0,
    required this.g,
    required this.airResistance,
  });

  /// Generates a step-by-step breakdown for the analytical case.
  String generateFullDerivation() {
    if (airResistance) {
      return r'''
# Air Resistance Breakdown
When Air Resistance is **ON**, the trajectory is no longer a simple parabola. 

### Does Mass Matter?
**Yes!** In the real world, mass determines how much an object "resists" being slowed down by the air (Inertia). 
- **Higher Mass**: The air has a harder time slowing the object down $\rightarrow$ Further range.
- **Lower Mass**: The air easily decelerates the object $\rightarrow$ Shorter range.

### How it's Calculated
We use **Euler Integration** to solve the motion numerically:
1. At each time step ($dt$):
2. Calculate Drag Force: $F_d = \frac{1}{2} \rho v^2 C_d A$
3. Update Acceleration: $a = \frac{F_{net}}{m}$ (Note how mass $m$ is the divisor!)
4. Update Velocity and Position.

This is why a bowling ball travels much further than a golf ball in the air, even if they start with the same velocity!
''';
    }

    final angleRad = angleDeg * math.pi / 180.0;
    final vx = v0 * math.cos(angleRad);
    final vy = v0 * math.sin(angleRad);
    final tPeak = vy / g;
    final peakH = h0 + (vy * vy) / (2 * g);

    // quadratic: h0 + vy*t - 0.5*g*t^2 = 0
    // t = (vy + sqrt(vy^2 + 2*g*h0)) / g
    final disc = vy * vy + 2 * g * h0;
    final hangTime = (vy + math.sqrt(disc)) / g;
    final range = vx * hangTime;

    return '''
# Step-by-Step Derivation (Ideal Case)

> [!NOTE]
> **The Galileo Principle (Mass Independence)**
> In a vacuum (Air Resistance OFF), mass does **not** affect the trajectory. Whether you launch a golf ball or a bowling ball, gravity accelerates them at the same rate (\$g = ${g.toStringAsFixed(2)} \\text{ m/s}^2\$).

### 1. Velocity Components
Break initial velocity (\$v_0 = ${v0.toStringAsFixed(1)} \\text{ m/s}\$) into Horizontal (\$v_x\$) and Vertical (\$v_y\$) components using trigonometry:
- \$v_x = v_0 \\cdot \\cos(${angleDeg.toStringAsFixed(0)}^\\circ) = ${vx.toStringAsFixed(2)} \\text{ m/s}\$
- \$v_y = v_0 \\cdot \\sin(${angleDeg.toStringAsFixed(0)}^\\circ) = ${vy.toStringAsFixed(2)} \\text{ m/s}\$

### 2. Time to Peak Height
At the peak, vertical velocity \$v_y\$ is \$0\$. Solving \$v_y = v_{y0} - gt\$:
- \$0 = ${vy.toStringAsFixed(2)} - ${g.toStringAsFixed(2)} \\cdot t_{peak}\$
- \$t_{peak} = \\frac{${vy.toStringAsFixed(2)}}{${g.toStringAsFixed(2)}} = ${tPeak.toStringAsFixed(3)} \\text{ s}\$

### 3. Maximum Height
Using the displacement formula \$y = y_0 + v_{y0}t - \\frac{1}{2}gt^2\$:
- \$y_{max} = ${h0.toStringAsFixed(1)} + (${vy.toStringAsFixed(2)} \\cdot ${tPeak.toStringAsFixed(3)}) - (0.5 \\cdot ${g.toStringAsFixed(2)} \\cdot ${tPeak.toStringAsFixed(3)}^2)\$
- \$y_{max} = ${peakH.toStringAsFixed(2)} \\text{ m}\$

### 4. Total Hang Time
Solve the quadratic equation for when height \$y = 0\$:
\$\$\$0 = h_0 + v_{y}t - \\frac{1}{2}gt^2\$\$\$
\$\$\$0 = ${h0.toStringAsFixed(1)} + ${vy.toStringAsFixed(2)}t - ${(g / 2).toStringAsFixed(2)}t^2\$\$\$

Using the quadratic formula:
- \$t = \\frac{${vy.toStringAsFixed(2)} + \\sqrt{(${vy.toStringAsFixed(2)})^2 + 2 \\cdot ${g.toStringAsFixed(2)} \\cdot ${h0.toStringAsFixed(1)}}}{${g.toStringAsFixed(2)}}\$
- \$t_{total} = ${hangTime.toStringAsFixed(3)} \\text{ s}\$

### 5. Horizontal Range
In the ideal case, horizontal velocity \$v_x\$ is constant.
- \$R = v_x \\cdot t_{total}\$
- \$R = ${vx.toStringAsFixed(2)} \\cdot ${hangTime.toStringAsFixed(3)}\$
- \$R = ${range.toStringAsFixed(2)} \\text{ m}\$
''';
  }
}
