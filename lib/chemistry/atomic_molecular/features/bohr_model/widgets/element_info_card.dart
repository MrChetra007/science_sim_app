import 'package:flutter/material.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import '../../../core/models/element.dart';
import '../../../core/theme/app_colors.dart';

class ElementInfoCard extends StatelessWidget {
  final ChemElement element;

  const ElementInfoCard({super.key, required this.element});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final funFact = _getFunFact(l10n, element.atomicNumber);
    final category = _getCategory(l10n, element.category);
    
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                element.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                '${l10n.mass}: ${element.atomicMass}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            category,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.orbitalS,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const Divider(height: 24, color: AppColors.borderDefault),
          Text(
            funFact,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: AppColors.textSecondary,
                ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _InfoBadge(label: l10n.period, value: element.period),
              _InfoBadge(label: l10n.group, value: element.group),
              _InfoBadge(label: l10n.valence, value: '${element.valenceElectrons}e⁻'),
            ],
          ),
        ],
      ),
    );
  }

  String _getFunFact(AppLocalizations l10n, int atomicNumber) {
    switch (atomicNumber) {
      case 1: return l10n.factHydrogen;
      case 2: return l10n.factHelium;
      case 3: return l10n.factLithium;
      case 4: return l10n.factBeryllium;
      case 5: return l10n.factBoron;
      case 6: return l10n.factCarbon;
      case 7: return l10n.factNitrogen;
      case 8: return l10n.factOxygen;
      case 9: return l10n.factFluorine;
      case 10: return l10n.factNeon;
      case 11: return l10n.factSodium;
      case 12: return l10n.factMagnesium;
      case 13: return l10n.factAluminum;
      case 14: return l10n.factSilicon;
      case 15: return l10n.factPhosphorus;
      case 16: return l10n.factSulfur;
      case 17: return l10n.factChlorine;
      case 18: return l10n.factArgon;
      case 19: return l10n.factPotassium;
      case 20: return l10n.factCalcium;
      case 21: return l10n.factScandium;
      case 22: return l10n.factTitanium;
      case 23: return l10n.factVanadium;
      case 24: return l10n.factChromium;
      case 25: return l10n.factManganese;
      case 26: return l10n.factIron;
      case 27: return l10n.factCobalt;
      case 28: return l10n.factNickel;
      case 29: return l10n.factCopper;
      case 30: return l10n.factZinc;
      case 31: return l10n.factGallium;
      case 32: return l10n.factGermanium;
      case 33: return l10n.factArsenic;
      case 34: return l10n.factSelenium;
      case 35: return l10n.factBromine;
      case 36: return l10n.factKrypton;
      default: return '';
    }
  }

  String _getCategory(AppLocalizations l10n, String category) {
    switch (category.toLowerCase()) {
      case 'nonmetal': return l10n.elementCategoryNonmetal;
      case 'noble gas': return l10n.elementCategoryNobleGas;
      case 'alkali metal': return l10n.elementCategoryAlkaliMetal;
      case 'alkaline earth metal': return l10n.elementCategoryAlkalineEarth;
      case 'metalloid': return l10n.elementCategoryMetalloid;
      case 'halogen': return l10n.elementCategoryHalogen;
      case 'transition metal': return l10n.elementCategoryTransitionMetal;
      case 'post-transition metal': return l10n.elementCategoryPostTransition;
      default: return category;
    }
  }
}

class _InfoBadge extends StatelessWidget {
  final String label;
  final String value;

  const _InfoBadge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 11, color: AppColors.textPrimary),
      ),
    );
  }
}
