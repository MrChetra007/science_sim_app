import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const String _localeKey = 'app_locale';
  
  Locale _locale = const Locale('en');
  bool _initialized = false;
  
  Locale get locale => _locale;
  bool get isInitialized => _initialized;
  
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('km'),
  ];
  
  LocaleProvider();
  
  Future<void> init() async {
    await _loadLocale();
    _initialized = true;
  }
  
  Future<void> _loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(_localeKey);
      if (code != null && code.isNotEmpty) {
        _locale = Locale(code);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading locale: $e');
    }
  }
  
  Future<void> setLocale(Locale locale) async {
    if (!supportedLocales.contains(locale)) return;
    
    _locale = locale;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, locale.languageCode);
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving locale: $e');
    }
  }
  
  void toggleLocale() {
    if (_locale.languageCode == 'en') {
      setLocale(const Locale('km'));
    } else {
      setLocale(const Locale('en'));
    }
  }
}