import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../l10n/generated/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFF040D17),
      appBar: AppBar(
        title: Text(l10n.formulaReferenceTitle),
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
                _category(l10n.fundamentalEquations),
                _formula(
                  l10n.waveSpeed,
                  'v = fλ',
                  l10n.waveSpeedVars,
                ),
                _formula(
                  l10n.period,
                  'T = 1/f',
                  l10n.periodVars,
                ),
                _formula(
                  l10n.angularFrequency,
                  'ω = 2πf',
                  l10n.angularFrequencyVars,
                ),
                _formula(
                  l10n.waveNumber,
                  'k = 2π / λ',
                  l10n.waveNumberVars,
                ),
                const SizedBox(height: 20),
                _category(l10n.wavePropagation),
                _formula(
                  l10n.travelingWave,
                  'y(x, t) = A sin(kx - ωt + φ)',
                  l10n.travelingWaveVars,
                ),
                _formula(
                  l10n.standingWave,
                  'y(x, t) = [2A sin(kx)] cos(ωt)',
                  l10n.standingWaveVars,
                ),
                const SizedBox(height: 20),
                _category(l10n.advancedPhysics),
                _formula(
                  l10n.dopplerEffect,
                  "f' = f [v / (v - v_s)]",
                  l10n.dopplerEffectVars,
                ),
                _formula(
                  l10n.dampedWave,
                  'y(x, t) = A e^{-γx} sin(kx - ωt)',
                  l10n.dampedWaveVars,
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
