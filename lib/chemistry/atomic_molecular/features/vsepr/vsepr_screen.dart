import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import '../../core/models/vsepr_shape.dart';
import '../../core/constants/vsepr_data.dart';
import '../../core/theme/app_colors.dart';
import 'flame/geometry_renderer.dart';
import 'providers/vsepr_provider.dart';
import '../molecule_viewer/flame/rotation_controller.dart';

class VseprScreen extends ConsumerStatefulWidget {
  const VseprScreen({super.key});

  @override
  ConsumerState<VseprScreen> createState() => _VseprScreenState();
}

class _VseprScreenState extends ConsumerState<VseprScreen>
    with SingleTickerProviderStateMixin {
  late final RotationController _rotationController;
  late final AnimationController _inertiaController;

  @override
  void initState() {
    super.initState();
    _rotationController = RotationController();
    _inertiaController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..addListener(() {
            setState(() {
              _rotationController.applyInertia();
            });
          });
    _inertiaController.repeat();
  }

  @override
  void dispose() {
    _inertiaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedShape = ref.watch(vseprProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('VSEPR Geometry')),
      body: Column(
        children: [
          // 3D Geometry Canvas
          Expanded(
            flex: 3,
            child: GestureDetector(
              onPanStart: (details) =>
                  _rotationController.onDragStart(details.localPosition),
              onPanUpdate: (details) =>
                  _rotationController.onDragUpdate(details.localPosition),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    colors: [AppColors.bgSurface, AppColors.bgDeep],
                    center: Alignment.center,
                    radius: 1.0,
                  ),
                ),
                child: CustomPaint(
                  painter: GeometryPainter(
                    shape: selectedShape,
                    rotation: _rotationController.rotationMatrix,
                    scale: 85.0,
                  ),
                ),
              ),
            ),
          ),

          // Shape Info Card
          _ShapeInfoPanel(shape: selectedShape),

          // Shape Selector
          _ShapeSelector(
            shapes: kVseprShapes,
            selected: selectedShape,
            onSelect: (s) => ref.read(vseprProvider.notifier).select(s),
          ),

          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _ShapeInfoPanel extends StatelessWidget {
  final VseprShape shape;
  const _ShapeInfoPanel({required this.shape});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(shape.name, style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              _InfoBadge(label: 'Angle', value: shape.bondAngle),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _StatChip(
                label: 'Steric #',
                value: '${shape.stericNumber}',
                color: AppColors.orbitalS,
              ),
              const SizedBox(width: 8),
              _StatChip(
                label: 'Bonds',
                value: '${shape.bondingPairs}',
                color: AppColors.orbitalD,
              ),
              const SizedBox(width: 8),
              _StatChip(
                label: 'Lone Pairs',
                value: '${shape.lonePairs}',
                color: AppColors.orbitalP,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            shape.description,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'Examples: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: AppColors.textHint,
                  ),
                ),
                TextSpan(
                  text: shape.example,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShapeSelector extends StatelessWidget {
  final List<VseprShape> shapes;
  final VseprShape selected;
  final ValueChanged<VseprShape> onSelect;

  const _ShapeSelector({
    required this.shapes,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: shapes.length,
        itemBuilder: (context, index) {
          final s = shapes[index];
          final isSelected = s.name == selected.name;

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(
                s.name,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              onSelected: (val) => onSelect(s),
              selectedColor: AppColors.orbitalS.withOpacity(0.3),
              backgroundColor: AppColors.bgElevated,
              side: BorderSide(
                color: isSelected
                    ? AppColors.orbitalS
                    : AppColors.borderDefault,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final String label;
  final String value;
  const _InfoBadge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.bgHighlight,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          '$label: $value',
          style: const TextStyle(fontSize: 11, color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
