import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/wave_provider.dart';
import '../theme/wave_colors.dart';
import 'pro_gate.dart';

class ControlPanel extends ConsumerWidget {
  const ControlPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final waveState = ref.watch(waveProvider);
    final waveNotifier = ref.read(waveProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF040D17),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Correctly shrinks when height is restricted
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle Decor
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'CONTROLS',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 10,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Row(
                    children: [
                      // ✅ FREE — Play/Pause
                      IconButton(
                        onPressed: waveNotifier.togglePause,
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          waveState.isPaused ? Icons.play_arrow : Icons.pause,
                          color: const Color(0xFF00E5FF),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // ✅ FREE — Slow Motion
                      IconButton(
                        onPressed: () => waveNotifier.setTimeScale(
                          waveState.timeScale == 1.0 ? 0.1 : 1.0,
                        ),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          waveState.timeScale == 1.0
                              ? Icons.speed
                              : Icons.slow_motion_video,
                          color: waveState.timeScale == 0.1
                              ? const Color(0xFF00E5FF)
                              : Colors.white70,
                          size: 20,
                        ),
                        tooltip: 'Slow Motion',
                      ),
                      const SizedBox(width: 8),
                      // ✅ FREE — Reset
                      IconButton(
                        onPressed: waveNotifier.resetTime,
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.white70,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildModeToggle(waveState, waveNotifier),
              const SizedBox(height: 8),
              if (waveState.mode == WaveMode.simulation ||
                  waveState.mode == WaveMode.interference) ...[
                _buildWaveTypeToggle(waveState, waveNotifier),
                const Divider(color: Colors.white12, height: 24),
              ],

              _buildSlider(
                label: waveState.mode == WaveMode.interference
                    ? 'Wave 1 Amplitude'
                    : 'Amplitude (A)',
                value: waveState.amplitude,
                min: 0.1,
                max: 5.0,
                onChanged: (v) {
                  waveNotifier.setAmplitude(v);
                  HapticFeedback.selectionClick();
                },
                activeColor: WaveColors.amplitude,
              ),
              _buildSlider(
                label: waveState.mode == WaveMode.interference
                    ? 'Wave 1 Frequency'
                    : 'Frequency (f)',
                value: waveState.frequency,
                min: 0.1,
                max: 20.0,
                onChanged: (v) {
                  waveNotifier.setFrequency(v);
                  HapticFeedback.selectionClick();
                },
                activeColor: WaveColors.frequency,
              ),

              // ✅ FREE — Standing Wave harmonic slider
              if (waveState.mode == WaveMode.standing)
                _buildSlider(
                  label: 'Harmonic (n)',
                  value: waveState.harmonic.toDouble(),
                  min: 1,
                  max: 6,
                  onChanged: (v) => waveNotifier.setHarmonic(v.toInt()),
                  activeColor: WaveColors.harmonic,
                ),

              if (waveState.mode == WaveMode.interference) ...[
                _buildSlider(
                  label: 'Wave 2 Amplitude',
                  value: waveState.secondaryAmplitude,
                  min: 0.1,
                  max: 5.0,
                  onChanged: waveNotifier.setSecondaryAmplitude,
                ),
                _buildSlider(
                  label: 'Wave 2 Frequency',
                  value: waveState.secondaryFrequency,
                  min: 0.1,
                  max: 20.0,
                  onChanged: waveNotifier.setSecondaryFrequency,
                ),
                _buildSlider(
                  label: 'Phase Diff (φ)',
                  value: waveState.phaseDifference,
                  min: 0,
                  max: 6.28,
                  onChanged: waveNotifier.setPhaseDifference,
                  activeColor: WaveColors.phase,
                ),
              ],

              if (waveState.mode == WaveMode.doppler)
                _buildSlider(
                  label: 'Source Velocity (vs)',
                  value: waveState.sourceVelocity,
                  min: -50,
                  max: 50,
                  onChanged: waveNotifier.setSourceVelocity,
                  activeColor: WaveColors.speed,
                ),

              if (waveState.mode == WaveMode.simulation ||
                  waveState.mode == WaveMode.interference ||
                  waveState.mode == WaveMode.doppler) ...[
                _buildSlider(
                  label: 'Wave Speed (v)',
                  value: waveState.waveSpeed,
                  min: 100,
                  max: 1500,
                  onChanged: waveNotifier.setWaveSpeed,
                  activeColor: WaveColors.speed,
                ),
                const SizedBox(height: 4),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _presetChip('Vacuum', 300, waveState, waveNotifier),
                      _presetChip('Air', 343, waveState, waveNotifier),
                      _presetChip('Water', 1480, waveState, waveNotifier),
                    ],
                  ),
                ),
              ],
              const Divider(color: Colors.white12, height: 24),
              _buildEducationTools(waveState, waveNotifier),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEducationTools(WaveState state, WaveNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'EDUCATION TOOLS',
          style: TextStyle(
            color: Colors.white38,
            fontSize: 10,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            // ✅ FREE — Ghost Mode
            if (state.ghostState == null)
              ElevatedButton.icon(
                onPressed: notifier.captureGhost,
                icon: const Icon(Icons.copy, size: 16),
                label: const Text('Capture Ghost'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white10,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 11),
                ),
              )
            else ...[
              ElevatedButton.icon(
                onPressed: notifier.resetGhost,
                icon: const Icon(Icons.clear, size: 16),
                label: const Text('Clear Ghost'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent.withOpacity(0.2),
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 11),
                ),
              ),
              FilterChip(
                label: const Text('Show Ghost'),
                selected: state.showGhost,
                onSelected: (_) => notifier.toggleShowGhost(),
                selectedColor: const Color(0xFF00E5FF),
                labelStyle: TextStyle(
                  color: state.showGhost ? Colors.black : Colors.white,
                  fontSize: 11,
                ),
              ),
            ],

