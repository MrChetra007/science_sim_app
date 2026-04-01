import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/orbital_model.dart';
import '../../core/theme/app_colors.dart';
import 'widgets/orbital_shape_painter.dart';

class OrbitalScreen extends StatefulWidget {
  const OrbitalScreen({super.key});

  @override
  State<OrbitalScreen> createState() => _OrbitalScreenState();
}

class _OrbitalScreenState extends State<OrbitalScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  OrbitalData _selectedOrbital = kOrbitals.first;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orbital Visualizer')),
      body: Column(
        children: [
          // Orbital Display Canvas
          Expanded(
            flex: 3,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.bgSurface,
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    border: Border.all(color: AppColors.borderDefault),
                    boxShadow: [
                      BoxShadow(
                        color: _selectedOrbital.color.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: CustomPaint(
                    painter: OrbitalPainter(
                      type: _selectedOrbital.type,
                      color: _selectedOrbital.color,
                      phase: _pulseController.value * 2 * pi,
                    ),
                  ),
                );
              },
            ),
          ),

          // Info and Description
          _OrbitalInfoPanel(orbital: _selectedOrbital),

          // Orbital Type Selector
          _OrbitalSelector(
            orbitals: kOrbitals,
            selected: _selectedOrbital,
            onSelect: (o) => setState(() => _selectedOrbital = o),
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _OrbitalInfoPanel extends StatelessWidget {
  final OrbitalData orbital;
  const _OrbitalInfoPanel({required this.orbital});

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
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(child: Text(orbital.label, style: Theme.of(context).textTheme.titleLarge, overflow: TextOverflow.ellipsis)),
              const SizedBox(width: 8),
              _OrbTypeLabel(type: orbital.type),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            orbital.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrbitalSelector extends StatelessWidget {
  final List<OrbitalData> orbitals;
  final OrbitalData selected;
  final ValueChanged<OrbitalData> onSelect;

  const _OrbitalSelector({
    required this.orbitals,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: orbitals.length,
        itemBuilder: (context, index) {
          final o = orbitals[index];
          final isSelected = o.type == selected.type;

          return GestureDetector(
            onTap: () => onSelect(o),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 70,
              margin: const EdgeInsets.only(right: 12, top: 10, bottom: 10),
              decoration: BoxDecoration(
                color: isSelected ? o.color : AppColors.bgElevated,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: isSelected ? o.color : AppColors.borderDefault,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: o.color.withOpacity(0.3),
                          blurRadius: 6,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  o.label.split(' ')[0], // px, s, etc.
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OrbTypeLabel extends StatelessWidget {
  final OrbitalType type;
  const _OrbTypeLabel({required this.type});

  @override
  Widget build(BuildContext context) {
    String typeStr = type.toString().split('.').last[0].toUpperCase();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.bgHighlight,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.borderAccent),
      ),
      child: Text(
        '$typeStr Orbital',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
