import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import '../providers/wave_provider.dart';
import '../painters/wave_painter.dart';

class ChallengeScreen extends ConsumerStatefulWidget {
  const ChallengeScreen({super.key});

  @override
  ConsumerState<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends ConsumerState<ChallengeScreen> {
  double targetFrequency = 0.0;
  int score = 0;
  int streak = 0;
  bool isMatched = false;

  @override
  void initState() {
    super.initState();
    _generateNewTarget();
  }

  void _generateNewTarget() {
    setState(() {
      targetFrequency = (Random().nextDouble() * 15 + 1.0); // 1.0 to 16.0 Hz
      isMatched = false;
    });
  }

  void _checkMatch(double currentFreq) {
    if (isMatched) return;

    final diff = (currentFreq - targetFrequency).abs();
    if (diff < 0.2) {
      setState(() {
        isMatched = true;
        score += 10 + streak * 2;
        streak += 1;
      });

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) _generateNewTarget();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(waveProvider);

    // Auto-check on हर state change
    _checkMatch(state.frequency);

    return Scaffold(
      backgroundColor: const Color(0xFF040D17),
      appBar: AppBar(
        title: const Text('Challenge Mode'),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF00E5FF),
      ),
      body: Column(
        children: [
          // Header Readout
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_stat('SCORE', '$score'), _stat('STREAK', 'x$streak')],
            ),
          ),

          const Spacer(),

          // Target Display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            decoration: BoxDecoration(
              color: isMatched
                  ? Colors.green.withValues(alpha: 0.2)
                  : Colors.white10,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isMatched ? Colors.greenAccent : Colors.white24,
                width: 2,
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'TARGET FREQUENCY',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  '${targetFrequency.toStringAsFixed(1)} Hz',
                  style: TextStyle(
                    color: isMatched
                        ? Colors.greenAccent
                        : const Color(0xFF00E5FF),
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (isMatched)
                  const Text(
                    'MATCHED!',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),

          const Spacer(),

          // Mini Simulation Preview
          SizedBox(
            height: 200,
            child: CustomPaint(
              painter: WavePainter(state: state.copyWith(isPaused: false)),
              size: Size.infinite,
            ),
          ),

          const Spacer(),

          // Control Area
          Container(
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'ADJUST FREQUENCY',
                      style: TextStyle(color: Colors.white54, fontSize: 11),
                    ),
                    Text(
                      '${state.frequency.toStringAsFixed(2)} Hz',
                      style: const TextStyle(
                        color: Color(0xFF00E5FF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: state.frequency,
                  min: 0.1,
                  max: 20.0,
                  onChanged: ref.read(waveProvider.notifier).setFrequency,
                  activeColor: const Color(0xFF00E5FF),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Match the target within 0.2 Hz to score!',
                  style: TextStyle(color: Colors.white24, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 10,
            letterSpacing: 1.5,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
