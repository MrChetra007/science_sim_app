import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/services/ad_service.dart';
import '../../core/services/subscription_service.dart';

class AdService {
  static final SubscriptionService _subscription = SubscriptionService();

  static BannerAd? createBannerAd({bool isAdsRemoved = false}) {
    if (!_subscription.showBannerAds) return null;
    return globalAdService.createBannerAd();
  }

  static void showInterstitialAd({bool isAdsRemoved = false}) {
    globalAdService.showInterstitialAd();
  }

  // Keep for compatibility
  static Future<void> initialize() async {
    await globalAdService.init();
  }
}
