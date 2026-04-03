import 'dart:async';
import '../../../core/services/subscription_service.dart';

class IapService {
  static final IapService _instance = IapService._internal();
  factory IapService() => _instance;
  IapService._internal();

  final SubscriptionService _subscription = SubscriptionService();
  bool get isPro => _subscription.isPro;
  bool get isAdsRemoved => _subscription.isAdsRemoved;

  Future<void> init() async {
    // All persistence is now handled by GlobalSubscriptionService
  }

  Future<void> buyPro() async {
    await _subscription.setPlan(SubscriptionPlan.lifetime);
  }

  Future<void> toggleProStatus() async {
    if (isPro) {
      await _subscription.setPlan(SubscriptionPlan.free);
    } else {
      await _subscription.setPlan(SubscriptionPlan.lifetime);
    }
  }

  void dispose() {}
}

final iapService = IapService();
