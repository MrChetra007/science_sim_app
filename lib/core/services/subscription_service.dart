import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SubscriptionPlan {
  free(0.0),
  premium(2.99);

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
    if (_currentPlan == SubscriptionPlan.premium) return true;
    if (_temporaryPremiumEndTime != null && DateTime.now().isBefore(_temporaryPremiumEndTime!)) {
      return true;
    }
    return false;
  }

  // New helper getters to distinguish between permanent and temporary
  bool get isPremium => _currentPlan == SubscriptionPlan.premium;
  bool get isTrial => _temporaryPremiumEndTime != null && DateTime.now().isBefore(_temporaryPremiumEndTime!);
  bool get isAdsRemoved => isPremium;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    int planIndex = prefs.getInt('user_subscription_plan') ?? 0;
    
    // Safety check for changed indices:
    if (planIndex == 2) {
      planIndex = 1; // Map old premium to new premium
    } else if (planIndex == 1) {
      planIndex = 0; // Map old basic to free
    }

    if (planIndex >= SubscriptionPlan.values.length) {
      planIndex = 0;
    }
    
    _currentPlan = SubscriptionPlan.values[planIndex];

    _rewardedAdsWatched = prefs.getInt('rewarded_ads_watched') ?? 0;
    final tempTimeStr = prefs.getString('temp_premium_end_time');
    if (tempTimeStr != null) {
      _temporaryPremiumEndTime = DateTime.tryParse(tempTimeStr);
      // Clean it up if expired
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

  // Helper for labs to check ad status
  // Trial (temporary unlock) still shows ads. Only Premium (permanent purchase) hides them.
  bool get showBannerAds => !isPremium;
  bool get showInterstitialAds => !isPremium;
}
