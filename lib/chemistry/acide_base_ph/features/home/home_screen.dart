import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text('⚗️ pH Lab', style: Theme.of(context).textTheme.displayLarge),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Interactive Chemistry Simulation',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              _LabCard(
                icon: '🧪',
                title: 'pH Explorer',
                subtitle: 'Explore the full pH scale interactively',
                color: AppColors.accentBlue,
                onTap: () => context.go('/explorer'),
              ),
              const SizedBox(height: AppSpacing.md),
              _LabCard(
                icon: '💧',
                title: 'Titration Lab',
                subtitle: 'Mix acids and bases — watch neutralization',
                color: AppColors.accentGreen,
                onTap: () => context.go('/titration'),
              ),
              const SizedBox(height: AppSpacing.md),
              _LabCard(
                icon: '📝',
                title: 'Quiz Mode',
                subtitle: 'Test your knowledge of pH',
                color: AppColors.accentPurple,
                onTap: () => context.go('/quiz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LabCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _LabCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                alignment: Alignment.center,
                child: Text(
                  icon,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textHint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
