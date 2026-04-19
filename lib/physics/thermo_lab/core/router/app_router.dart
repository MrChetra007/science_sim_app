import 'package:go_router/go_router.dart';
import '../../features/home/home_screen.dart';
import '../../features/heat_transfer/heat_transfer_screen.dart';
import '../../features/gas_laws/gas_laws_screen.dart';
import '../../features/carnot_engine/carnot_screen.dart';
import '../../features/phase_change/phase_change_screen.dart';
import '../../features/entropy/entropy_screen.dart';
import '../../features/thermo_laws/thermo_laws_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/',           builder: (_, _) => const HomeScreen()),
    GoRoute(path: '/heat',       builder: (_, _) => const HeatTransferScreen()),
    GoRoute(path: '/gas',        builder: (_, _) => const GasLawsScreen()),
    GoRoute(path: '/carnot',     builder: (_, _) => const CarnotScreen()),
    GoRoute(path: '/phase',      builder: (_, _) => const PhaseChangeScreen()),
    GoRoute(path: '/entropy',    builder: (_, _) => const EntropyScreen()),
    GoRoute(path: '/laws',       builder: (_, _) => const ThermoLawsScreen()),
  ],
);
