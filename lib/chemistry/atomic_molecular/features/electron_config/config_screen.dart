import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/element.dart';
import '../../core/constants/elements_data.dart';
import '../../core/theme/app_colors.dart';
import 'providers/config_provider.dart';
import 'widgets/orbital_box_grid.dart';
import '../bohr_model/widgets/element_selector.dart';

class ConfigScreen extends ConsumerWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(configProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Electron Configuration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Element Info Header
            _ElementHeader(element: state.element),

            const SizedBox(height: AppSpacing.lg),

            // Notation Card
            _NotationCard(notation: state.notation),

            const SizedBox(height: AppSpacing.xl),

            // Orbital Boxes
            Text(
              'Orbital Filling (Hund\'s Rule)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            OrbitalBoxGrid(fills: state.fills),

            const SizedBox(height: AppSpacing.xl),

            // Element Selector at the bottom
            Text(
              'Switch Element',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            ElementSelector(
              elements: kElements,
              selected: state.element,
              onSelect: (el) =>
                  ref.read(configProvider.notifier).selectElement(el),
            ),

            const SizedBox(height: AppSpacing.xl * 2),
          ],
        ),
      ),
    );
  }
}

class _ElementHeader extends StatelessWidget {
  final ChemElement element;
  const _ElementHeader({required this.element});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.orbitalP.withOpacity(0.15),
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.orbitalP.withOpacity(0.4)),
          ),
          child: Text(
            element.symbol,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.orbitalP,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(element.name, style: Theme.of(context).textTheme.titleLarge),
            Text(
              'Atomic Number: ${element.atomicNumber}',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }
}

class _NotationCard extends StatelessWidget {
  final String notation;
  const _NotationCard({required this.notation});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderDefault),
        boxShadow: [
          BoxShadow(
            color: AppColors.bgDeep.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Full Configuration',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textHint,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            notation,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.orbitalS,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
