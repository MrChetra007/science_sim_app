import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../providers/circuit_provider.dart';

class IAPService {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final CircuitProvider provider;

  static const String removeAdsId =
      'remove_ads_099'; // To be configured in Play Console

  IAPService(this.provider) {
    final purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription.cancel(),
      onError: (error) => debugPrint('IAP Error: $error'),
    );
  }

  void dispose() {
    _subscription.cancel();
  }

  Future<void> _onPurchaseUpdate(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    print('onPurchaseUpdate');
    for (var purchase in purchaseDetailsList) {
      print('purchase: $purchase');
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        if (purchase.productID == removeAdsId) {
          await provider.setAdsRemoved(true);
        }
        if (purchase.pendingCompletePurchase) {
          await _iap.completePurchase(purchase);
        }
      }
    }
  }

  Future<void> buyRemoveAds() async {
    print('buyRemoveAds');
    final bool available = await _iap.isAvailable();
    if (!available) return;

    final ProductDetailsResponse response = await _iap.queryProductDetails({
      removeAdsId,
    });
    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('Product not found');
      return;
    }

    final ProductDetails productDetails = response.productDetails.first;
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: productDetails,
    );

    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }
}
