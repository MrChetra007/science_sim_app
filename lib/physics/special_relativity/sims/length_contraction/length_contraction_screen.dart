import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'length_contraction_game.dart';
import 'length_contraction_provider.dart';
import '../../ui/widgets/velocity_slider.dart';
import '../../ui/widgets/formula_card.dart';
import '../../ui/widgets/metric_chip.dart';
import 'package:science_lab/l10n/generated/app_localizations.dart';

class LengthContractionScreen extends ConsumerStatefulWidget {
  const LengthContractionScreen({super.key});

  @override
  ConsumerState<LengthContractionScreen> createState() => _LengthContractionScreenState();
}

class _LengthContractionScreenState extends ConsumerState<LengthContractionScreen> {
  late LengthContractionGame _game;

  @override
  void initState() {
    super.initState();
    _game = LengthContractionGame(
      getBeta: () => ref.read(lengthContractionProvider).beta,
      getGamma: () => ref.read(lengthContractionProvider).gamma,
      getShipX: () => ref.read(lengthContractionProvider).shipX,
      getIsRunning: () => ref.read(lengthContractionProvider).isRunning,
      onTick: (dt, width) {
        ref.read(lengthContractionProvider.notifier).tick(dt, width);
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
    final state = ref.watch(lengthContractionProvider);

    return Scaffold(
      backgroundColor: const Color(0xff0a0a1a),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.relLengthContractionLab,
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
            // Game canvas (contracting spaceship representation)
            Expanded(
              flex: 5,
              child: ClipRect(
                child: GameWidget(game: _game),
              ),
            ),

            // Live metrics
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
              child: Row(
                children: [
                  Flexible(child: MetricChip(
                    label: AppLocalizations.of(context)!.relRestLength,
                    value: "${state.restLength.toStringAsFixed(1)}m",
                  )),
                  const SizedBox(width: 8),
                  Flexible(child: MetricChip(
                    label: AppLocalizations.of(context)!.relContracted,
                    value: "${state.contractedLength.toStringAsFixed(1)}m",
                    color: const Color(0xff00ff41),
                  )),
                  const SizedBox(width: 8),
                  Flexible(child: MetricChip(
                    label: AppLocalizations.of(context)!.relShrinkage,
                    value: "${((1 - 1 / state.gamma) * 100).toStringAsFixed(1)}%",
                    color: const Color(0xffff9800),
                  )),
                ],
              ),
            ),

            // Formula card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: FormulaCard(
                formulaTitle: AppLocalizations.of(context)!.relLengthContractionFormula,
                latexFormula: "L' = L₀ / γ",
                variables: {
                  AppLocalizations.of(context)!.relMeasuredLength: "${state.contractedLength.toStringAsFixed(3)} m",
                  "Rest Length (L₀)": "${state.restLength.toStringAsFixed(1)} m",
                  "Lorentz Factor (γ)": state.gamma.toStringAsFixed(4),
                },
              ),
            ),

            const SizedBox(height: 12),

            // Velocity Slider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: VelocitySlider(
                beta: state.beta,
                onChanged: (newBeta) {
                  ref.read(lengthContractionProvider.notifier).setBeta(newBeta);
                },
              ),
            ),

            // Controls
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff15152a),
                      foregroundColor: const Color(0xff4fc3f7),
                      side: const BorderSide(color: Color(0xff4fc3f7)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    icon: Icon(state.isRunning ? Icons.pause : Icons.play_arrow),
                    label: Text(state.isRunning ? AppLocalizations.of(context)!.relPause : AppLocalizations.of(context)!.relResume),
                    onPressed: () {
                      ref.read(lengthContractionProvider.notifier).togglePause();
                    },
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff15152a),
                      foregroundColor: Colors.white70,
                      side: const BorderSide(color: Colors.white30),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: Text(AppLocalizations.of(context)!.relReset),
                    onPressed: () {
                      ref.read(lengthContractionProvider.notifier).reset();
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
