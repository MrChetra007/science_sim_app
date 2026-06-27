import 'dart:math';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'simultaneity_game.dart';
import 'simultaneity_provider.dart';
import '../../ui/widgets/velocity_slider.dart';
import '../../ui/widgets/formula_card.dart';
import 'package:science_lab/l10n/generated/app_localizations.dart';

class SimultaneityScreen extends ConsumerStatefulWidget {
  const SimultaneityScreen({super.key});

  @override
  ConsumerState<SimultaneityScreen> createState() => _SimultaneityScreenState();
}

class _SimultaneityScreenState extends ConsumerState<SimultaneityScreen> {
  late SimultaneityGame _game;
  bool _showFormulaBreakdown = false;

  @override
  void initState() {
    super.initState();
    _game = SimultaneityGame(
      getBeta: () => ref.read(simultaneityProvider).beta,
      getTrainX: () => ref.read(simultaneityProvider).trainX,
      getStrikeTriggered: () => ref.read(simultaneityProvider).strikeTriggered,
      getWavefrontARadius: () => ref.read(simultaneityProvider).wavefrontARadius,
      getWavefrontBRadius: () => ref.read(simultaneityProvider).wavefrontBRadius,
      getElapsed: () => ref.read(simultaneityProvider).elapsed,
      getTrainTimeB: () => ref.read(simultaneityProvider).trainTimeB,
      onTick: (dt, width) {
        ref.read(simultaneityProvider.notifier).tick(dt, width);
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
    final state = ref.watch(simultaneityProvider);

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
          AppLocalizations.of(context)!.relSimultaneityLab,
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
            // Game canvas showing Platform vs Train views
            Expanded(
              flex: 6,
              child: ClipRect(
                child: GameWidget(game: _game),
              ),
            ),

            // Live event arrival metrics for both frames
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.relPlatform,
                        style: const TextStyle(
                          color: Color(0xff4fc3f7),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              child: _buildEventBadge(
                                label: AppLocalizations.of(context)!.relBackA,
                                time: state.platformTimeA,
                                color: const Color(0xffffd700),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: _buildEventBadge(
                                label: AppLocalizations.of(context)!.relFrontB,
                                time: state.platformTimeB,
                                color: const Color(0xff00ff41),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.relTrain,
                        style: const TextStyle(
                          color: Color(0xffffffd700),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              child: _buildEventBadge(
                                label: AppLocalizations.of(context)!.relBackA,
                                time: state.trainTimeA,
                                color: const Color(0xffffd700),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: _buildEventBadge(
                                label: AppLocalizations.of(context)!.relFrontB,
                                time: state.trainTimeB,
                                color: const Color(0xff00ff41),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Result Summary Card (shown when all 4 times recorded)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 400),
              opacity: state.platformTimeA != null &&
                      state.platformTimeB != null &&
                      state.trainTimeA != null &&
                      state.trainTimeB != null
                  ? 1.0
                  : 0.0,
              child: state.platformTimeA != null &&
                      state.platformTimeB != null &&
                      state.trainTimeA != null &&
                      state.trainTimeB != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xff0D1B2A),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xff4fc3f7).withOpacity(0.4),
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.relExperimentResult,
                              style: const TextStyle(
                                color: Color(0xff4fc3f7),
                                fontFamily: 'monospace',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppLocalizations.of(context)!.relPlatformSimultaneous((state.platformTimeA! - state.platformTimeB!).abs().toStringAsFixed(3)),
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'monospace',
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Builder(builder: (ctx) {
                              final diff = (state.trainTimeA! - state.trainTimeB!).abs().toStringAsFixed(3);
                              final text = state.trainTimeA! < state.trainTimeB!
                                  ? AppLocalizations.of(ctx)!.relTrainABefore(diff)
                                  : AppLocalizations.of(ctx)!.relTrainBBefore(diff);
                              return Text(
                                text,
                                style: const TextStyle(
                                  color: Color(0xffffffd700),
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                ),
                              );
                            }),
                            const SizedBox(height: 4),
                            Text(
                              AppLocalizations.of(context)!.relSameEventsDifferent,
                              style: TextStyle(
                                color: Color(0xff00ff41),
                                fontFamily: 'monospace',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 8),

            // Explanation / Formula Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: FormulaCard(
                formulaTitle: AppLocalizations.of(context)!.relSpacetimeInterval,
                latexFormula: "Δt' = γ(Δt - vΔx/c²)",
                variables: {
                  "Platform Delay (Δt)": "0.000 s (Simultaneous ✓)",
                  "Train Observer Speed (v)": "${(state.beta * 100).toStringAsFixed(1)}% c",
                  "Train Arrival A (Back)": state.trainTimeA != null ? "${state.trainTimeA!.toStringAsFixed(3)} s" : "Waiting...",
                  "Train Arrival B (Front)": state.trainTimeB != null ? "${state.trainTimeB!.toStringAsFixed(3)} s" : "Waiting...",
                },
              ),
            ),

            // Formula variable breakdown toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  TextButton.icon(
                    icon: Icon(
                      _showFormulaBreakdown ? Icons.expand_less : Icons.expand_more,
                      color: Colors.white60,
                      size: 16,
                    ),
                    label: Text(
                      AppLocalizations.of(context)!.relWhatVariablesMean,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () => setState(() => _showFormulaBreakdown = !_showFormulaBreakdown),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: _showFormulaBreakdown ? null : 0.0,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: const Color(0xff0D1B2A),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    child: _showFormulaBreakdown
                        ? Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildBreakdownRow("Δt'", "time difference in train frame"),
                                const SizedBox(height: 4),
                                _buildBreakdownRow("γ", "Lorentz factor = ${(1.0 / sqrt(1.0 - state.beta * state.beta)).toStringAsFixed(3)}"),
                                const SizedBox(height: 4),
                                _buildBreakdownRow("Δt", "time difference in platform frame (= 0, simultaneous)"),
                                const SizedBox(height: 4),
                                _buildBreakdownRow("v", "train speed = ${(state.beta * 100).toStringAsFixed(1)}% c"),
                                const SizedBox(height: 4),
                                _buildBreakdownRow("Δx", "distance between strike points = train length"),
                                const SizedBox(height: 4),
                                _buildBreakdownRow("c", "speed of light"),
                              ],
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Speed controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.relSpeed,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ...[0.25, 0.5, 1.0, 2.0].map((s) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: _buildSpeedChip(s, state.speed),
                  )),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Speed Slider (disabled during active simulation)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: IgnorePointer(
                ignoring: state.strikeTriggered,
                child: Opacity(
                  opacity: state.strikeTriggered ? 0.5 : 1.0,
                  child: VelocitySlider(
                    beta: state.beta,
                    onChanged: (newBeta) {
                      ref.read(simultaneityProvider.notifier).setBeta(newBeta);
                    },
                  ),
                ),
              ),
            ),

            // β ≈ 0 simultaneous callout
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: state.beta < 0.05 ? 1.0 : 0.0,
              child: state.beta < 0.05
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.15),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.relAtVZero,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // Buttons
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff4fc3f7),
                      foregroundColor: const Color(0xff0a0a1a),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.flash_on),
                    label: Text(
                      AppLocalizations.of(context)!.relTriggerLightning,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: state.strikeTriggered
                        ? null
                        : () {
                            // Run on next frame with correct canvas size
                            ref.read(simultaneityProvider.notifier).triggerLightning(
                                  MediaQuery.of(context).size.width,
                                );
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
                    label: Text(AppLocalizations.of(context)!.relReset),
                    onPressed: () {
                      ref.read(simultaneityProvider.notifier).reset();
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

  Widget _buildSpeedChip(double value, double current) {
    final selected = (value - current).abs() < 0.01;
    return GestureDetector(
      onTap: () => ref.read(simultaneityProvider.notifier).setSpeed(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xff4fc3f7).withOpacity(0.2)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: selected ? const Color(0xff4fc3f7) : Colors.white12,
            width: selected ? 1.5 : 1.0,
          ),
        ),
        child: Text(
          "${value}x",
          style: TextStyle(
            color: selected ? const Color(0xff4fc3f7) : Colors.white60,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
      ),
    );
  }

  Widget _buildEventBadge({
    required String label,
    required double? time,
    required Color color,
  }) {
    final reached = time != null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: reached ? color.withOpacity(0.1) : Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: reached ? color.withOpacity(0.4) : Colors.white12,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            reached ? Icons.check_circle : Icons.radio_button_unchecked,
            color: reached ? color : Colors.white30,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            reached ? "$label: ${time.toStringAsFixed(3)}s" : label,
            style: TextStyle(
              color: reached ? Colors.white : Colors.white30,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(String variable, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          variable,
          style: const TextStyle(
            color: Color(0xff4fc3f7),
            fontFamily: 'monospace',
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            "= $description",
            style: const TextStyle(
              color: Colors.white70,
              fontFamily: 'monospace',
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}
