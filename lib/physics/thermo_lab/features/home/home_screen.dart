import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' as p;
import '../../../../core/services/subscription_service.dart';
import '../../../../core/widgets/plan_picker.dart';
import '../../../../core/widgets/ad_widgets.dart';
import '../../../../core/services/walkthrough_service.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../walkthrough/thermo_lab_walkthrough.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showWalkthrough = false;
  
  final GlobalKey _heatTransferKey = GlobalKey();
  final GlobalKey _gasLawsKey = GlobalKey();
  final GlobalKey _carnotKey = GlobalKey();
  final GlobalKey _phaseChangeKey = GlobalKey();
  final GlobalKey _entropyKey = GlobalKey();
  final GlobalKey _lawsKey = GlobalKey();
  final GlobalKey _proKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _checkWalkthrough();
  }

  Future<void> _checkWalkthrough() async {
    final shown = await WalkthroughService.isLabOnboardingShown(
      WalkthroughService.keyThermoLab,
    );
    if (mounted && !shown) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => _showWalkthrough = true);
      });
    }
  }

  void _completeWalkthrough() async {
    await WalkthroughService.markLabOnboardingShown(
      WalkthroughService.keyThermoLab,
    );
    setState(() => _showWalkthrough = false);
  }

@override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sub = p.Provider.of<SubscriptionService>(context);
    final isPro = sub.isPro;

    return ThermoLabWalkthrough(
      showWalkthrough: _showWalkthrough,
      heatTransferKey: _heatTransferKey,
      gasLawsKey: _gasLawsKey,
      carnotKey: _carnotKey,
      phaseChangeKey: _phaseChangeKey,
      entropyKey: _entropyKey,
      lawsKey: _lawsKey,
      proKey: _proKey,
      onComplete: _completeWalkthrough,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.xl),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l10n.thermoHomeTitle, style: Theme.of(context).textTheme.displayLarge),
                          if (!isPro)
                            IconButton(
                              key: _proKey,
                              icon: const Icon(Icons.star, color: Colors.amber),
                              onPressed: () => showGlobalPlanDialog(context),
                              tooltip: l10n.upgradeToPro,
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        l10n.thermoHomeSubtitle,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: AppSpacing.md,
                          mainAxisSpacing: AppSpacing.md,
                          childAspectRatio: 0.95,
                          children: [
                            _ModuleCard(
                              key: _heatTransferKey,
                              icon: '🌡️',
                              title: l10n.heatTransfer,
                              subtitle: l10n.heatTransferSubtitle,
                              color: AppColors.accentHeat,
                              route: '/heat',
                              isLocked: !isPro,
                            ),
                            _ModuleCard(
                              key: _gasLawsKey,
                              icon: '💨',
                              title: l10n.gasLaws,
                              subtitle: l10n.gasLawsSubtitle,
                              color: AppColors.accentGas,
                              route: '/gas',
                              isLocked: !isPro,
                            ),
                            _ModuleCard(
                              key: _carnotKey,
                              icon: '⚙️',
                              title: l10n.carnotEngine,
                              subtitle: l10n.carnotEngineSubtitle,
                              color: AppColors.accentCarnot,
                              route: '/carnot',
                            ),
                            _ModuleCard(
                              key: _phaseChangeKey,
                              icon: '🧊',
                              title: l10n.phaseChange,
                              subtitle: l10n.phaseChangeSubtitle,
                              color: AppColors.accentPhase,
                              route: '/phase',
                            ),
                            _ModuleCard(
                              key: _entropyKey,
                              icon: '🌀',
                              title: l10n.entropy,
                              subtitle: l10n.entropySubtitle,
                              color: AppColors.accentEntropy,
                              route: '/entropy',
                            ),
                            _ModuleCard(
                              key: _lawsKey,
                              icon: '📖',
                              title: l10n.lawsOfThermo,
                              subtitle: l10n.lawsOfThermoSubtitle,
                              color: AppColors.accentLaws,
                              route: '/laws',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!isPro) const GlobalBannerAdWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final Color color;
  final String route;
  final bool isLocked;

  const _ModuleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.route,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: isLocked
            ? () => showGlobalPlanDialog(context)
            : () => context.push(route),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    Text(
                      icon,
                      style: TextStyle(fontSize: 20, color: isLocked ? Colors.grey : null),
                    ),
                    if (isLocked)
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Icon(Icons.lock, size: 12, color: Colors.amber.shade700),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                isLocked ? '$title ⭐' : title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isLocked ? Colors.amber : color,
                      fontWeight: FontWeight.bold,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Flexible(
                child: Text(
                  isLocked ? 'PRO - Unlock for unlimited access' : subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isLocked ? Colors.amber.shade200 : AppColors.textSecondary,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
