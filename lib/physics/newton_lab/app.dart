import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/generated/app_localizations.dart';
import 'core/theme.dart';
import 'ui/home_screen.dart';

class NewtonsLabApp extends StatefulWidget {
  const NewtonsLabApp({super.key});

  @override
  State<NewtonsLabApp> createState() => _NewtonsLabAppState();
}

class _NewtonsLabAppState extends State<NewtonsLabApp> {
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
    return MaterialApp(
      title: "NewtonLab",
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
