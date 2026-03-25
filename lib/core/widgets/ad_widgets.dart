import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../services/subscription_service.dart';
import '../services/ad_service.dart';

class GlobalBannerAdWidget extends StatefulWidget {
  final AdSize adSize;

  const GlobalBannerAdWidget({
    super.key,
    this.adSize = AdSize.banner,
  });

  @override
  State<GlobalBannerAdWidget> createState() => _GlobalBannerAdWidgetState();
}

class _GlobalBannerAdWidgetState extends State<GlobalBannerAdWidget> {
  BannerAd? _bannerAd;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  void _loadAd() {
    final sub = Provider.of<SubscriptionService>(context, listen: false);
    if (!sub.showBannerAds) {
      _bannerAd?.dispose();
      _bannerAd = null;
      return;
    }

    if (_bannerAd != null) return;

    _bannerAd = BannerAd(
      adUnitId: globalAdService.bannerAdUnitId,
      size: widget.adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (mounted) {
            setState(() {
              _bannerAd = null;
            });
          }
        },
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {});
          }
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sub = Provider.of<SubscriptionService>(context);
    if (!sub.showBannerAds || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    return Container(
      alignment: Alignment.center,
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
