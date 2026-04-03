import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SubscriptionPlan {
  free(0.0),
  monthly(0.99),
  lifetime(4.99);

  final double price;
  const SubscriptionPlan(this.price);

  bool get showBannerAds => this == SubscriptionPlan.free;
  bool get showInterstitialAds => this == SubscriptionPlan.free;
}

class SubscriptionService extends ChangeNotifier {
  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();

  SubscriptionPlan _currentPlan = SubscriptionPlan.free;
  SubscriptionPlan get currentPlan => _currentPlan;

  DateTime? _temporaryPremiumEndTime;
  int _rewardedAdsWatched = 0;

  DateTime? get temporaryPremiumEndTime => _temporaryPremiumEndTime;
  int get rewardedAdsWatched => _rewardedAdsWatched;

  bool get isPro {
    if (_currentPlan == SubscriptionPlan.monthly || _currentPlan == SubscriptionPlan.lifetime) return true;
    if (_temporaryPremiumEndTime != null && DateTime.now().isBefore(_temporaryPremiumEndTime!)) {
      return true;
    }
    return false;
  }

  bool get isPremium => _currentPlan == SubscriptionPlan.monthly || _currentPlan == SubscriptionPlan.lifetime;
  bool get isLifetime => _currentPlan == SubscriptionPlan.lifetime;
  bool get isTrial => _temporaryPremiumEndTime != null && DateTime.now().isBefore(_temporaryPremiumEndTime!);
  bool get isAdsRemoved => isPremium;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    int planIndex = prefs.getInt('user_subscription_plan') ?? 0;
    
    if (planIndex >= SubscriptionPlan.values.length) {
      planIndex = 0;
    }
    
    _currentPlan = SubscriptionPlan.values[planIndex];

    _rewardedAdsWatched = prefs.getInt('rewarded_ads_watched') ?? 0;
    final tempTimeStr = prefs.getString('temp_premium_end_time');
    if (tempTimeStr != null) {
      _temporaryPremiumEndTime = DateTime.tryParse(tempTimeStr);
      if (_temporaryPremiumEndTime != null && DateTime.now().isAfter(_temporaryPremiumEndTime!)) {
        _temporaryPremiumEndTime = null;
        await prefs.remove('temp_premium_end_time');
      }
    }

    notifyListeners();
  }

  Future<void> setPlan(SubscriptionPlan plan) async {
    _currentPlan = plan;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_subscription_plan', plan.index);
    notifyListeners();
  }

  Future<void> watchingRewardedAdSuccess() async {
    _rewardedAdsWatched += 1;
    final prefs = await SharedPreferences.getInstance();

    if (_rewardedAdsWatched >= 2) {
      _rewardedAdsWatched = 0;
      _temporaryPremiumEndTime = DateTime.now().add(const Duration(minutes: 10));
      await prefs.setString('temp_premium_end_time', _temporaryPremiumEndTime!.toIso8601String());
    }
    await prefs.setInt('rewarded_ads_watched', _rewardedAdsWatched);
    notifyListeners();
  }

  bool get showBannerAds => !isPremium;
  bool get showInterstitialAds => !isPremium;
}
