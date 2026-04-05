import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../../../core/services/subscription_service.dart';
import '../../../../core/services/walkthrough_service.dart';
import '../../../../core/widgets/ad_widgets.dart';
import '../../../../core/widgets/plan_picker.dart';
import 'walkthrough/ph_lab_walkthrough.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showWalkthrough = false;

  final GlobalKey _explorerKey = GlobalKey();
  final GlobalKey _titrationKey = GlobalKey();
  final GlobalKey _quizKey = GlobalKey();
  final GlobalKey _proKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _checkWalkthrough();
  }

  Future<void> _checkWalkthrough() async {
    final shown = await WalkthroughService.isLabOnboardingShown(
      WalkthroughService.keyPhLab,
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
    final sub = context.watch<SubscriptionService>();

    Widget content = Scaffold(
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
                    onPressed: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '⚗️ pH Lab',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Interactive Chemistry Simulation',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xl),
              _LabCard(
                walkthroughKey: _explorerKey,
                icon: '🧪',
                title: 'pH Explorer',
                subtitle: 'Explore the full pH scale interactively',
                color: AppColors.accentBlue,
                onTap: () => context.go('/explorer'),
              ),
              const SizedBox(height: AppSpacing.md),
              _LabCard(
                walkthroughKey: _titrationKey,
                icon: '💧',
                title: 'Titration Lab',
                subtitle: 'Mix acids and bases — watch neutralization',
                color: AppColors.accentGreen,
                onTap: sub.isPremium ? () => context.go('/titration') : null,
                isLocked: !sub.isPremium,
              ),
              const SizedBox(height: AppSpacing.md),
              _LabCard(
                walkthroughKey: _quizKey,
                icon: '📝',
                title: 'Quiz Mode',
                subtitle: 'Test your knowledge of pH',
                color: AppColors.accentPurple,
                onTap: () => context.go('/quiz'),
              ),
              const Spacer(),
              const GlobalBannerAdWidget(),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );

    if (_showWalkthrough) {
      return PhLabWalkthrough(
        onComplete: _completeWalkthrough,
        explorerKey: _explorerKey,
        titrationKey: _titrationKey,
        quizKey: _quizKey,
        proKey: _proKey,
        child: content,
      );
    }

    return content;
  }
}

class _LabCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;
  final bool isLocked;
  final GlobalKey? walkthroughKey;

  const _LabCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
    this.isLocked = false,
    this.walkthroughKey,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      key: walkthroughKey,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          if (isLocked) {
            showGlobalPlanDialog(context);
          } else {
            onTap?.call();
          }
        },
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
                child: Text(icon, style: const TextStyle(fontSize: 28)),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
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
              if (isLocked)
                const Icon(Icons.lock, size: 20, color: AppColors.textHint)
              else
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
