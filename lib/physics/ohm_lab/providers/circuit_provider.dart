import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/subscription_service.dart';

class CircuitProvider extends ChangeNotifier {
  double _voltage    = 12.0;
  double _resistance = 100.0;
  bool   _isAdsRemoved = false;

  CircuitProvider() {
    _loadAdsRemoved();
  }

  double get voltage    => _voltage;
  double get resistance => _resistance;
  double get current    => _voltage / _resistance;
  double get power      => _voltage * current;
  bool   get isDangerous => current > 1.0;
  bool   get isAdsRemoved => SubscriptionService().isPro || _isAdsRemoved;

  void setVoltage(double v) {
    _voltage = v;
    notifyListeners();
  }

  void setResistance(double r) {
    _resistance = r;
    notifyListeners();
  }

  Future<void> _loadAdsRemoved() async {
    final prefs = await SharedPreferences.getInstance();
    _isAdsRemoved = prefs.getBool('ads_removed') ?? false;
    notifyListeners();
  }

  Future<void> setAdsRemoved(bool removed) async {
    _isAdsRemoved = removed;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ads_removed', removed);
    notifyListeners();
  }
}
