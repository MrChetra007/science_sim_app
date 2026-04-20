import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' as p;
import 'flame/carnot_game.dart';
import 'providers/carnot_provider.dart';
import 'widgets/efficiency_card.dart';
import 'widgets/cycle_controls.dart';
import 'widgets/carnot_chart_widget.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/real_world_card.dart';
import '../../core/constants/real_world_examples.dart';
import '../../../../core/services/subscription_service.dart';
import '../../../../core/widgets/plan_picker.dart';
import '../../../../core/widgets/ad_widgets.dart';
import '../../../../l10n/generated/app_localizations.dart';

class CarnotScreen extends ConsumerStatefulWidget {
  const CarnotScreen({super.key});

  @override
  ConsumerState<CarnotScreen> createState() => _CarnotScreenState();
}

class _CarnotScreenState extends ConsumerState<CarnotScreen> {
  late CarnotGame _game;

  @override
  void initState() {
    super.initState();
    _game = CarnotGame(ref);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(carnotProvider);
    final sub = p.Provider.of<SubscriptionService>(context);
    final isPro = sub.isPro;

    return Scaffold(
      appBar: AppBar(
        title: Text(isPro ? '${l10n.carnotEngineSimulator} ⭐' : l10n.carnotEngineSimulator),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (!isPro)
            IconButton(
              icon: const Icon(Icons.star, color: Colors.amber),
              onPressed: () => showGlobalPlanDialog(context),
              tooltip: l10n.upgradeToPro,
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.bgSurface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.borderDefault, width: 2),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: GameWidget(game: _game),
                ),
              ),
            ),
            
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: ValueListenableBuilder<double>(
                            valueListenable: _game.volumeNotifier,
                            builder: (context, volume, child) {
                              return CarnotChartWidget(
                                currentP: (state.tempHot / 100) / volume,
                                currentV: volume,
                                Th: state.tempHot,
                                Tc: state.tempCold,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        const Expanded(
                          flex: 2,
                          child: EfficiencyCard(),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    
                    CycleControls(game: _game),
                    const SizedBox(height: AppSpacing.lg),
                    
                    _CarnotRealWorldCard(),
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

class _CarnotRealWorldCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final example = kRealWorldExamples['carnot']![0];
    return RealWorldCard(
      example: example,
      accentColor: AppColors.accentCarnot,
    );
  }
}
