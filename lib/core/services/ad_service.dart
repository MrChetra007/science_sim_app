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

  // ✅ Production Ad IDs
  static const String androidAppId = 'ca-app-pub-2040811472235687~8797097896';
  static const String androidBannerId =
      'ca-app-pub-2040811472235687/3889655063';
  static const String androidInterstitialId =
      'ca-app-pub-2040811472235687/5067005366';
  static const String androidRewardedId =
      'ca-app-pub-2040811472235687/8615368138';

  static const String iosAppId = 'ca-app-pub-3940256099942544/6300978111';
  static const String iosBannerId = 'ca-app-pub-3940256099942544/2934735716';
  static const String iosInterstitialId =
      'ca-app-pub-2040811472235687/5067005366';
  static const String iosRewardedId = 'ca-app-pub-2040811472235687/8615368138';

  String get appId => Platform.isAndroid ? androidAppId : iosAppId;
  String get bannerAdUnitId =>
      Platform.isAndroid ? androidBannerId : iosBannerId;
  String get interstitialAdUnitId =>
      Platform.isAndroid ? androidInterstitialId : iosInterstitialId;
  String get rewardedAdUnitId =>
      Platform.isAndroid ? androidRewardedId : iosRewardedId;

  Future<void> init() async {
    await MobileAds.instance.initialize();
    // ✅ FIX: Removed eagerly calling loadInterstitialAd() and
    // loadRewardedAd() here. Those calls created 1x1 ImageReader surfaces
    // immediately at app startup, before GMS services were ready on the
    // device/emulator. This caused surface abandonLocked errors and
    // destabilized the Dynamite module → SIG 9 crash.
    //
    // Ads are now loaded lazily:
    //   - Interstitial: call loadInterstitialAd() before you intend to show it
    //   - Rewarded: call loadRewardedAd() before you intend to show it
  }

  // ✅ Call this manually before a screen where you plan to show an interstitial
  void loadInterstitialAd() {
    if (!_subscription.showInterstitialAds) return;
    if (_interstitialAd != null) return; // already loaded, don't double-load

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
      // ✅ Reload after showing so it's ready for next time
      loadInterstitialAd();
    }
  }

  bool _rewardedAdFailedToLoad = false;
  DateTime? _lastRewardedAdFailure;

  // ✅ Call this manually before a screen where you plan to show a rewarded ad
  void loadRewardedAd() {
    if (_subscription.isPro) return;
    if (_rewardedAd != null) return; // already loaded, don't double-load

    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _rewardedAdFailedToLoad = false;
        },
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
          _rewardedAdFailedToLoad = true;
          _lastRewardedAdFailure = DateTime.now();
        },
      ),
    );
  }

  bool get canGrantFallbackReward {
    if (!_rewardedAdFailedToLoad) return false;
    if (_lastRewardedAdFailure == null) return false;
    final now = DateTime.now();
    if (now.difference(_lastRewardedAdFailure!).inMinutes < 30) return false;
    return true;
  }

  void grantFallbackReward() {
    _rewardedAdFailedToLoad = false;
    _lastRewardedAdFailure = null;
  }

  void showRewardedAd({
    required Function onEarnedReward,
    required Function onClosed,
  }) {
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
      _rewardedAd = null; // ✅ prevent re-showing this ad on rapid taps
    } else if (canGrantFallbackReward) {
      grantFallbackReward();
      onEarnedReward();
      onClosed();
    } else {
      loadRewardedAd();
      onClosed();
    }
  }

  // For banner widgets across labs — unchanged, used correctly already
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

  /// ✅ Call this in your app's dispose or when you know ads won't be
  /// needed anymore (e.g. user goes Pro). Cleans up any loaded ads.
  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _rewardedAd?.dispose();
    _rewardedAd = null;
  }
}

final globalAdService = GlobalAdService();
