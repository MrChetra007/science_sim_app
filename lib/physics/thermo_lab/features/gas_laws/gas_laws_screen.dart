import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' as p;
import 'flame/piston_game.dart';
import 'providers/gas_provider.dart';
import 'widgets/gas_law_tabs.dart';
import 'widgets/pv_chart_widget.dart';
import 'widgets/variable_sliders.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/real_world_card.dart';
import '../../core/constants/real_world_examples.dart';
import '../../../../core/services/subscription_service.dart';
import '../../../../core/widgets/plan_picker.dart';
import '../../../../core/widgets/ad_widgets.dart';

class GasLawsScreen extends ConsumerStatefulWidget {
  const GasLawsScreen({super.key});

  @override
  ConsumerState<GasLawsScreen> createState() => _GasLawsScreenState();
}

class _GasLawsScreenState extends ConsumerState<GasLawsScreen> {
  late PistonGame _game;

  @override
  void initState() {
    super.initState();
    _game = PistonGame(ref);
  }

  // ✅ FIX 1: moved _getLawDescription INSIDE the class
  String _getLawDescription(GasLaw law) {
    switch (law) {
      case GasLaw.boyle:
        return "Boyle's Law: Pressure is inversely proportional to volume at constant temperature (PV = k).";
      case GasLaw.charles:
        return "Charles's Law: Volume is directly proportional to temperature at constant pressure (V/T = k).";
      case GasLaw.gayLussac:
        return "Gay-Lussac's Law: Pressure is directly proportional to temperature at constant volume (P/T = k).";
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gasProvider);
    final sub = p.Provider.of<SubscriptionService>(context);
    final isPro = sub.isPro;

    return Scaffold(
      appBar: AppBar(
        title: Text(isPro ? 'Gas Laws Explorer ⭐' : 'Gas Laws Explorer'),
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
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: GasLawTabs(),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.bgSurface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.borderDefault,
                            width: 2,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: GameWidget(game: _game),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          PVChartWidget(
                            currentP: state.pressure,
                            currentV: state.volume,
                            currentT: state.temperature,
                            law: state.law,
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            child: Text(
                              _getLawDescription(state.law),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                    fontStyle: FontStyle.italic,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const VariableSliders(),
                      const SizedBox(height: AppSpacing.lg),
                      const _GasRealWorldCard(), // ✅ used correctly as a widget
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ),
            if (!isPro) const GlobalBannerAdWidget(),
          ],
        ),
      ),
    );
  }
} // ✅ _GasLawsScreenState ends here

// ✅ FIX 2: proper class declaration extending ConsumerWidget
class _GasRealWorldCard extends ConsumerWidget {
  const _GasRealWorldCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gasProvider);
    final example =
        kRealWorldExamples['gas_laws']?[state.law.index] ??
        kRealWorldExamples['gas_laws']![0];

    return RealWorldCard(example: example, accentColor: AppColors.accentGas);
  }
}
