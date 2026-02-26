import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../painters/wave_painter.dart';
import '../painters/standing_wave_painter.dart';
import '../painters/interference_painter.dart';
import '../painters/doppler_painter.dart';
import '../painters/longitudinal_painter.dart';
import '../painters/blueprint_painter.dart';
import '../widgets/control_panel.dart';
import '../widgets/results_panel.dart';
import '../widgets/oscilloscope_panel.dart';
import '../widgets/pro_gate.dart';
import '../providers/wave_provider.dart';
import '../services/audio_service.dart';

class SimulationScreen extends ConsumerStatefulWidget {
  const SimulationScreen({super.key});

  @override
  ConsumerState<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends ConsumerState<SimulationScreen> {
  bool _isExpanded = false;

  @override
  void dispose() {
    audioService.stopTone();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(waveProvider.select((s) => s.isAudioEnabled), (prev, next) {
      if (next) {
        audioService.startTone(ref.read(waveProvider).frequency);
      } else {
        audioService.stopTone();
      }
    });

    ref.listen(waveProvider.select((s) => s.frequency), (prev, next) {
      if (ref.read(waveProvider).isAudioEnabled) {
        audioService.updateFrequency(next);
      }
    });

    final waveState = ref.watch(waveProvider);

    Widget waveWidget;
    switch (waveState.mode) {
      case WaveMode.standing:
        waveWidget = CustomPaint(
          painter: StandingWavePainter(state: waveState),
        );
        break;
      case WaveMode.interference:
        waveWidget = CustomPaint(
          painter: InterferencePainter(state: waveState),
        );
        break;
      case WaveMode.doppler:
        waveWidget = ProGate(
          featureName: 'Doppler Effect',
          child: CustomPaint(painter: DopplerPainter(state: waveState)),
        );
        break;
      case WaveMode.simulation:
      case WaveMode.travelling:
        if (waveState.waveType == WaveType.longitudinal) {
          waveWidget = CustomPaint(
            painter: LongitudinalPainter(state: waveState),
          );
        } else {
          waveWidget = CustomPaint(painter: WavePainter(state: waveState));
        }
        break;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF040D17),
      body: Column(
        children: [
          // 1. TOP HUB (21%)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.21,
            child: const ResultsPanel(),
          ),

          // 2. SIMULATION AREA (Flexible: Max 90% or Min 40%)
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(child: CustomPaint(painter: GridPainter())),
                Positioned.fill(child: waveWidget),

                // Blueprint HUD Overlay
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: waveState.showBlueprint ? 1.0 : 0.0,
                      child: CustomPaint(
                        painter: BlueprintPainter(state: waveState),
                      ),
                    ),
                  ),
                ),

                // Oscilloscope Overlay
                if (waveState.showOscilloscope)
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    height: 180,
                    child: const OscilloscopePanel(),
                  ),

                // Ghost Mode Quick Controls
                Positioned(
                  top: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (waveState.ghostState != null) ...[
                        Row(
                          children: [
                            Material(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(8),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () => ref
                                    .read(waveProvider.notifier)
                                    .toggleShowGhost(),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        waveState.showGhost
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: const Color(0xFF00E5FF),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      const Text(
                                        'GHOST',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton.filled(
                              onPressed: () =>
                                  ref.read(waveProvider.notifier).resetGhost(),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.redAccent.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                              icon: const Icon(Icons.close, size: 16),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Floating Action Button to toggle Dashboard
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton.small(
                    onPressed: () => setState(() => _isExpanded = !_isExpanded),
                    backgroundColor: const Color(0xFF00E5FF),
                    child: Icon(
                      _isExpanded ? Icons.keyboard_arrow_down : Icons.settings,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. COLLAPSIBLE CONTROL PANEL (50%)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: _isExpanded ? MediaQuery.of(context).size.height * 0.5 : 0,
            decoration: BoxDecoration(
              color: const Color(0xFF040D17),
              border: Border(
                top: BorderSide(
                  color: const Color(0xFF00E5FF).withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: _isExpanded ? const ControlPanel() : null,
          ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.05)
      ..strokeWidth = 1.0;

    const double step = 30.0;
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
