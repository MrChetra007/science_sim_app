import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import '../../../l10n/generated/app_localizations.dart';
import '../providers/wave_provider.dart';
import '../painters/wave_painter.dart';
import '../services/ad_service.dart';
import '../services/iap_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'challenge_help_screen.dart';

class ChallengeScreen extends ConsumerStatefulWidget {
  const ChallengeScreen({super.key});

  @override
  ConsumerState<ChallengeScreen> createState() => _ChallengeScreenState();
}

enum ChallengeType { frequency, harmonic, phase }

class _ChallengeScreenState extends ConsumerState<ChallengeScreen> {
  ChallengeType currentType = ChallengeType.frequency;
  double targetFrequency = 0.0;
  int targetHarmonic = 1;
  double targetPhase = 0.0;

  int score = 0;
  int streak = 0;
  bool isMatched = false;
  BannerAd? _topBannerAd;
  BannerAd? _bottomBannerAd;

  @override
  void initState() {
    super.initState();
    _generateNewTarget();
    if (!iapService.isPro) {
      _topBannerAd = adService.createBannerAd();
      _bottomBannerAd = adService.createBannerAd();
    }
  }

  @override
  void dispose() {
    _topBannerAd?.dispose();
    _bottomBannerAd?.dispose();
    super.dispose();
  }

  void _generateNewTarget() {
    setState(() {
      // Rotate types for variety
      final types = ChallengeType.values;
      currentType = types[Random().nextInt(types.length)];

      switch (currentType) {
        case ChallengeType.frequency:
          targetFrequency = (Random().nextDouble() * 15 + 1.0);
          break;
        case ChallengeType.harmonic:
          targetHarmonic = Random().nextInt(5) + 2; // n=2 to n=6
          break;
        case ChallengeType.phase:
          targetPhase = (Random().nextDouble() * pi); // 0 to pi
          break;
      }
      isMatched = false;
    });
  }

  void _checkMatch(WaveState state) {
    if (isMatched) return;

    bool match = false;
    switch (currentType) {
      case ChallengeType.frequency:
        match = (state.frequency - targetFrequency).abs() < 0.2;
        break;
      case ChallengeType.harmonic:
        match =
            state.mode == WaveMode.standing && state.harmonic == targetHarmonic;
        break;
      case ChallengeType.phase:
        match =
            state.mode == WaveMode.interference &&
            (state.phaseDifference - targetPhase).abs() < 0.15;
        break;
    }

    if (match) {
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
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(waveProvider);

    // Auto-check on every state change
    _checkMatch(state);

    return Scaffold(
      backgroundColor: const Color(0xFF040D17),
      appBar: AppBar(
        title: Text(l10n.challengeMode),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF00E5FF),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChallengeHelpScreen(),
              ),
            ),
            tooltip: l10n.howToPlay,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          if (!iapService.isPro && _topBannerAd != null)
            Container(
              alignment: Alignment.center,
              width: _topBannerAd!.size.width.toDouble(),
              height: _topBannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _topBannerAd!),
            ),
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
                Text(
                  _targetLabel(),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  _targetValue(),
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
          SizedBox(height: 200, child: _buildPreview(state)),

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
                _buildControls(state),
                const SizedBox(height: 20),
                Text(
                  _instructionText(),
                  style: const TextStyle(color: Colors.white24, fontSize: 10),
                ),
              ],
            ),
          ),
          if (!iapService.isPro && _bottomBannerAd != null)
            Container(
              alignment: Alignment.center,
              width: _bottomBannerAd!.size.width.toDouble(),
              height: _bottomBannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bottomBannerAd!),
            ),
        ],
      ),
    );
  }

  String _targetLabel() {
    switch (currentType) {
      case ChallengeType.frequency:
        return 'TARGET FREQUENCY';
      case ChallengeType.harmonic:
        return 'TARGET HARMONIC';
      case ChallengeType.phase:
        return 'TARGET PHASE';
    }
  }

  String _targetValue() {
    switch (currentType) {
      case ChallengeType.frequency:
        return '${targetFrequency.toStringAsFixed(1)} Hz';
      case ChallengeType.harmonic:
        return 'n = $targetHarmonic';
      case ChallengeType.phase:
        return '${(targetPhase / pi).toStringAsFixed(2)} π';
    }
  }

  String _instructionText() {
    switch (currentType) {
      case ChallengeType.frequency:
        return 'Match the frequency within 0.2 Hz';
      case ChallengeType.harmonic:
        return 'Switch to Standing Wave and set the correct Harmonic';
      case ChallengeType.phase:
        return 'Switch to Interference and adjust Phase Difference';
    }
  }

  Widget _buildPreview(WaveState state) {
    // Show appropriate painter based on current state (user must switch to the right one)
    return CustomPaint(
      painter: WavePainter(state: state.copyWith(isPaused: false)),
      size: Size.infinite,
    );
  }

  Widget _buildControls(WaveState state) {
    final notifier = ref.read(waveProvider.notifier);

    // Always show mode selector so user can navigate to the right physics mode
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.0,
          runSpacing: 4.0,
          children: WaveMode.values.map((m) {
            return ChoiceChip(
              label: Text(m.name, style: const TextStyle(fontSize: 10)),
              selected: state.mode == m,
              onSelected: (_) => notifier.setMode(m),
              selectedColor: const Color(0xFF00E5FF),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        if (currentType == ChallengeType.frequency)
          Slider(
            value: state.frequency,
            min: 0.1,
            max: 20.0,
            onChanged: notifier.setFrequency,
            activeColor: const Color(0xFF00E5FF),
          ),
        if (currentType == ChallengeType.harmonic)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8.0,
            runSpacing: 4.0,
            children: List.generate(6, (i) => i + 1).map((n) {
              return ChoiceChip(
                label: Text('n=$n'),
                selected: state.harmonic == n,
                onSelected: (_) => notifier.setHarmonic(n),
              );
            }).toList(),
          ),
        if (currentType == ChallengeType.phase)
          Slider(
            value: state.phaseDifference,
            min: 0,
            max: pi,
            onChanged: notifier.setPhaseDifference,
            activeColor: const Color(0xFF00E5FF),
          ),
      ],
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
