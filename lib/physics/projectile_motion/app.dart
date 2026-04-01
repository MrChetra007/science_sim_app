import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/simulation_screen.dart';
import 'screens/formula_screen.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const HomeScreen(),
    ),
    GoRoute(
      path: '/simulation',
      builder: (_, __) => const SimulationScreen(),
    ),
    GoRoute(
      path: '/formula',
      builder: (_, __) => const FormulaScreen(),
    ),
  ],
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Physics Shot',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
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
