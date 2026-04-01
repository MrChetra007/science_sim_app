import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final modules = [
      _Module(
        'Galvanic Cell',
        'Build voltaic cells, measure equilibrium potential E°cell',
        '/galvanic',
        Icons.bolt,
        AppColors.accentElectric,
      ),
      _Module(
        'Electrolysis',
        'Apply voltage to drive non-spontaneous reactions',
        '/electrolysis',
        Icons.electric_bolt,
        AppColors.accentGreen,
      ),
      _Module(
        'Nernst Equation',
        'Explore how concentration and temperature affects Ecell',
        '/nernst',
        Icons.show_chart,
        AppColors.accentPurple,
      ),
      _Module(
        'Electroplating',
        'Calculate mass deposition using Faraday\'s Law',
        '/electroplating',
        Icons.layers,
        AppColors.accentAmber,
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

  _Module(this.title, this.description, this.route, this.icon, this.accentColor);
}

class _ModuleCard extends StatelessWidget {
  final _Module module;

  const _ModuleCard({required this.module});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(module.route),
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
    );
  }
}
