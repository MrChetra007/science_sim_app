import 'dart:async';
import '../../../core/services/iap_service.dart';
import '../../../core/services/subscription_service.dart';

class IapService {
  static final IapService _instance = IapService._internal();
  factory IapService() => _instance;
  IapService._internal();

  final IAPService _iapService = IAPService();
  bool get isPro => _iapService.isPro;
  bool get isAdsRemoved => _iapService.isAdsRemoved;

  Future<void> init() async {}

  Future<void> buyPro() async {
    await _iapService.buyLifetime();
  }

  Future<void> toggleProStatus() async {
    if (isPro) {
      await SubscriptionService().setPlan(SubscriptionPlan.free);
    } else {
      await _iapService.buyLifetime();
    }
  }

  void dispose() {}
}

final iapService = IapService();
