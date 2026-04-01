import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import '../../core/services/subscription_service.dart';
import '../../core/widgets/ad_widgets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    p.MultiProvider(
      providers: [p.ChangeNotifierProvider.value(value: SubscriptionService())],
      child: const ProviderScope(child: PhSimApp()),
    ),
  );
}

class PhSimApp extends StatelessWidget {
  const PhSimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'pH Lab',
      theme: buildAppTheme(),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
