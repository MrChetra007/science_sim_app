import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/ad_service.dart';
import '../services/iap_service.dart';

class ChallengeHelpScreen extends StatefulWidget {
  const ChallengeHelpScreen({super.key});

  @override
  State<ChallengeHelpScreen> createState() => _ChallengeHelpScreenState();
}

class _ChallengeHelpScreenState extends State<ChallengeHelpScreen> {
  BannerAd? _topBannerAd;
  BannerAd? _bottomBannerAd;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF040D17),
      appBar: AppBar(
        title: const Text('Challenge Guide'),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF00E5FF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
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
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIntroduction(),
                  const SizedBox(height: 32),
                  _buildSection(
                    icon: Icons.waves,
                    title: '1. Frequency Matching',
                    description:
                        'The most basic challenge. Your goal is to match the raw frequency of the wave.',
                    instructions: [
                      'Look at the target frequency (e.g., 5.0 Hz).',
                      'Use the slider to adjust the wave frequency.',
                      'Match it within 0.2 Hz to score!',
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    icon: Icons.vibration,
                    title: '2. Harmonic Matching',
                    description:
                        'A challenge using Standing Waves. You must create a specific resonating pattern.',
                    instructions: [
                      'The goal is defined by the harmonic number "n".',
                      'First, switch the wave mode to "Standing".',
                      'Select the "n" value that matches the target.',
                    ],
                    color: Colors.amberAccent,
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    icon: Icons.compare_arrows,
                    title: '3. Phase Matching',
                    description:
                        'A challenge using Interference. You must align two waves to create a specific result.',
                    instructions: [
                      'The goal is defined by the phase difference in terms of π.',
                      'First, switch the wave mode to "Interference".',
                      'Adjust the Phase Difference slider until you hit the target (e.g., 0.50 π).',
                    ],
                    color: Colors.lightGreenAccent,
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00E5FF),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'GOT IT!',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
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

  Widget _buildIntroduction() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Master the Waves',
          style: TextStyle(
            color: Color(0xFF00E5FF),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Challenge mode tests your understanding of wave physics. There are three different types of puzzles you will encounter.',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String description,
    required List<String> instructions,
    Color color = const Color(0xFF00E5FF),
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          ...instructions.map(
            (step) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(color: Colors.white54)),
                  Expanded(
                    child: Text(
                      step,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
