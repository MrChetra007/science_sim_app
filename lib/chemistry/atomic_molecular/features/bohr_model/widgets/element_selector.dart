import 'package:flutter/material.dart';
import '../../../core/models/element.dart';
import '../../../core/theme/app_colors.dart';

class ElementSelector extends StatelessWidget {
  final List<ChemElement> elements;
  final ChemElement selected;
  final ValueChanged<ChemElement> onSelect;

  const ElementSelector({
    super.key,
    required this.elements,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: elements.length,
        itemBuilder: (context, index) {
          final el = elements[index];
          final isSelected = el.atomicNumber == selected.atomicNumber;

          return GestureDetector(
            onTap: () => onSelect(el),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 60,
              margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.orbitalS : AppColors.bgSurface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: isSelected ? AppColors.orbitalS : AppColors.borderDefault,
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.orbitalS.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        )
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    el.symbol,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${el.atomicNumber}',
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected ? Colors.white.withOpacity(0.8) : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
