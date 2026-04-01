import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../core/services/ad_service.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  String get bannerAdUnitId => globalAdService.bannerAdUnitId;
  String get interstitialAdUnitId => globalAdService.interstitialAdUnitId;

  Future<void> init() async {
    await globalAdService.init();
  }

  void loadInterstitialAd() {
    globalAdService.loadInterstitialAd();
  }

  void showInterstitialAd() {
    globalAdService.showInterstitialAd();
  }

  BannerAd createBannerAd() {
    return globalAdService.createBannerAd();
  }
}

final adService = AdService();
