import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/generated/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import '../../core/services/subscription_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    p.MultiProvider(
      providers: [p.ChangeNotifierProvider.value(value: SubscriptionService())],
      child: const ProviderScope(child: PhSimApp()),
    ),
  );
}

class PhSimApp extends StatefulWidget {
  const PhSimApp({super.key});

  @override
  State<PhSimApp> createState() => _PhSimAppState();
}

class _PhSimAppState extends State<PhSimApp> {
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
      title: 'pH Lab',
      theme: buildAppTheme(),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
