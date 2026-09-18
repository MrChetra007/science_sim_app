import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'lessons/screens/home_screen.dart';
import 'theme.dart';

import '../../core/services/subscription_service.dart';
import '../../l10n/generated/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const OpticsLabApp());
}

class OpticsLabApp extends StatelessWidget {
  const OpticsLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: SubscriptionService(),
      child: MaterialApp(
        title: 'OpticsLab',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomeScreen(),
      ),
    );
  }
}