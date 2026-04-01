import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

class OhmsLawApp extends StatelessWidget {
  const OhmsLawApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Ohm Lab",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
