import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ac_state.dart';

import 'package:flutter/services.dart';
import '../../core/services/subscription_service.dart';

enum UserTier { free, basic, premium }

class ACProvider extends ChangeNotifier {
  ACState _state = ACState();
  bool _running = true;

  double _voltsPerDiv = 50.0;
  double _timePerDiv = 2.0;

  int _primaryTurns = 100;
  int _secondaryTurns = 200;
  bool _humEnabled = false;

  // --- Monetization State ---
  UserTier _userTier = UserTier.free;
  DateTime? _rewardedUnlockExpiry;
  
  UserTier get userTier => _userTier;

  // Feature Checkers
  bool get isOscilloscopeUnlocked => SubscriptionService().isPro || _userTier != UserTier.free || _isTemporarilyUnlocked;
  bool get isTransformerLabUnlocked => SubscriptionService().isPro || _userTier != UserTier.free || _isTemporarilyUnlocked;
  bool get isReactiveLabUnlocked => SubscriptionService().isPro || _userTier == UserTier.premium || _isTemporarilyUnlocked;
  bool get areAdsEnabled => !SubscriptionService().isPro && _userTier == UserTier.free;

  bool get _isTemporarilyUnlocked {
    if (_rewardedUnlockExpiry == null) return false;
    return DateTime.now().isBefore(_rewardedUnlockExpiry!);
  }

  Duration? get rewardedTimeLeft {
    if (_rewardedUnlockExpiry == null) return null;
    final timeLeft = _rewardedUnlockExpiry!.difference(DateTime.now());
    return timeLeft.isNegative ? null : timeLeft;
  }

  void setUserTier(UserTier tier) {
    _userTier = tier;
    notifyListeners();
  }

  void activateRewardedUnlock() {
    _rewardedUnlockExpiry = DateTime.now().add(const Duration(minutes: 10));
    notifyListeners();
  }
  // --------------------------

  ACState get state           => _state;
  bool    get isRunning       => _running;
  bool    get humEnabled      => _humEnabled;
  double  get voltsPerDiv     => _voltsPerDiv;
  double  get timePerDiv      => _timePerDiv;
  int     get primaryTurns    => _primaryTurns;
  int     get secondaryTurns  => _secondaryTurns;

  double  get turnsRatio => _secondaryTurns / _primaryTurns;
  double  get secondaryVp => _state.vp * turnsRatio;

  // Callback for external components (like Wire) to trigger haptics on zero crossing
  void triggerZeroCrossingHaptic() {
    HapticFeedback.lightImpact();
  }

  // Setters for simulation parameters
  void setVp(double v) {
    if ((v - _state.vp).abs() > 5) HapticFeedback.selectionClick();
    _state = _state.copyWith(vp: v);
    notifyListeners();
  }

  void setFrequency(double f) {
    if ((f - _state.frequency).abs() > 1) HapticFeedback.selectionClick();
    _state = _state.copyWith(frequency: f);
    notifyListeners();
  }

  void setResistance(double r) {
    if ((r - _state.resistance).abs() > 10) HapticFeedback.selectionClick();
    _state = _state.copyWith(resistance: r);
    notifyListeners();
  }

  void setVoltsPerDiv(double v) {
    if (!isOscilloscopeUnlocked) return;
    _voltsPerDiv = v;
    notifyListeners();
    _savePrefs();
  }

  void setTimePerDiv(double t) {
    if (!isOscilloscopeUnlocked) return;
    _timePerDiv = t;
    notifyListeners();
    _savePrefs();
  }

  void setPrimaryTurns(int n) {
    _primaryTurns = n;
    notifyListeners();
    _savePrefs();
  }

  void setSecondaryTurns(int n) {
    _secondaryTurns = n;
    notifyListeners();
    _savePrefs();
  }

  void setInductance(double l) {
    _state = _state.copyWith(inductance: l);
    notifyListeners();
    _savePrefs();
  }

  void setCapacitance(double c) {
    _state = _state.copyWith(capacitance: c);
    notifyListeners();
    _savePrefs();
  }

  void toggleHum() {
    _humEnabled = !_humEnabled;
    notifyListeners();
    _savePrefs();
  }

  // Simulation tick: advances time
  void tick(double dt) {
    bool needsNotify = false;

    if (_running) {
      _state = _state.copyWith(time: _state.time + dt);
      needsNotify = true;
    }
    
    // Clean up expired rewarded access
    if (_rewardedUnlockExpiry != null) {
      if (DateTime.now().isAfter(_rewardedUnlockExpiry!)) {
        _rewardedUnlockExpiry = null;
      }
      needsNotify = true; // Always notify to update countdown UI if active
    }

    if (needsNotify) {
      notifyListeners();
    }
  }

  void togglePlay() {
    _running = !_running;
    notifyListeners();
  }

  void reset() {
    _state = _state.copyWith(time: 0.0);
    notifyListeners();
  }

  // Persistence: last slider values
  void _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('ac_vp',   _state.vp);
    await prefs.setDouble('ac_freq', _state.frequency);
    await prefs.setDouble('ac_res',  _state.resistance);
    await prefs.setBool('running', _running);
    await prefs.setDouble('voltsPerDiv', _voltsPerDiv);
    await prefs.setDouble('timePerDiv', _timePerDiv);
    await prefs.setInt('primaryTurns', _primaryTurns);
    await prefs.setInt('secondaryTurns', _secondaryTurns);
    await prefs.setDouble('ac_inductance', _state.inductance);
    await prefs.setDouble('ac_capacitance', _state.capacitance);
    await prefs.setBool('humEnabled', _humEnabled);
    await prefs.setInt('userTier', _userTier.index);
  }

  Future<void> loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _state = ACState(
      vp:         prefs.getDouble('ac_vp')   ?? 120.0,
      frequency:  prefs.getDouble('ac_freq') ?? 50.0,
      resistance: prefs.getDouble('ac_res')  ?? 100.0,
      inductance: prefs.getDouble('ac_inductance') ?? 0.0,
      capacitance: prefs.getDouble('ac_capacitance') ?? 0.0,
      time: 0.0,
    );
    _running = prefs.getBool('running') ?? true;
    _voltsPerDiv = prefs.getDouble('voltsPerDiv') ?? 50.0;
    _timePerDiv = prefs.getDouble('timePerDiv') ?? 2.0;
    _primaryTurns = prefs.getInt('primaryTurns') ?? 100;
    _secondaryTurns = prefs.getInt('secondaryTurns') ?? 200;
    _humEnabled = prefs.getBool('humEnabled') ?? false;

    _userTier = UserTier.values[prefs.getInt('userTier') ?? 0];
    
    notifyListeners();
  }
}
