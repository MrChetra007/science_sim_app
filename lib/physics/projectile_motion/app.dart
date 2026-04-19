import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/generated/app_localizations.dart';
import 'screens/home_screen.dart';
import 'screens/simulation_screen.dart';
import 'screens/formula_screen.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, _) => const HomeScreen(),
    ),
    GoRoute(
      path: '/simulation',
      builder: (_, _) => const SimulationScreen(),
    ),
    GoRoute(
      path: '/formula',
      builder: (_, _) => const FormulaScreen(),
    ),
  ],
);

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
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
      title: 'Physics Shot',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00BCD4),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0D1B2A),
        sliderTheme: const SliderThemeData(
          activeTrackColor: Color(0xFF00BCD4),
          thumbColor: Color(0xFF00BCD4),
          inactiveTrackColor: Color(0xFF1E3A4A),
          overlayColor: Color(0x2200BCD4),
        ),
      ),
    );
  }
}
