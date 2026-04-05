import 'package:flame/game.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' as p;
import 'flame/phase_game.dart';
import 'providers/phase_provider.dart';
import 'widgets/heating_curve_widget.dart';
import 'widgets/phase_controls.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/real_world_card.dart';
import '../../core/constants/real_world_examples.dart';
import '../../../../core/services/subscription_service.dart';
import '../../../../core/widgets/plan_picker.dart';
import '../../../../core/widgets/ad_widgets.dart';

class PhaseChangeScreen extends ConsumerStatefulWidget {
  const PhaseChangeScreen({super.key});

  @override
  ConsumerState<PhaseChangeScreen> createState() => _PhaseChangeScreenState();
}

class _PhaseChangeScreenState extends ConsumerState<PhaseChangeScreen> {
  late PhaseGame _game;

  @override
  void initState() {
    super.initState();
    _game = PhaseGame(ref);
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(phaseProvider);
    final sub = p.Provider.of<SubscriptionService>(context);
    final isPro = sub.isPro;

    return Scaffold(
      appBar: AppBar(
        title: Text(isPro ? 'Phase Change Simulator ⭐' : 'Phase Change Simulator'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (!isPro)
            IconButton(
              icon: const Icon(Icons.star, color: Colors.amber),
              onPressed: () => showGlobalPlanDialog(context),
              tooltip: 'Upgrade to Pro',
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.bgSurface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.borderDefault, width: 2),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      GameWidget(game: _game),
                      _PhaseOverlay(game: _game),
                    ],
                  ),
                ),
              ),
            ),
            
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  children: [
                    ValueListenableBuilder<List<FlSpot>>(
                      valueListenable: _game.curveNotifier,
                      builder: (context, spots, child) {
                        return HeatingCurveChart(
                          spots: spots,
                          meltingPoint: settings.substance.meltingPoint,
                          boilingPoint: settings.substance.boilingPoint,
                          currentTemp: spots.isEmpty ? 0 : spots.last.y,
                        );
                      }
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    
                    const PhaseControls(),
                    const SizedBox(height: AppSpacing.lg),
                    
                    _RealWorldExampleCard(),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
            if (!isPro) const GlobalBannerAdWidget(),
          ],
        ),
      ),
    );
  }
}

class _PhaseOverlay extends StatelessWidget {
  final PhaseGame game;

  const _PhaseOverlay({required this.game});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      left: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder<double>(
            valueListenable: game.tempNotifier,
            builder: (context, temp, child) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${temp.toStringAsFixed(1)} °C',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          ValueListenableBuilder<PhysicalState>(
            valueListenable: game.phaseNotifier,
            builder: (context, phase, child) {
              return ValueListenableBuilder<double>(
                valueListenable: game.progressNotifier,
                builder: (context, progress, child) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accentPhase.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _getPhaseName(phase, progress),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  String _getPhaseName(PhysicalState phase, double progress) {
    switch (phase) {
      case PhysicalState.solid:
        return 'SOLID';
      case PhysicalState.melting:
        return 'MELTING... (${(progress * 100).toInt()}%)';
      case PhysicalState.liquid:
        return 'LIQUID';
      case PhysicalState.boiling:
        return 'BOILING... (${(progress * 100).toInt()}%)';
      case PhysicalState.gas:
        return 'GAS';
    }
  }
}

class _RealWorldExampleCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(phaseProvider);
    final examples = kRealWorldExamples['phase_change']!;
    
    final example = settings.substance.name == 'Water' ? examples[0] : examples[2];

    return RealWorldCard(
      example: example,
      accentColor: AppColors.accentPhase,
    );
  }
}
