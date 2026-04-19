import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/generated/app_localizations.dart';
import 'providers/circuit_provider.dart';
import 'core/theme.dart';
import 'services/ad_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AdService.initialize();
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => CircuitProvider(),
      child: const OhmsLawApp(),
    ),
  );
}

class OhmsLawApp extends StatefulWidget {
  const OhmsLawApp({super.key});

  @override
  State<OhmsLawApp> createState() => _OhmsLawAppState();
}

class _OhmsLawAppState extends State<OhmsLawApp> {
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
      title: "Ohm Lab",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
