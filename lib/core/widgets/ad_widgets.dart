import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../services/subscription_service.dart';
import '../services/ad_service.dart';

class GlobalBannerAdWidget extends StatefulWidget {
  final AdSize adSize;

  const GlobalBannerAdWidget({super.key, this.adSize = AdSize.banner});

  @override
  State<GlobalBannerAdWidget> createState() => _GlobalBannerAdWidgetState();
}

class _GlobalBannerAdWidgetState extends State<GlobalBannerAdWidget> {
  BannerAd? _bannerAd;
  bool _adLoaded = false;

  @override
  void initState() {
    super.initState();
    // ✅ FIX: Load only once in initState, not in didChangeDependencies.
    // didChangeDependencies fires every time any inherited widget changes
    // (e.g. Provider updates), which caused multiple ad instances to be
    // created and old surfaces to be abandoned (abandonLocked errors).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadAd();
    });
  }

  void _loadAd() {
    // Guard: never load more than once
    if (_adLoaded) return;

    final sub = Provider.of<SubscriptionService>(context, listen: false);
    if (!sub.showBannerAds) return;

    _adLoaded = true;

    _bannerAd = BannerAd(
      adUnitId: globalAdService.bannerAdUnitId,
      size: widget.adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) setState(() {});
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (mounted) {
            setState(() {
              _bannerAd = null;
              // ✅ FIX: Reset flag so a retry is possible if widget is
              // rebuilt (e.g. user navigates away and comes back), but
              // we do NOT immediately retry to avoid surface spam.
              _adLoaded = false;
            });
          }
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    // ✅ FIX: Always dispose the ad when widget leaves the tree.
    // This is now reliable because MainDashboard is a StatefulWidget.
    _bannerAd?.dispose();
    _bannerAd = null;
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
