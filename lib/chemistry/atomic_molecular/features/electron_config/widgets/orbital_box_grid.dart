import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/config_builder.dart';

class OrbitalBoxGrid extends StatelessWidget {
  final List<OrbitalFill> fills;

  const OrbitalBoxGrid({super.key, required this.fills});

  @override
  Widget build(BuildContext context) {
    // Group by shell (1, 2, 3...)
    final grouped = <String, List<OrbitalFill>>{};
    for (final f in fills) {
      final shell = f.orbital[0];
      grouped.putIfAbsent(shell, () => []).add(f);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: grouped.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 28,
                child: Text('n=${entry.key}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                        )),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: entry.value.map((fill) => OrbitalBox(fill: fill)).toList(),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class OrbitalBox extends StatelessWidget {
  final OrbitalFill fill;
  const OrbitalBox({super.key, required this.fill});

  Color get _orbColor {
    final type = fill.orbital[fill.orbital.length - 1];
    return switch (type) {
      's' => AppColors.orbitalS,
      'p' => AppColors.orbitalP,
      'd' => AppColors.orbitalD,
      _ => AppColors.textSecondary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final type = fill.orbital[fill.orbital.length - 1];
    final boxCount = switch (type) { 'p' => 3, 'd' => 5, _ => 1 };
    final boxSize = 34.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(boxCount, (i) {
            // Hund's rule logic: fill all boxes with up arrows first
            // Current Electrons in this subshell: fill.electrons
            // Total boxes: boxCount
            // Electron Index for this box: i (up), i + boxCount (down)
            
            final bool hasUp;
            final bool hasDown;
            
            if (fill.electrons <= boxCount) {
                hasUp = i < fill.electrons;
                hasDown = false;
            } else {
                hasUp = true;
                hasDown = (i + boxCount) < fill.electrons;
            }

            return _SingleElectronBox(
              color: _orbColor,
              hasUp: hasUp,
              hasDown: hasDown,
              size: boxSize,
            );
          }),
        ),
        const SizedBox(height: 4),
        Text(
          fill.orbital,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: _orbColor,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

class _SingleElectronBox extends StatelessWidget {
  final Color color;
  final bool hasUp, hasDown;
  final double size;

  const _SingleElectronBox({
    required this.color,
    required this.hasUp,
    required this.hasDown,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.4), width: 1.0),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        color: AppColors.bgElevated,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (hasUp)
             Positioned(
              left: 6,
              child: Icon(Icons.arrow_upward_rounded, size: size * 0.6, color: color),
            ),
          if (hasDown)
            Positioned(
              right: 6,
              child: Icon(Icons.arrow_downward_rounded, size: size * 0.6, color: color.withOpacity(0.7)),
            ),
        ],
      ),
    );
  }
}
