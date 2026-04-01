import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as p;
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../../../core/services/subscription_service.dart';
import '../../../../core/widgets/ad_widgets.dart';
import '../../../../core/widgets/plan_picker.dart';
import '../galvanic_cell/galvanic_screen.dart';
import '../electrolysis/electrolysis_screen.dart';
import '../nernst/nernst_screen.dart';
import '../electroplating/electroplating_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sub = p.Provider.of<SubscriptionService>(context);
    final isPro = sub.isPro;

    final modules = [
      _Module(
        'Galvanic Cell',
        'Build voltaic cells, measure equilibrium potential E°cell',
        '/galvanic',
        Icons.bolt,
        AppColors.accentElectric,
        isLocked: false,
      ),
      _Module(
        'Electrolysis',
        isPro ? 'Apply voltage to drive non-spontaneous reactions' : 'PRO - Unlock for unlimited access',
        '/electrolysis',
        Icons.electric_bolt,
        AppColors.accentGreen,
        isLocked: !isPro,
      ),
      _Module(
        'Nernst Equation',
        'Explore how concentration and temperature affects Ecell',
        '/nernst',
        Icons.show_chart,
        AppColors.accentPurple,
        isLocked: false,
      ),
      _Module(
        'Electroplating',
        'Calculate mass deposition using Faraday\'s Law',
        '/electroplating',
        Icons.layers,
        AppColors.accentAmber,
        isLocked: false,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Electrochemistry',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Interactive Lab Simulations',
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
                  itemBuilder: (ctx, i) => _ModuleCard(module: modules[i]),
                ),
              ),
              const GlobalBannerAdWidget(),
            ],
          ),
        ),
      ),
    );
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

  const _ModuleCard({required this.module});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (module.isLocked) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Premium Feature'),
              content: const Text('Upgrade to Premium to unlock Electrolysis!'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Maybe Later'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    showGlobalPlanDialog(context);
                  },
                  child: const Text('Upgrade'),
                ),
              ],
            ),
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
