import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'iap_service.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  InterstitialAd? _interstitialAd;
  
  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else {
      return 'ca-app-pub-3940256099942544/2934735716';
    }
  }

  String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    } else {
      return 'ca-app-pub-3940256099942544/4411468910';
    }
  }

  Future<void> init() async {
    await MobileAds.instance.initialize();
    loadInterstitialAd();
  }

  void loadInterstitialAd() {
    if (iapService.isPro) return;

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (iapService.isPro || _interstitialAd == null) return;
    
    _interstitialAd!.show();
    _interstitialAd = null;
    loadInterstitialAd();
  }

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }
}

final adService = AdService();
