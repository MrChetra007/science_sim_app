import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as p;
import '../../../../l10n/generated/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../../../core/services/subscription_service.dart';
import '../../../../core/services/walkthrough_service.dart';
import '../../../../core/widgets/ad_widgets.dart';
import '../../../../core/widgets/plan_picker.dart';
import '../galvanic_cell/galvanic_screen.dart';
import '../electrolysis/electrolysis_screen.dart';
import '../nernst/nernst_screen.dart';
import '../electroplating/electroplating_screen.dart';
import 'walkthrough/electrochemistry_walkthrough.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showWalkthrough = false;

  final GlobalKey _galvanicKey = GlobalKey();
  final GlobalKey _electrolysisKey = GlobalKey();
  final GlobalKey _nernstKey = GlobalKey();
  final GlobalKey _electroplatingKey = GlobalKey();
  final GlobalKey _proKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _checkWalkthrough();
  }

  Future<void> _checkWalkthrough() async {
    final shown = await WalkthroughService.isLabOnboardingShown(
      WalkthroughService.keyElectrochemistry,
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
    final isPro = sub.isPro;

    final l10n = AppLocalizations.of(context)!;
    final modules = [
      _Module(
        l10n.galvanicCell,
        l10n.galvanicCellDesc,
        '/galvanic',
        Icons.bolt,
        AppColors.accentElectric,
        isLocked: false,
      ),
      _Module(
        l10n.electrolysis,
        isPro ? l10n.electrolysisDesc : l10n.proUnlockMessage,
        '/electrolysis',
        Icons.electric_bolt,
        AppColors.accentGreen,
        isLocked: !isPro,
      ),
      _Module(
        l10n.nernstEquationTitle,
        l10n.nernstEquationDesc,
        '/nernst',
        Icons.show_chart,
        AppColors.accentPurple,
        isLocked: false,
      ),
      _Module(
        l10n.electroplating,
        l10n.electroplatingDesc,
        '/electroplating',
        Icons.layers,
        AppColors.accentAmber,
        isLocked: false,
      ),
    ];

    final keys = [_galvanicKey, _electrolysisKey, _nernstKey, _electroplatingKey];

    Widget content = Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      l10n.electrochemHomeTitle,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    key: _proKey,
                    icon: Icon(
                      Icons.stars,
                      color: sub.isPro ? Colors.amber : Colors.white24,
                    ),
                    onPressed: () => showGlobalPlanDialog(context),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.electrochemHomeSubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: modules.length,
                  itemBuilder: (ctx, i) => _ModuleCard(module: modules[i], walkthroughKey: keys[i]),
                ),
              ),
              const GlobalBannerAdWidget(),
            ],
          ),
        ),
      ),
    );

    if (_showWalkthrough) {
      return ElectrochemistryWalkthrough(
        onComplete: _completeWalkthrough,
        galvanicKey: _galvanicKey,
        electrolysisKey: _electrolysisKey,
        nernstKey: _nernstKey,
        electroplatingKey: _electroplatingKey,
        proKey: _proKey,
        child: content,
      );
    }

    return content;
  }
}

class _Module {
  final String title;
  final String description;
  final String route;
  final IconData icon;
  final Color accentColor;
  final bool isLocked;

  _Module(this.title, this.description, this.route, this.icon, this.accentColor, {required this.isLocked});
}

class _ModuleCard extends StatelessWidget {
  final _Module module;
  final GlobalKey? walkthroughKey;

  const _ModuleCard({required this.module, this.walkthroughKey});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: walkthroughKey,
      onTap: () {
        if (module.isLocked) {
          showDialog(
            context: context,
            builder: (ctx) {
              final m10n = AppLocalizations.of(context)!;
              return AlertDialog(
                title: Text(m10n.premiumFeature),
                content: Text(m10n.upgradeToUnlockElectrolysis),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(m10n.maybeLater),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      showGlobalPlanDialog(context);
                    },
                    child: Text(m10n.upgrade),
                  ),
                ],
              );
            },
          );
          return;
        }

        final screen = switch (module.route) {
          '/galvanic' => const GalvanicScreen(),
          '/electrolysis' => const ElectrolysisScreen(),
          '/nernst' => const NernstScreen(),
          '/electroplating' => const ElectroplatingScreen(),
          _ => null,
        };
        if (screen != null) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
        }
      },
      child: Stack(
        children: [
          Card(
            elevation: 0,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              splashColor: module.accentColor.withValues(alpha: 0.1),
              highlightColor: module.accentColor.withValues(alpha: 0.05),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: module.accentColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Icon(
                        module.icon,
                        color: module.accentColor,
                        size: 28,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      module.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      module.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (module.isLocked)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.lock, size: 14, color: Colors.black),
              ),
            ),
        ],
      ),
    );
  }
}
