import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'subscription_service.dart';

class GlobalAdService {
  static final GlobalAdService _instance = GlobalAdService._internal();
  factory GlobalAdService() => _instance;
  GlobalAdService._internal();

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  final SubscriptionService _subscription = SubscriptionService();

  static const String androidAppId = 'ca-app-pub-2040811472235687~8797097896';
  static const String androidBannerId = 'ca-app-pub-2040811472235687/3889655063';
  static const String androidInterstitialId = 'ca-app-pub-2040811472235687/5067005366';
  static const String androidRewardedId = 'ca-app-pub-2040811472235687/8615368138';
  
  static const String iosAppId = 'ca-app-pub-3940256099942544/6300978111';
  static const String iosBannerId = 'ca-app-pub-3940256099942544/2934735716';
  static const String iosInterstitialId = 'ca-app-pub-2040811472235687/5067005366';
  static const String iosRewardedId = 'ca-app-pub-2040811472235687/8615368138';

  String get appId => Platform.isAndroid ? androidAppId : iosAppId;
  String get bannerAdUnitId => Platform.isAndroid ? androidBannerId : iosBannerId;
  String get interstitialAdUnitId => Platform.isAndroid ? androidInterstitialId : iosInterstitialId;
  String get rewardedAdUnitId => Platform.isAndroid ? androidRewardedId : iosRewardedId;

  Future<void> init() async {
    await MobileAds.instance.initialize();
    loadInterstitialAd();
    loadRewardedAd();
  }

  void loadInterstitialAd() {
    if (!_subscription.showInterstitialAds) return;

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
    if (!_subscription.showInterstitialAds) return;

    if (_interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null;
      loadInterstitialAd();
    }
  }

  void loadRewardedAd() {
    if (_subscription.isPro) return; // Don't explicitly need to cache if they are pro, but useful if they are trying to extend. Let's optimize.

    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
        },
      ),
    );
  }

  void showRewardedAd({required Function onEarnedReward, required Function onClosed}) {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _rewardedAd = null;
          loadRewardedAd();
          onClosed();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _rewardedAd = null;
          loadRewardedAd();
          onClosed();
        },
      );
      
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          onEarnedReward();
        },
      );
    } else {
      // Ad not ready, try loading again
      loadRewardedAd();
      onClosed();
    }
  }

  // For banner widgets across labs
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

final globalAdService = GlobalAdService();
