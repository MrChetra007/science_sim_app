import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IapService {
  static final IapService _instance = IapService._internal();
  factory IapService() => _instance;
  IapService._internal();

  final InAppPurchase _iap = InAppPurchase.instance;
  bool _isPro = false;
  bool get isPro => _isPro;

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isPro = prefs.getBool('is_pro') ?? false;

    // Debug override: Always start as a free user in debug mode
    if (kDebugMode) {
      _isPro = false;
    }

    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen(
      (purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () {
        _subscription?.cancel();
      },
      onError: (error) {
        // Handle error here.
      },
    );
  }

  Future<void> buyPro() async {
    // Mock purchase for now or real logic
    // In a real app, you'd fetch the ProductDetails first
    // final ProductDetailsResponse response = await _iap.queryProductDetails({'wave_lab_pro'}.toSet());
    // final PurchaseParam purchaseParam = PurchaseParam(productDetails: response.productDetails.first);
    // _iap.buyNonConsumable(purchaseParam: purchaseParam);

    // For this lab, let's allow "unlocking" easily
    await _setProStatus(true);
  }

  Future<void> _setProStatus(bool status) async {
    _isPro = status;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_pro', status);
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        _setProStatus(true);
      }
      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
      }
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}

final iapService = IapService();
