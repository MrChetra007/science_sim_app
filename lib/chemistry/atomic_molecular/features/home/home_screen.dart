import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as p;
import '../../../../l10n/generated/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../../../core/services/subscription_service.dart';
import '../../../../core/services/walkthrough_service.dart';
import '../../../../core/widgets/ad_widgets.dart';
import '../../../../core/widgets/plan_picker.dart';
import '../bohr_model/bohr_screen.dart';
import '../electron_config/config_screen.dart';
import '../molecule_viewer/molecule_screen.dart';
import '../vsepr/vsepr_screen.dart';
import '../orbital_viewer/orbital_screen.dart';
import 'walkthrough/atomic_molecular_walkthrough.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showWalkthrough = false;

  final GlobalKey _bohrKey = GlobalKey();
  final GlobalKey _electronConfigKey = GlobalKey();
  final GlobalKey _moleculeKey = GlobalKey();
  final GlobalKey _vseprKey = GlobalKey();
  final GlobalKey _orbitalKey = GlobalKey();
  final GlobalKey _proKey = GlobalKey();

  List<GlobalKey> get _moduleKeys => [
    _bohrKey,
    _electronConfigKey,
    _moleculeKey,
    _vseprKey,
    _orbitalKey,
  ];

  @override
  void initState() {
    super.initState();
    _checkWalkthrough();
  }

  Future<void> _checkWalkthrough() async {
    final shown = await WalkthroughService.isLabOnboardingShown(
      WalkthroughService.keyAtomicMolecular,
    );
    if (mounted && !shown) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => _showWalkthrough = true);
      });
    }
  }

  void _completeWalkthrough() {
    setState(() => _showWalkthrough = false);
  }

  @override
  Widget build(BuildContext context) {
    final sub = p.Provider.of<SubscriptionService>(context);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final modules = <_Module>[
      _Module(
        icon: '⚛',
        title: l10n.bohrModelTitle,
        subtitle: sub.isPro ? l10n.bohrModelSubtitle : l10n.unlockForPro,
        route: '/bohr',
        color: AppColors.orbitalS,
        isLocked: !sub.isPro,
      ),
      _Module(
        icon: '⚡',
        title: l10n.electronConfigTitle,
        subtitle: l10n.fillOrbitalsStep,
        route: '/config',
        color: AppColors.orbitalP,
        isLocked: false,
      ),
      _Module(
        icon: '🔬',
        title: l10n.moleculesTitle,
        subtitle: l10n.rotateModels,
        route: '/molecule',
        color: AppColors.orbitalD,
        isLocked: false,
      ),
      _Module(
        icon: '📐',
        title: l10n.vseprTitle,
        subtitle: l10n.vseprSubtitle,
        route: '/vsepr',
        color: AppColors.catHalogen,
        isLocked: false,
      ),
      _Module(
        icon: '🌀',
        title: l10n.orbitalViewerTitle,
        subtitle: l10n.orbitalViewerSubtitle,
        route: '/orbital',
        color: AppColors.catNobleGas,
        isLocked: false,
      ),
    ];

    Widget content = Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            children: [
              _buildHeader(theme, l10n),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: _buildGrid(modules),
              ),
              const GlobalBannerAdWidget(),
              _buildFooter(l10n),
            ],
          ),
        ),
      ),
    );

    if (_showWalkthrough) {
      return AtomicMolecularWalkthrough(
        onComplete: _completeWalkthrough,
        bohrKey: _bohrKey,
        electronConfigKey: _electronConfigKey,
        moleculeKey: _moleculeKey,
        vseprKey: _vseprKey,
        orbitalKey: _orbitalKey,
        proKey: _proKey,
        child: content,
      );
    }

    return content;
  }

  Widget _buildHeader(ThemeData theme, AppLocalizations l10n) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.orbitalS.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Text('⚛', style: TextStyle(fontSize: 28)),
            ),
            const SizedBox(width: AppSpacing.md),
            Flexible(
              child: Text(
                l10n.atomicLabTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Text(
            l10n.atomicLabSubtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(List<_Module> modules) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.1,
        mainAxisExtent: 140,
      ),
      itemCount: modules.length,
      itemBuilder: (context, index) {
        return _ModuleCard(
          module: modules[index],
          walkthroughKey: _moduleKeys[index],
        );
      },
    );
  }

  Widget _buildFooter(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: GestureDetector(
        key: _proKey,
        onTap: () => showGlobalPlanDialog(context),
        child: Text(
          l10n.builtForChemistry,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textHint,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }
}

class _Module {
  final String icon;
  final String title;
  final String subtitle;
  final String route;
  final Color color;
  final bool isLocked;

  _Module({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.color,
    required this.isLocked,
  });
}

class _ModuleCard extends StatelessWidget {
  final _Module module;
  final GlobalKey? walkthroughKey;

  const _ModuleCard({required this.module, this.walkthroughKey});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return GestureDetector(
      key: walkthroughKey,
      onTap: () => _handleTap(context, l10n),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: module.isLocked 
                ? AppColors.borderDefault 
                : module.color.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: module.color.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: module.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: Text(
                          module.icon,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      const Spacer(),
                      if (module.isLocked)
                        _buildLockBadge(),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    module.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    module.subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  onTap: module.isLocked 
                      ? () => _showUpgradeDialog(context, l10n)
                      : () => _navigateToScreen(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLockBadge() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Icon(
        Icons.lock,
        size: 14,
        color: Colors.amber,
      ),
    );
  }

  void _handleTap(BuildContext context, AppLocalizations l10n) {
    if (module.isLocked) {
      _showUpgradeDialog(context, l10n);
    } else {
      _navigateToScreen(context);
    }
  }

  void _showUpgradeDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Text(
          l10n.premiumFeature,
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          l10n.upgradeToPremium,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.maybeLater),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orbitalS,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              showGlobalPlanDialog(context);
            },
            child: Text(l10n.upgrade),
          ),
        ],
      ),
    );
  }

  void _navigateToScreen(BuildContext context) {
    final screen = switch (module.route) {
      '/bohr' => const BohrScreen(),
      '/config' => const ConfigScreen(),
      '/molecule' => const MoleculeScreen(),
      '/vsepr' => const VseprScreen(),
      '/orbital' => const OrbitalScreen(),
      _ => null,
    };
    if (screen != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    }
  }
}