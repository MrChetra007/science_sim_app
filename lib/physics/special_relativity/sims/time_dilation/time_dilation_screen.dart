import 'dart:math';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'time_dilation_game.dart';
import 'time_dilation_provider.dart';
import '../../ui/widgets/velocity_slider.dart';
import '../../ui/widgets/formula_card.dart';
import '../../ui/widgets/metric_chip.dart';

class TimeDilationScreen extends ConsumerStatefulWidget {
  const TimeDilationScreen({super.key});

  @override
  ConsumerState<TimeDilationScreen> createState() => _TimeDilationScreenState();
}

class _TimeDilationScreenState extends ConsumerState<TimeDilationScreen> {
  late TimeDilationGame _game;

  @override
  void initState() {
    super.initState();
    _game = TimeDilationGame(
      getBeta: () => ref.read(timeDilationProvider).beta,
      getGamma: () => ref.read(timeDilationProvider).gamma,
      getProperTime: () => ref.read(timeDilationProvider).properTime,
      getDilatedTime: () => ref.read(timeDilationProvider).dilatedTime,
      getPhotonPhase: () => ref.read(timeDilationProvider).photonPhase,
      getRestBounces: () => ref.read(timeDilationProvider).restBounces,
      getMovingBounces: () => ref.read(timeDilationProvider).movingBounces,
      onTick: (dt) {
        ref.read(timeDilationProvider.notifier).tick(dt);
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
    final state = ref.watch(timeDilationProvider);

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
          "Time Dilation Lab",
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
            // Game canvas (light clock representation)
            Expanded(
              flex: 5,
              child: ClipRect(
                child: GameWidget(game: _game),
              ),
            ),

            // Analog Clock Faces representing rest/dilated times
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      CustomPaint(
                        size: const Size(64, 64),
                        painter: ClockFacePainter(
                          timeInSeconds: state.dilatedTime,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Observer Time (t')",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${state.dilatedTime.toStringAsFixed(2)}s",
                        style: const TextStyle(
                          color: Color(0xff4fc3f7),
                          fontFamily: 'monospace',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      CustomPaint(
                        size: const Size(64, 64),
                        painter: ClockFacePainter(
                          timeInSeconds: state.properTime,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Spaceship Time (t₀)",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${state.properTime.toStringAsFixed(2)}s",
                        style: const TextStyle(
                          color: Color(0xffffffd700),
                          fontFamily: 'monospace',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Live metrics
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Flexible(child: MetricChip(
                    label: "γ (Gamma)",
                    value: state.gamma.toStringAsFixed(3),
                  )),
                  const SizedBox(width: 8),
                  Flexible(child: MetricChip(
                    label: "v",
                    value: "${(state.beta * 100).toStringAsFixed(1)}% c",
                  )),
                  const SizedBox(width: 8),
                  Flexible(child: MetricChip(
                    label: "t' / t₀",
                    value: state.gamma.toStringAsFixed(2),
                  )),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // High-β fun fact callout
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: state.beta > 0.87 ? 1.0 : 0.0,
              child: state.beta > 0.87
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                                "At v ≈ 87% c, the moving clock ticks at half the rate of the rest clock!",
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

            const SizedBox(height: 6),

            // Formula card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: FormulaCard(
                formulaTitle: "Time Dilation Formula",
                latexFormula: "t' = γ × t₀",
                variables: {
                  "Observer Time (t')": "${state.dilatedTime.toStringAsFixed(3)} s",
                  "Lorentz Factor (γ)": state.gamma.toStringAsFixed(4),
                  "Spaceship Time (t₀)": "${state.properTime.toStringAsFixed(3)} s",
                },
              ),
            ),

            const SizedBox(height: 6),

            // Slider & Play controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: VelocitySlider(
                beta: state.beta,
                onChanged: (newBeta) {
                  ref.read(timeDilationProvider.notifier).setBeta(newBeta);
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff15152a),
                      foregroundColor: const Color(0xff4fc3f7),
                      side: const BorderSide(color: Color(0xff4fc3f7)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    ),
                    icon: Icon(state.isRunning ? Icons.pause : Icons.play_arrow),
                    label: Text(state.isRunning ? "Pause" : "Resume"),
                    onPressed: () {
                      ref.read(timeDilationProvider.notifier).togglePause();
                    },
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff15152a),
                      foregroundColor: Colors.white70,
                      side: const BorderSide(color: Colors.white30),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text("Reset"),
                    onPressed: () {
                      ref.read(timeDilationProvider.notifier).reset();
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
}

class ClockFacePainter extends CustomPainter {
  final double timeInSeconds;

  ClockFacePainter({required this.timeInSeconds});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    final facePaint = Paint()
      ..color = const Color(0xff15152a)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = const Color(0xff4fc3f7).withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius, facePaint);
    canvas.drawCircle(center, radius, borderPaint);

    // 1 tick = 1 second. Let's make 1 full rotation = 12 seconds for visualization, so the hand moves fast enough to see easily.
    final double angle = (timeInSeconds * 2 * pi) / 12.0;

    final handPaint = Paint()
      ..color = const Color(0xff4fc3f7)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;

    final handLength = radius * 0.7;
    canvas.drawLine(
      center,
      center + Offset(sin(angle) * handLength, -cos(angle) * handLength),
      handPaint,
    );

    // Draw little center circle
    canvas.drawCircle(center, 4, Paint()..color = Colors.white);

    // Draw tick marks
    final tickPaint = Paint()
      ..color = Colors.white30
      ..strokeWidth = 1.5;
    for (int i = 0; i < 12; i++) {
      final double tickAngle = i * pi / 6;
      final inner = radius * 0.85;
      canvas.drawLine(
        center + Offset(sin(tickAngle) * inner, -cos(tickAngle) * inner),
        center + Offset(sin(tickAngle) * radius, -cos(tickAngle) * radius),
        tickPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ClockFacePainter oldDelegate) {
    return oldDelegate.timeInSeconds != timeInSeconds;
  }
}
