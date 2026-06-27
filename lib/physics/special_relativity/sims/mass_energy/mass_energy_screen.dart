import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'mass_energy_game.dart';
import 'mass_energy_provider.dart';
import '../../ui/widgets/velocity_slider.dart';
import '../../ui/widgets/formula_card.dart';
import '../../ui/widgets/metric_chip.dart';

class MassEnergyScreen extends ConsumerStatefulWidget {
  const MassEnergyScreen({super.key});

  @override
  ConsumerState<MassEnergyScreen> createState() => _MassEnergyScreenState();
}

class _MassEnergyScreenState extends ConsumerState<MassEnergyScreen> {
  late MassEnergyGame _game;

  @override
  void initState() {
    super.initState();
    _game = MassEnergyGame(
      getMass: () => ref.read(massEnergyProvider).massKg,
      getBeta: () => ref.read(massEnergyProvider).beta,
      getReactionTriggered: () => ref.read(massEnergyProvider).reactionTriggered,
      getBurstProgress: () => ref.read(massEnergyProvider).burstProgress,
      onTick: (dt) {
        ref.read(massEnergyProvider.notifier).tick(dt);
      },
    );
  }

  @override
  void dispose() {
    _game.pauseEngine();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(massEnergyProvider);

    // Scaling factor to draw the bar chart relative sizes.
    // Total energy is restEnergy + kineticEnergy.
    // At rest, total energy is restEnergy.
    // We can normalize the bars: Rest energy is always 100% of its value.
    // Kinetic energy bar height is calculated as a fraction of rest energy:
    // Fraction = KE / E0 = (gamma - 1).
    final keFraction = state.gamma - 1.0;

    return Scaffold(
      backgroundColor: const Color(0xff0a0a1a),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Mass-Energy Equivalence",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Game canvas showing atom fission
            Expanded(
              flex: 5,
              child: ClipRect(
                child: GameWidget(game: _game),
              ),
            ),

            // Sleek side-by-side energy bar charts
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xff15152a),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "ENERGY SPLIT (RELATIVE SCALE)",
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Rest Energy Bar
                    Row(
                      children: [
                        const SizedBox(
                          width: 80,
                          child: Text(
                            "Rest E₀:",
                            style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              AnimatedFractionallySizedBox(
                                duration: const Duration(milliseconds: 300),
                                widthFactor: 0.8, // Baseline rest energy
                                child: Container(
                                  height: 16,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xffffd700), Color(0xffff9800)],
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xffffd700).withOpacity(0.4),
                                        blurRadius: 4,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${(state.restEnergy / 1e-11).toStringAsFixed(2)} ×10⁻¹¹ J",
                          style: const TextStyle(
                            color: Color(0xffffd700),
                            fontSize: 11,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Kinetic Energy Bar
                    Row(
                      children: [
                        const SizedBox(
                          width: 80,
                          child: Text(
                            "Kinetic KE:",
                            style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              AnimatedFractionallySizedBox(
                                duration: const Duration(milliseconds: 300),
                                widthFactor: (keFraction * 0.8).clamp(0.0, 1.0),
                                child: Container(
                                  height: 16,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xff4fc3f7), Colors.blue],
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xff4fc3f7).withOpacity(0.4),
                                        blurRadius: 4,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${(state.kineticEnergy / 1e-11).toStringAsFixed(2)} ×10⁻¹¹ J",
                          style: const TextStyle(
                            color: Color(0xff4fc3f7),
                            fontSize: 11,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        _realWorldLabel(state.restEnergy),
                        style: const TextStyle(
                          color: Color(0xff4fc3f7),
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // High-β fun fact callout
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: state.beta > 0.87 ? 1.0 : 0.0,
              child: state.beta > 0.87
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xffff9800),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.bolt, color: Colors.black87, size: 16),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "At this speed, kinetic energy exceeds rest energy!",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 8),

            // Formula card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: FormulaCard(
                formulaTitle: "Relativistic Energy Equations",
                latexFormula: "E_total = γ × mc² = E₀ + KE",
                variables: {
                  "Total Energy (E)": "${(state.totalEnergy / 1e-11).toStringAsFixed(4)} × 10⁻¹¹ J",
                  "Rest Energy (E₀)": "${(state.restEnergy / 1e-11).toStringAsFixed(4)} × 10⁻¹¹ J",
                  "Kinetic Energy (KE)": "${(state.kineticEnergy / 1e-11).toStringAsFixed(4)} × 10⁻¹¹ J",
                },
              ),
            ),

            const SizedBox(height: 10),

            // Mass configuration slider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xff15152a),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Mass (m):",
                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Slider(
                            value: state.massKg,
                            min: 1.0,
                            max: 5.0,
                            divisions: 40,
                            onChanged: state.reactionTriggered
                                ? null
                                : (val) {
                                    ref.read(massEnergyProvider.notifier).setMass(val);
                                  },
                            activeColor: const Color(0xffffd700),
                            inactiveColor: const Color(0xffffd700).withOpacity(0.2),
                          ),
                        ),
                        Text(
                          "${state.massKg.toStringAsFixed(2)} ×10⁻²⁷ kg",
                          style: const TextStyle(
                            color: Color(0xffffd700),
                            fontSize: 12,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        "≈ ${(state.massKg / 1.6726).toStringAsFixed(1)} proton masses",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Relativistic Velocity slider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: VelocitySlider(
                beta: state.beta,
                onChanged: (newBeta) {
                  ref.read(massEnergyProvider.notifier).setBeta(newBeta);
                },
              ),
            ),

            // Buttons
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffff9800),
                      foregroundColor: const Color(0xff0a0a1a),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.bolt),
                    label: const Text(
                      "Trigger Fission",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: state.reactionTriggered
                        ? null
                        : () {
                            ref.read(massEnergyProvider.notifier).triggerFission();
                          },
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff15152a),
                      foregroundColor: Colors.white70,
                      side: const BorderSide(color: Colors.white30),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text("Reset"),
                    onPressed: () {
                      ref.read(massEnergyProvider.notifier).reset();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _realWorldLabel(double energyJ) {
    const ledWatt = 10.0;
    final seconds = energyJ / ledWatt;
    if (energyJ < 1e-10) {
      return "≈ ${seconds.toStringAsFixed(1)} s of LED bulb power";
    } else if (energyJ < 1e-8) {
      return "≈ ${(seconds / 60).toStringAsFixed(1)} min of LED bulb power";
    } else if (energyJ < 1e-5) {
      return "≈ ${(seconds / 3600).toStringAsFixed(1)} h of LED bulb power";
    } else {
      return "≈ ${(seconds / 86400).toStringAsFixed(1)} days of LED bulb power";
    }
  }
}
