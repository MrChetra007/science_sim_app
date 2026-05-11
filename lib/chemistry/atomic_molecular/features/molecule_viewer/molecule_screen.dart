import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../core/models/molecule.dart';
import '../../core/constants/molecules_data.dart';
import '../../core/theme/app_colors.dart';
import 'flame/rotation_controller.dart';
import 'providers/molecule_provider.dart';
import 'widgets/molecule_painter.dart';

class MoleculeScreen extends ConsumerStatefulWidget {
  const MoleculeScreen({super.key});

  @override
  ConsumerState<MoleculeScreen> createState() => _MoleculeScreenState();
}

class _MoleculeScreenState extends ConsumerState<MoleculeScreen>
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
    )..addListener(_handleInertia);
    _inertiaController.repeat();
  }

  void _handleInertia() {
    setState(() {
      _rotationController.applyInertia();
    });
  }

  @override
  void dispose() {
    _inertiaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedMolecule = ref.watch(moleculeProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.moleculeViewerTitle)),
      body: Column(
        children: [
          // 3D Canvas
          Expanded(
            child: GestureDetector(
              onPanStart: (details) =>
                  _rotationController.onDragStart(details.localPosition),
              onPanUpdate: (details) =>
                  _rotationController.onDragUpdate(details.localPosition),
              child: Container(
                width: double.infinity,
                color: Colors.transparent, // Capture gestures
                child: CustomPaint(
                  painter: MoleculePainter(
                    molecule: selectedMolecule,
                    rotation: _rotationController.rotationMatrix,
                    scale: 60.0,
                  ),
                ),
              ),
            ),
          ),

          // Molecule Info Panel
          _MoleculeInfoPanel(molecule: selectedMolecule),

          // Molecule Selector
          _MoleculeSelector(
            molecules: kMolecules,
            selected: selectedMolecule,
            onSelect: (m) => ref.read(moleculeProvider.notifier).select(m),
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _MoleculeInfoPanel extends StatelessWidget {
  final Molecule molecule;
  const _MoleculeInfoPanel({required this.molecule});

  String _getLocalizedName(AppLocalizations l10n, String name) {
    switch (name) {
      case 'Water':
        return l10n.moleculeNameWater;
      case 'Carbon dioxide':
        return l10n.moleculeNameCarbonDioxide;
      case 'Methane':
        return l10n.moleculeNameMethane;
      case 'Ammonia':
        return l10n.moleculeNameAmmonia;
      case 'Ethane':
        return l10n.moleculeNameEthane;
      case 'Ethanol':
        return l10n.moleculeNameEthanol;
      case 'Benzene':
        return l10n.moleculeNameBenzene;
      case 'Aspirin':
        return l10n.moleculeNameAspirin;
      default:
        return name;
    }
  }

  String _getLocalizedDesc(AppLocalizations l10n, String name) {
    switch (name) {
      case 'Water':
        return l10n.moleculeDescWater;
      case 'Carbon dioxide':
        return l10n.moleculeDescCarbonDioxide;
      case 'Methane':
        return l10n.moleculeDescMethane;
      case 'Ammonia':
        return l10n.moleculeDescAmmonia;
      case 'Ethane':
        return l10n.moleculeDescEthane;
      case 'Ethanol':
        return l10n.moleculeDescEthanol;
      case 'Benzene':
        return l10n.moleculeDescBenzene;
      case 'Aspirin':
        return l10n.moleculeDescAspirin;
      default:
        return name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localName = _getLocalizedName(l10n, molecule.name);
    final localDesc = _getLocalizedDesc(l10n, molecule.name);
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(child: Text(localName, style: Theme.of(context).textTheme.titleLarge, overflow: TextOverflow.ellipsis)),
              const SizedBox(width: 8),
              _Badge(text: molecule.formula),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            molecule.shape,
            style: const TextStyle(
              color: AppColors.orbitalS,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            localDesc,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _MoleculeSelector extends StatelessWidget {
  final List<Molecule> molecules;
  final Molecule selected;
  final ValueChanged<Molecule> onSelect;

  const _MoleculeSelector({
    required this.molecules,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: molecules.length,
        itemBuilder: (context, index) {
          final m = molecules[index];
          final isSelected = m.name == selected.name;

          return GestureDetector(
            onTap: () => onSelect(m),
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.orbitalS.withValues(alpha: 0.15)
                    : AppColors.bgElevated,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: isSelected
                      ? AppColors.orbitalS
                      : AppColors.borderDefault,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      m.formula,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      m.name,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  const _Badge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.bgHighlight,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
