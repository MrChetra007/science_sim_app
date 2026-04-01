import 'package:go_router/go_router.dart';
import '../../features/home/home_screen.dart';
import '../../features/ph_explorer/ph_explorer_screen.dart';
import '../../features/titration/titration_screen.dart';
import '../../features/quiz/quiz_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/explorer',
      builder: (context, state) => const PHExplorerScreen(),
    ),
    GoRoute(
      path: '/titration',
      builder: (context, state) => const TitrationScreen(),
    ),
    GoRoute(
      path: '/quiz',
      builder: (context, state) => const QuizScreen(),
    ),
  ],
);
