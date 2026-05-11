import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;
import '../../../../l10n/generated/app_localizations.dart';
import '../../core/constants/elements_data.dart';
import '../../core/theme/app_colors.dart';
import '../../../../core/services/subscription_service.dart';
import '../../../../core/widgets/ad_widgets.dart';
import '../../../../core/widgets/plan_picker.dart';
import 'flame/bohr_game.dart';
import 'providers/bohr_provider.dart';
import 'widgets/element_info_card.dart';
import 'widgets/element_selector.dart';

class BohrScreen extends ConsumerStatefulWidget {
  const BohrScreen({super.key});

  @override
  ConsumerState<BohrScreen> createState() => _BohrScreenState();
}

class _BohrScreenState extends ConsumerState<BohrScreen> {
  late final BohrGame _game;

  @override
  void initState() {
    super.initState();
    final initialElement = ref.read(bohrProvider);
    _game = BohrGame(initialElement: initialElement);
  }

  @override
  Widget build(BuildContext context) {
    final selectedEl = ref.watch(bohrProvider);
    final sub = p.Provider.of<SubscriptionService>(context);
    final l10n = AppLocalizations.of(context)!;
    
    final isPro = sub.isPro;
    final freeElementsCount = isPro ? kElements.length : 10;
    final availableElements = kElements.sublist(0, freeElementsCount);

    ref.listen(bohrProvider, (_, el) {
      _game.switchElement(el);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(isPro ? l10n.bohrModelTitle : l10n.bohrModelTitle),
        actions: [
          if (!isPro)
            IconButton(
              icon: const Icon(Icons.star, color: Colors.amber),
              onPressed: () => showGlobalPlanDialog(context),
              tooltip: l10n.upgradeToPro,
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 380,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                border: Border.all(color: AppColors.borderDefault),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.xl),
                child: GameWidget(game: _game),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _game.exciteElectrons,
                      icon: const Icon(Icons.bolt_rounded, size: 20),
                      label: Text(l10n.exciteOuterElectrons),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orbitalP.withValues(alpha: 0.2),
                        foregroundColor: AppColors.orbitalP,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(
                          color: AppColors.orbitalP.withValues(alpha: 0.4),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            if (!isPro)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock_outline, color: Colors.amber, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.upgradeToUnlock36,
                        style: TextStyle(color: Colors.amber.shade200, fontSize: 12),
                      ),
                    ),
                    TextButton(
                      onPressed: () => showGlobalPlanDialog(context),
                      child: Text(l10n.upgrade, style: const TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.science_outlined,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isPro ? l10n.selectElementPro : l10n.selectElementFree,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            ElementSelector(
              elements: availableElements,
              selected: selectedEl,
              onSelect: (el) => ref.read(bohrProvider.notifier).select(el),
            ),

            const SizedBox(height: AppSpacing.sm),

            ElementInfoCard(element: selectedEl),

            const SizedBox(height: AppSpacing.md),
            const GlobalBannerAdWidget(),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
