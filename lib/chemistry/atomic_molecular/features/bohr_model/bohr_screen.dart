import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/elements_data.dart';
import '../../core/theme/app_colors.dart';
import 'flame/bohr_game.dart';
import 'providers/bohr_provider.dart';
import 'widgets/element_info_card.dart';
import 'widgets/element_selector.dart';

class BohrScreen extends ConsumerStatefulWidget {
  const BohrScreen({super.key});

  @override
  ConsumerState<BohrScreen> createState() => _BohrScreenState();
}

class _BohrScreenState extends ConsumerState<BohrScreen> {
  late final BohrGame _game;

  @override
  void initState() {
    super.initState();
    // Read the current element from the provider at initialization
    final initialElement = ref.read(bohrProvider);
    _game = BohrGame(initialElement: initialElement);
  }

  @override
  Widget build(BuildContext context) {
    final selectedEl = ref.watch(bohrProvider);

    // Sync the game state when the provider element changes
    ref.listen(bohrProvider, (_, el) {
      _game.switchElement(el);
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Bohr Model Simulator')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Simulation Area
            Container(
              height: 380,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                border: Border.all(color: AppColors.borderDefault),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.xl),
                child: GameWidget(game: _game),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Interaction Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _game.exciteElectrons,
                      icon: const Icon(Icons.bolt_rounded, size: 20),
                      label: const Text('Excite outer electrons'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orbitalP.withOpacity(0.2),
                        foregroundColor: AppColors.orbitalP,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(
                          color: AppColors.orbitalP.withOpacity(0.4),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Element Selector Label
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                children: [
                  const Icon(
                    Icons.science_outlined,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Select Element (1-36)',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            // Horizontal Element Selector
            ElementSelector(
              elements: kElements,
              selected: selectedEl,
              onSelect: (el) => ref.read(bohrProvider.notifier).select(el),
            ),

            const SizedBox(height: AppSpacing.sm),

            // Element Details card
            ElementInfoCard(element: selectedEl),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
