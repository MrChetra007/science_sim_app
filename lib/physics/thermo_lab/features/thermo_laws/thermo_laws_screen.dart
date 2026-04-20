import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' as p;
import 'thermo_laws_data.dart';
import 'widgets/law_card.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../../../core/services/subscription_service.dart';
import '../../../../core/widgets/plan_picker.dart';
import '../../../../core/widgets/ad_widgets.dart';
import '../../../../l10n/generated/app_localizations.dart';

class ThermoLawsScreen extends StatelessWidget {
  const ThermoLawsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sub = p.Provider.of<SubscriptionService>(context);
    final isPro = sub.isPro;

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160.0,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.bgDeep,
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
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                isPro ? '${l10n.lawsOfThermodynamics} ⭐' : l10n.lawsOfThermodynamics,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accentCarnot.withValues(alpha: 0.1),
                      AppColors.bgDeep,
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.school_outlined,
                    size: 64,
                    color: AppColors.accentCarnot.withValues(alpha: 0.2),
                  ),
                ),
              ),
            ),
          ),
          
          // Laws List
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.md),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final law = kThermoLaws[index];
                  return LawCard(
                    law: law,
                    accentColor: _getAccentColor(index),
                  );
                },
                childCount: kThermoLaws.length,
              ),
            ),
          ),
          
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.xl),
          ),
          if (!isPro)
            const SliverToBoxAdapter(
              child: GlobalBannerAdWidget(),
            ),
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.xl),
          ),
        ],
      ),
    );
  }

  Color _getAccentColor(int index) {
    switch (index) {
      case 0: return AppColors.accentLaws;    // 0th - Teal
      case 1: return AppColors.accentHeat;    // 1st - Orange/Red
      case 2: return AppColors.accentEntropy; // 2nd - Purple
      case 3: return AppColors.accentGas;     // 3rd - Green/Cyan
      default: return AppColors.accentCarnot;
    }
  }
}
