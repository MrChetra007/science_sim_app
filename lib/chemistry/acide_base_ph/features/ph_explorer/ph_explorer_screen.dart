import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/ph_colors.dart';
import '../../../../core/widgets/ad_widgets.dart';
import 'providers/ph_provider.dart';
import 'widgets/beaker_widget.dart';
import 'widgets/ph_slider_widget.dart';
import 'widgets/substance_grid.dart';
import 'widgets/indicator_panel.dart';

class PHExplorerScreen extends ConsumerWidget {
  const PHExplorerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(phProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('pH Explorer'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Section: Beaker + Stats
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(flex: 2, child: Center(child: BeakerWidget())),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current pH',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                        Text(
                          state.ph.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.displayLarge
                              ?.copyWith(
                                color: PHColors.forPH(state.ph),
                                fontSize: 48,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        const PHSliderWidget(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // Substances Section
              Text(
                'Substances',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              const SubstanceGrid(),
              const SizedBox(height: AppSpacing.xl),

              // Indicators Section
              Text(
                'Chemical Indicators',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              const IndicatorPanel(),
              const SizedBox(height: AppSpacing.xl),

              // Info Card
              if (state.selectedSubstance != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.selectedSubstance!.name,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: PHColors.forPH(
                                  state.selectedSubstance!.ph,
                                ),
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.selectedSubstance!.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: AppSpacing.lg),
              const GlobalBannerAdWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
