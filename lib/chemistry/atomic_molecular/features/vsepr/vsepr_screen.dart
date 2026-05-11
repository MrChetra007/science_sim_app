import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/generated/app_localizations.dart';
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
    _inertiaController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.vseprTitle)),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: GestureDetector(
              onPanStart: (details) => _rotationController.onDragStart(details.localPosition),
              onPanUpdate: (details) => _rotationController.onDragUpdate(details.localPosition),
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
          _ShapeInfoPanel(shape: selectedShape),
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
    final l10n = AppLocalizations.of(context)!;
    final shapeInfo = _getShapeInfo(l10n, shape.id);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(shapeInfo.$1, style: Theme.of(context).textTheme.titleLarge, overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(width: 8),
              _InfoBadge(label: l10n.angle, value: shape.bondAngle),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatChip(label: l10n.stericNumber, value: '${shape.stericNumber}', color: AppColors.orbitalS),
              _StatChip(label: l10n.bonds, value: '${shape.bondingPairs}', color: AppColors.orbitalD),
              _StatChip(label: l10n.lonePairs, value: '${shape.lonePairs}', color: AppColors.orbitalP),
            ],
          ),
          const SizedBox(height: 12),
          Text(shapeInfo.$2, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: '${l10n.examples} ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textHint)),
                TextSpan(text: shape.example, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  (String, String) _getShapeInfo(AppLocalizations l10n, String id) {
    switch (id) {
      case 'linear': return (l10n.vseprNameLinear, l10n.vseprDescLinear);
      case 'trigonal_planar': return (l10n.vseprNameTrigonalPlanar, l10n.vseprDescTrigonalPlanar);
      case 'bent_120': return (l10n.vseprNameBent120, l10n.vseprDescBent120);
      case 'tetrahedral': return (l10n.vseprNameTetrahedral, l10n.vseprDescTetrahedral);
      case 'trigonal_pyramidal': return (l10n.vseprNameTrigonalPyramidal, l10n.vseprDescTrigonalPyramidal);
      case 'bent_104': return (l10n.vseprNameBent104, l10n.vseprDescBent104);
      case 'octahedral': return (l10n.vseprNameOctahedral, l10n.vseprDescOctahedral);
      default: return (id, '');
    }
  }
}

class _ShapeSelector extends StatelessWidget {
  final List<VseprShape> shapes;
  final VseprShape selected;
  final ValueChanged<VseprShape> onSelect;

  const _ShapeSelector({required this.shapes, required this.selected, required this.onSelect});

  String _getLocalizedName(AppLocalizations l10n, String id) {
    switch (id) {
      case 'linear': return l10n.vseprNameLinear;
      case 'trigonal_planar': return l10n.vseprNameTrigonalPlanar;
      case 'bent_120': return l10n.vseprNameBent120;
      case 'tetrahedral': return l10n.vseprNameTetrahedral;
      case 'trigonal_pyramidal': return l10n.vseprNameTrigonalPyramidal;
      case 'bent_104': return l10n.vseprNameBent104;
      case 'octahedral': return l10n.vseprNameOctahedral;
      default: return id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: shapes.length,
        itemBuilder: (context, index) {
          final s = shapes[index];
          final sName = _getLocalizedName(l10n, s.id);
          final isSelected = s.id == selected.id;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(sName, style: TextStyle(color: isSelected ? Colors.white : AppColors.textSecondary, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
              selected: isSelected,
              onSelected: (val) => onSelect(s),
              selectedColor: AppColors.orbitalS.withValues(alpha: 0.3),
              backgroundColor: AppColors.bgElevated,
              side: BorderSide(color: isSelected ? AppColors.orbitalS : AppColors.borderDefault),
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
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: AppColors.bgElevated, borderRadius: BorderRadius.circular(4)),
      child: Text('$label: $value', style: const TextStyle(fontSize: 11, color: AppColors.textPrimary)),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text('$label: $value', style: const TextStyle(fontSize: 11, color: AppColors.textPrimary)),
      ],
    );
  }
}