import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'lessons/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Orientation Lock: Portrait Only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(
      const ProviderScope(
        child: RelativityApp(),
      ),
    );
  });
}

class RelativityApp extends StatelessWidget {
  const RelativityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Special Relativity Physics Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xff0a0a1a),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff4fc3f7),
          brightness: Brightness.dark,
          background: const Color(0xff0a0a1a),
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
