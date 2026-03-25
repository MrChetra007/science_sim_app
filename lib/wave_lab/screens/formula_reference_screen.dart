import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/ad_service.dart';
import '../services/iap_service.dart';

class FormulaReferenceScreen extends StatefulWidget {
  const FormulaReferenceScreen({super.key});

  @override
  State<FormulaReferenceScreen> createState() => _FormulaReferenceScreenState();
}

class _FormulaReferenceScreenState extends State<FormulaReferenceScreen> {
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
        title: const Text('Formula Reference'),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF00E5FF),
        elevation: 0,
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
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _category('Fundamental Equations'),
                _formula(
                  'Wave Speed',
                  'v = fλ',
                  'v: Velocity (m/s), f: Frequency (Hz), λ: Wavelength (m)',
                ),
                _formula(
                  'Period',
                  'T = 1/f',
                  'T: Period (s), f: Frequency (Hz)',
                ),
                _formula(
                  'Angular Frequency',
                  'ω = 2πf',
                  'ω: Angular Frequency (rad/s), f: Frequency (Hz)',
                ),
                _formula(
                  'Wave Number',
                  'k = 2π / λ',
                  'k: Wave Number (rad/m), λ: Wavelength (m)',
                ),
                const SizedBox(height: 20),
                _category('Wave Propagation'),
                _formula(
                  'Traveling Wave',
                  'y(x, t) = A sin(kx - ωt + φ)',
                  'y: Displacement, A: Amplitude, x: Position, t: Time',
                ),
                _formula(
                  'Standing Wave',
                  'y(x, t) = [2A sin(kx)] cos(ωt)',
                  'λ_n = 2L / n (for n-th harmonic)',
                ),
                const SizedBox(height: 20),
                _category('Advanced Physics'),
                _formula(
                  'Doppler Effect',
                  "f' = f [v / (v - v_s)]",
                  "f': Observed Frequency, v_s: Source Velocity",
                ),
                _formula(
                  'Damped Wave',
                  'y(x, t) = A e^{-γx} sin(kx - ωt)',
                  'γ: Damping coefficient',
                ),
                const SizedBox(height: 40),
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

  Widget _category(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF00E5FF),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _formula(String name, String math, String variables) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              math,
              style: const TextStyle(
                color: Color(0xFF00E5FF),
                fontSize: 18,
                fontFamily: 'monospace',
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            variables,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
