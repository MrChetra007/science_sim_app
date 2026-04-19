import 'package:go_router/go_router.dart';
import '../../features/home/home_screen.dart';
import '../../features/galvanic_cell/galvanic_screen.dart';
import '../../features/nernst/nernst_screen.dart';
import '../../features/electrolysis/electrolysis_screen.dart';
import '../../features/electroplating/electroplating_screen.dart';

// Placeholder Screens for other modules

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/',               builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/galvanic',       builder: (context, state) => const GalvanicScreen()),
    GoRoute(path: '/electrolysis',   builder: (context, state) => const ElectrolysisScreen()),
    GoRoute(path: '/nernst',         builder: (context, state) => const NernstScreen()),
    GoRoute(path: '/electroplating', builder: (context, state) => const ElectroplatingScreen()),
  ],
);
