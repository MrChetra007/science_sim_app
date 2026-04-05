import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../services/subscription_service.dart';

class IAPService {
  static final IAPService _instance = IAPService._internal();
  factory IAPService() => _instance;
  IAPService._internal();

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  final SubscriptionService _subscriptionService = SubscriptionService();

  // Product IDs - configure these in Google Play Console
  static const String monthlyId = 'subscription_0.99';
  static const String lifetimeId = 'sozin.wave';

  final Set<String> _productIds = {monthlyId, lifetimeId};

  // Callback when purchase succeeds
  VoidCallback? onPurchaseSuccess;
  SubscriptionPlan? _lastPurchasedPlan;
  SubscriptionPlan? get lastPurchasedPlan => _lastPurchasedPlan;

  bool get isPro => _subscriptionService.isPro;
  bool get isAdsRemoved => _subscriptionService.isAdsRemoved;

  Future<void> init() async {
    // Listen to purchase stream
    final purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription?.cancel(),
      onError: (error) => debugPrint('IAP Error: $error'),
    );

    // Check for existing purchases
    await _checkExistingPurchases();
  }

  Future<void> _checkExistingPurchases() async {
    try {
      final bool available = await _iap.isAvailable();
      if (!available) return;

      await _iap.queryProductDetails(_productIds);
      await _iap.restorePurchases();
    } catch (e) {
      debugPrint('Error checking purchases: $e');
    }
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        if (purchase.productID == monthlyId ||
            purchase.productID == lifetimeId) {
          _handleSuccessfulPurchase(purchase.productID);
        }

        // Complete the purchase
        if (purchase.pendingCompletePurchase) {
          _iap.completePurchase(purchase);
        }
      } else if (purchase.status == PurchaseStatus.error) {
        debugPrint('Purchase error: ${purchase.error?.message}');
      } else if (purchase.status == PurchaseStatus.canceled) {
        debugPrint('Purchase canceled');
      }
    }
  }

  void _handleSuccessfulPurchase(String productId) {
    SubscriptionPlan? plan;
    if (productId == lifetimeId) {
      plan = SubscriptionPlan.lifetime;
      _subscriptionService.setPlan(SubscriptionPlan.lifetime);
    } else if (productId == monthlyId) {
      plan = SubscriptionPlan.monthly;
      _subscriptionService.setPlan(SubscriptionPlan.monthly);
    }
    
    if (plan != null) {
      _lastPurchasedPlan = plan;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onPurchaseSuccess?.call();
      });
    }
  }

  Future<bool> buyMonthly() async {
    return _buyProduct(monthlyId);
  }

  Future<bool> buyLifetime() async {
    return _buyProduct(lifetimeId);
  }

  Future<bool> _buyProduct(String productId) async {
    try {
      final bool available = await _iap.isAvailable();
      if (!available) {
        debugPrint('IAP not available');
        return false;
      }

      final ProductDetailsResponse response = await _iap.queryProductDetails({
        productId,
      });

      if (response.notFoundIDs.isNotEmpty) {
        debugPrint('Product not found: $productId');
        return false;
      }

      final ProductDetails productDetails = response.productDetails.first;
      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: productDetails,
      );

      // Use buyNonConsumable for both lifetime and subscriptions
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      return true;
    } catch (e) {
      debugPrint('Buy error: $e');
      return false;
    }
  }

  Future<void> restorePurchases() async {
    try {
      await _checkExistingPurchases();
      debugPrint('Restore purchases completed');
    } catch (e) {
      debugPrint('Restore purchases error: $e');
    }
  }

  Future<bool> verifySubscriptionStatus() async {
    try {
      final bool available = await _iap.isAvailable();
      if (!available) return _subscriptionService.isPro;

      await _iap.queryProductDetails(_productIds);
      await _iap.restorePurchases();
      
      return _subscriptionService.isPro;
    } catch (e) {
      debugPrint('Verify subscription error: $e');
      return _subscriptionService.isPro;
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}

final iapService = IAPService();
