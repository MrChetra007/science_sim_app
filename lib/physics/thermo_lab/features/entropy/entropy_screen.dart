import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' as p;
import 'flame/entropy_game.dart';
import 'widgets/entropy_meter.dart';
import 'widgets/entropy_controls.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/real_world_card.dart';
import '../../core/constants/real_world_examples.dart';
import '../../../../core/services/subscription_service.dart';
import '../../../../core/widgets/plan_picker.dart';
import '../../../../core/widgets/ad_widgets.dart';
import '../../../../l10n/generated/app_localizations.dart';

class EntropyScreen extends ConsumerStatefulWidget {
  const EntropyScreen({super.key});

  @override
  ConsumerState<EntropyScreen> createState() => _EntropyScreenState();
}

class _EntropyScreenState extends ConsumerState<EntropyScreen> {
  late EntropyGame _game;

  @override
  void initState() {
    super.initState();
    _game = EntropyGame(ref);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sub = p.Provider.of<SubscriptionService>(context);
    final isPro = sub.isPro;

    return Scaffold(
      appBar: AppBar(
        title: Text(isPro ? '${l10n.entropyExplorer} ⭐' : l10n.entropyExplorer),
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
                  child: GameWidget(game: _game),
                ),
              ),
            ),
            
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  children: [
                    ValueListenableBuilder<double>(
                      valueListenable: _game.entropyNotifier,
                      builder: (context, value, child) {
                        return EntropyMeter(value: value);
                      }
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    
                    const EntropyControls(),
                    const SizedBox(height: AppSpacing.lg),
                    
                    const _EntropyExplanation(),
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

class _EntropyExplanation extends StatelessWidget {
  const _EntropyExplanation();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.bgElevated.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.accentLaws, size: 20),
              const SizedBox(width: 8),
              Text(
                l10n.theSecondLaw,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.accentLaws),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Nature always tends toward disorder. Once the wall is removed, the red and blue particles will spread until they are uniformly mixed. They will never spontaneously un-mix!',
            style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _RealWorldExampleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final example = kRealWorldExamples['entropy']![1]; // Perfume spreading

    return RealWorldCard(
      example: example,
      accentColor: AppColors.accentEntropy,
    );
  }
}
