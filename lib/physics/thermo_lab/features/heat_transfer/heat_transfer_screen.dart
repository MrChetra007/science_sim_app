import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' as p;
import 'flame/heat_game.dart';
import 'providers/heat_provider.dart';
import 'widgets/mode_tab_bar.dart';
import 'widgets/material_selector.dart';
import 'widgets/real_world_card.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../../../core/services/subscription_service.dart';
import '../../../../core/widgets/plan_picker.dart';
import '../../../../core/widgets/ad_widgets.dart';
import '../../../../l10n/generated/app_localizations.dart';

class HeatTransferScreen extends ConsumerStatefulWidget {
  const HeatTransferScreen({super.key});

  @override
  ConsumerState<HeatTransferScreen> createState() => _HeatTransferScreenState();
}

class _HeatTransferScreenState extends ConsumerState<HeatTransferScreen> {
  late HeatGame _game;

  @override
  void initState() {
    super.initState();
    _game = HeatGame(ref);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(heatProvider);
    final sub = p.Provider.of<SubscriptionService>(context);
    final isPro = sub.isPro;

    return Scaffold(
      appBar: AppBar(
        title: Text(isPro ? '${l10n.heatTransferLab} ⭐' : l10n.heatTransferLab),
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              child: ModeTabBar(),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
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
            const SizedBox(height: AppSpacing.md),
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.mode == HeatMode.conduction) const MaterialSelector(),
                      if (state.mode == HeatMode.radiation)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Distance: ${state.distance.toStringAsFixed(1)}m',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                            Slider(
                              value: state.distance,
                              min: 0.1,
                              max: 1.0,
                              activeColor: AppColors.accentHeat,
                              onChanged: (val) =>
                                  ref.read(heatProvider.notifier).setDistance(val),
                            ),
                          ],
                        ),
                      const SizedBox(height: AppSpacing.md),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Source Temperature: ${state.heatSourceTemp.toInt()}°C',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                          Slider(
                            value: state.heatSourceTemp,
                            min: 25.0,
                            max: 500.0,
                            activeColor: AppColors.accentHeat,
                            onChanged: (val) =>
                                ref.read(heatProvider.notifier).setHeatTemp(val),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      const HeatRealWorldCard(),
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
}
