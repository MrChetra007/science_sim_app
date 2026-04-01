import 'package:go_router/go_router.dart';
import '../../features/home/home_screen.dart';
import '../../features/bohr_model/bohr_screen.dart';
import '../../features/electron_config/config_screen.dart';
import '../../features/molecule_viewer/molecule_screen.dart';
import '../../features/vsepr/vsepr_screen.dart';
import '../../features/orbital_viewer/orbital_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/bohr',
      builder: (context, state) => const BohrScreen(),
    ),
    GoRoute(
      path: '/config',
      builder: (context, state) => const ConfigScreen(),
    ),
    GoRoute(
      path: '/molecule',
      builder: (context, state) => const MoleculeScreen(),
    ),
    GoRoute(
      path: '/vsepr',
      builder: (context, state) => const VseprScreen(),
    ),
    GoRoute(
      path: '/orbital',
      builder: (context, state) => const OrbitalScreen(),
    ),
  ],
);
