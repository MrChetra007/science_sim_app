import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/simulation_provider.dart';
import '../widgets/control_panel.dart';
import '../widgets/results_panel.dart';
import '../services/audio_service.dart';
import '../widgets/simulation_graphs.dart';
import '../../../core/widgets/ad_widgets.dart';

class SimulationScreen extends ConsumerStatefulWidget {
  const SimulationScreen({super.key});

  @override
  ConsumerState<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends ConsumerState<SimulationScreen> {
  @override
  void initState() {
    super.initState();
    AudioService.init();
    // Reset simulation when entering this screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(simulationProvider.notifier).reset();
    });
  }

  void _showGraphs(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF101F2E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.only(top: 12),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A4A),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Expanded(child: SimulationGraphs()),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access the game instance from the provider
    final game = ref.read(projectileGameProvider);

    // Listen for score changes to show hit feedback
    ref.listen(simulationProvider.select((s) => s.score), (prev, next) {
      if (next > (prev ?? 0)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.stars_rounded, color: Color(0xFFFFD740)),
                const SizedBox(width: 12),
                Text(
                  'BULLSEYE! +100 POINTS',
                  style: TextStyle(
                    color: const Color(0xFFFFD740),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF1E3A4A),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1520),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => context.go('/'),
        ),
        title: const Text(
          'Physics Shot',
          style: TextStyle(
            color: Color(0xFF00E5FF),
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded, color: Color(0xFF00E5FF)),
            onPressed: () => _showGraphs(context),
            tooltip: 'Graphs',
          ),
          IconButton(
            icon: const Icon(Icons.menu_book_rounded, color: Color(0xFF00E5FF)),
            onPressed: () => context.go('/formula'),
            tooltip: 'Formulas',
          ),
          _SimStatusBadge(),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // ── FLAME CANVAS ─────────────────────────────────────────────
          Expanded(
            flex: 3,
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFF1E3A4A), width: 1),
                ),
              ),
              child: GameWidget(
                game: game,
                loadingBuilder: (_) => const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF00BCD4),
                  ),
                ),
              ),
            ),
          ),
          // ── RESULTS PANEL ─────────────────────────────────────────────
          const ResultsPanel(),
          const GlobalBannerAdWidget(),
          // ── CONTROL PANEL ─────────────────────────────────────────────
          const Expanded(
            flex: 2,
            child: ControlPanel(),
          ),
        ],
      ),
    );
  }
}

class _SimStatusBadge extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(simulationProvider);
    String label;
    Color color;

    if (state.isRunning) {
      label = '● LIVE';
      color = const Color(0xFF69FF47);
    } else if (state.isPaused) {
      label = '⏸ PAUSED';
      color = const Color(0xFFFFD740);
    } else if (state.isCompleted) {
      label = '✓ DONE';
      color = const Color(0xFF00E5FF);
    } else {
      label = '○ IDLE';
      color = const Color(0xFF546E7A);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