            // ✅ FREE — Vector Overlays
            FilterChip(
              label: const Text('Show Vectors (v/a)'),
              selected: state.showVectors,
              onSelected: (_) => notifier.toggleVectors(),
              selectedColor: const Color(0xFF00E5FF),
              labelStyle: TextStyle(
                color: state.showVectors ? Colors.black : Colors.white,
                fontSize: 11,
              ),
            ),

            // ✅ FREE — Oscilloscope
            FilterChip(
              label: const Text('Oscilloscope'),
              selected: state.showOscilloscope,
              onSelected: (_) => notifier.toggleOscilloscope(),
              selectedColor: const Color(0xFF00E5FF),
              labelStyle: TextStyle(
                color: state.showOscilloscope ? Colors.black : Colors.white,
                fontSize: 11,
              ),
            ),

            // ✅ FREE — Blueprint HUD
            FilterChip(
              label: const Text('BLUEPRINT HUD'),
              selected: state.showBlueprint,
              onSelected: (_) => notifier.toggleBlueprint(),
              selectedColor: const Color(0xFF00E5FF),
              labelStyle: TextStyle(
                color: state.showBlueprint ? Colors.black : Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildWaveTypeToggle(state, notifier),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            // ✅ FREE — Damping
            FilterChip(
              label: const Text('Damping'),
              selected: state.isDampingEnabled,
              onSelected: (_) =>
                  notifier.toggleDamping(!state.isDampingEnabled),
              selectedColor: const Color(0xFF00E5FF),
              labelStyle: TextStyle(
                color: state.isDampingEnabled ? Colors.black : Colors.white,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildModeToggle(WaveState state, WaveNotifier notifier) {
    // ✅ Custom order: Travelling moved to 3rd place
    final orderedModes = [
      WaveMode.simulation,
      WaveMode.standing,
      WaveMode.travelling, // ✅ moved to 3rd
      WaveMode.interference,
      WaveMode.doppler,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: orderedModes.map((mode) {
          // ✅ FREE modes: Simulation, Standing Wave, Travelling
          // 🔒 PRO modes: Interference, Doppler
          final isFreeMode =
              mode == WaveMode.simulation ||
              mode == WaveMode.standing ||
              mode == WaveMode.travelling; // ✅ now free

          final chip = ChoiceChip(
            label: Text(mode.name[0].toUpperCase() + mode.name.substring(1)),
            selected: state.mode == mode,
            onSelected: (_) => notifier.setMode(mode),
            selectedColor: const Color(0xFF00E5FF),
            labelStyle: TextStyle(
              color: state.mode == mode ? Colors.black : Colors.white,
              fontSize: 12,
            ),
          );

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: isFreeMode
                ? chip
                : ProGate(
                    featureName:
                        '${mode.name[0].toUpperCase()}${mode.name.substring(1)} Mode',
                    child: chip,
                  ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWaveTypeToggle(WaveState state, WaveNotifier notifier) {
    return Row(
      children: [
        const Text('Type:', style: TextStyle(color: Colors.white70)),
        const SizedBox(width: 10),
        ChoiceChip(
          label: const Text('Transverse'),
          selected: state.waveType == WaveType.transverse,
          onSelected: (_) => notifier.setWaveType(WaveType.transverse),
          selectedColor: const Color(0xFF00E5FF),
          labelStyle: TextStyle(
            color: state.waveType == WaveType.transverse
                ? Colors.black
                : Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        ChoiceChip(
          label: const Text('Longitudinal'),
          selected: state.waveType == WaveType.longitudinal,
          onSelected: (_) => notifier.setWaveType(WaveType.longitudinal),
          selectedColor: const Color(0xFF00E5FF),
          labelStyle: TextStyle(
            color: state.waveType == WaveType.longitudinal
                ? Colors.black
                : Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _presetChip(
    String label,
    double speed,
    WaveState state,
    WaveNotifier notifier,
  ) {
    final isSelected = state.waveSpeed == speed;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => notifier.setWaveSpeed(speed),
        selectedColor: const Color(0xFF00E5FF),
        labelStyle: TextStyle(
          color: isSelected ? Colors.black : Colors.white,
          fontSize: 10,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
    Color? activeColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              value.toStringAsFixed(2),
              style: const TextStyle(
                color: Color(0xFF00E5FF),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
          activeColor: activeColor ?? const Color(0xFF00E5FF),
          inactiveColor: Colors.white10,
        ),
      ],
    );
  }
}
