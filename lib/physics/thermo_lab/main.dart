import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/generated/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

void main() {
  runApp(const ProviderScope(child: ThermoSimApp()));
}

class ThermoSimApp extends StatefulWidget {
  const ThermoSimApp({super.key});

  @override
  State<ThermoSimApp> createState() => _ThermoSimAppState();
}

class _ThermoSimAppState extends State<ThermoSimApp> {
  Locale _locale = const Locale('en');

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('app_locale');
    if (code != null && mounted) {
      setState(() => _locale = Locale(code));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Thermo Lab',
      theme: buildAppTheme(),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
