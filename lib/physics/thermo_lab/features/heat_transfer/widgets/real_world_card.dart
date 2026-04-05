import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/real_world_examples.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/real_world_card.dart';
import '../providers/heat_provider.dart';

class HeatRealWorldCard extends ConsumerWidget {
  const HeatRealWorldCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(heatProvider);
    final example = kRealWorldExamples['heat_transfer']?[state.mode.index] ?? 
      kRealWorldExamples['heat_transfer']![0];

    return RealWorldCard(
      example: example,
      accentColor: AppColors.accentHeat,
    );
  }
}
