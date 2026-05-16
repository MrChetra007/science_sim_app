import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flame/game.dart';
import 'package:provider/provider.dart' as p;
import '../../../../l10n/generated/app_localizations.dart';
import 'providers/electrolysis_provider.dart';
import 'flame/electrolysis_game.dart';
import 'widgets/gas_readout.dart';
import '../../core/constants/electrolytes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/explanation_panel.dart';
import '../../../../core/services/subscription_service.dart';
import '../../../../core/widgets/ad_widgets.dart';
import '../../../../core/widgets/plan_picker.dart';

class ElectrolysisScreen extends ConsumerStatefulWidget {
  const ElectrolysisScreen({super.key});

  @override
  ConsumerState<ElectrolysisScreen> createState() => _ElectrolysisScreenState();
}

class _ElectrolysisScreenState extends ConsumerState<ElectrolysisScreen> {
  late final ElectrolysisGame _game;

  @override
  void initState() {
    super.initState();
    final state = ref.read(electrolysisNotifierProvider);
    _game = ElectrolysisGame(state: state);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(electrolysisNotifierProvider);
    final sub = p.Provider.of<SubscriptionService>(context);
    final isPro = sub.isPro;

    _game.updateState(state);

    final l10n = AppLocalizations.of(context)!;
    _game.anodeLabel = '+ ${l10n.anode}';
    _game.cathodeLabel = '− ${l10n.cathode}';
    final freeElectrolytes = isPro ? kElectrolytes : kElectrolytes.sublist(0, 1);
    final canSelectElectrolyte = isPro || state.electrolyte == kElectrolytes.first;

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      appBar: AppBar(
        title: Text(isPro ? '${AppLocalizations.of(context)!.electrolysisLab} ⭐' : AppLocalizations.of(context)!.electrolysisLab),
        backgroundColor: AppColors.bgDeep,
        actions: [
          if (!isPro)
            IconButton(
              icon: const Icon(Icons.star, color: Colors.amber),
              onPressed: () => showGlobalPlanDialog(context),
              tooltip: AppLocalizations.of(context)!.upgradeToPro,
            ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              final l10n = AppLocalizations.of(context)!;
              ExplanationPanel.show(
                context,
                title: l10n.electrolysisLab,
                sections: [
                  ExplanationSection(
                    title: l10n.nonSpontaneousReactions,
                    content: l10n.electrolysisHowDesc,
                  ),
                  ExplanationSection(
                    title: l10n.decompositionOfNaCl,
                    content: l10n.decompositionOfNaClDesc,
                  ),
                  ExplanationSection(
                    title: l10n.thresholdVoltageTitle,
                    content: l10n.thresholdVoltageDesc,
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.borderDefault, width: 0.5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: GameWidget(game: _game),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: GasReadout(state: state),
          ),

          const SizedBox(height: AppSpacing.lg),

          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.xl),
              ),
            ),
            child: Column(
              children: [
                _VoltageControl(
                  voltage: state.appliedVoltage,
                  threshold: state.electrolyte.thresholdVoltage,
                  isPowerOn: state.isPowerOn,
                  onChanged: (v) => ref
                      .read(electrolysisNotifierProvider.notifier)
                      .setVoltage(v),
                  onToggle: (on) => ref
                      .read(electrolysisNotifierProvider.notifier)
                      .togglePower(on),
                ),
                const SizedBox(height: AppSpacing.xl),

                if (!isPro)
                  Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.md),
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: Colors.amber.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lock_outline, color: Colors.amber, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.upgradeToUnlockElectrolytes,
                            style: TextStyle(color: Colors.amber.shade200, fontSize: 12),
                          ),
                        ),
                        TextButton(
                          onPressed: () => showGlobalPlanDialog(context),
                          child: Text(l10n.upgrade, style: const TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ),

                _ElectrolytePicker(
                  selected: state.electrolyte,
                  availableElectrolytes: freeElectrolytes,
                  onSelected: (e) {
                    if (canSelectElectrolyte) {
                      ref.read(electrolysisNotifierProvider.notifier).setElectrolyte(e);
                    } else {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                        title: Text(l10n.premiumFeature),
                        content: Text(l10n.upgradeToUnlockAllElectrolytes),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: Text(l10n.maybeLater),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              showGlobalPlanDialog(context);
                            },
                            child: Text(l10n.upgrade),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
          if (!isPro) const GlobalBannerAdWidget(),
        ],
      ),
    );
  }
}

class _VoltageControl extends StatelessWidget {
  final double voltage;
  final double threshold;
  final bool isPowerOn;
  final ValueChanged<double> onChanged;
  final ValueChanged<bool> onToggle;

  const _VoltageControl({
    required this.voltage,
    required this.threshold,
    required this.isPowerOn,
    required this.onChanged,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isGlowing = isPowerOn && voltage >= threshold;
    final accentColor = isGlowing
        ? AppColors.accentElectric
        : AppColors.textHint;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.externalPowerSupply,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    letterSpacing: 1.0,
                  ),
                ),
                Text(
                  '${voltage.toStringAsFixed(1)}V',
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'JetBrains Mono',
                  ),
                ),
              ],
            ),
            Switch(
              value: isPowerOn,
              onChanged: onToggle,
              activeThumbColor: AppColors.accentElectric,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Slider(
          value: voltage,
          min: 0,
          max: 12,
          onChanged: onChanged,
          activeColor: accentColor,
        ),
        Text(
          '${AppLocalizations.of(context)!.minimumVoltageRequired}${threshold.toStringAsFixed(2)}V',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
        ),
      ],
    );
  }
}

class _ElectrolytePicker extends StatelessWidget {
  final Electrolyte selected;
  final List<Electrolyte> availableElectrolytes;
  final ValueChanged<Electrolyte> onSelected;

  const _ElectrolytePicker({
    required this.selected,
    required this.availableElectrolytes,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.electrolyteSolution,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: availableElectrolytes.map((e) {
              final isSelected = e.formula == selected.formula;
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: ChoiceChip(
                  label: Text(
                    e.formula,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (val) => onSelected(e),
                  selectedColor: AppColors.accentPurple,
                  backgroundColor: AppColors.bgElevated,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
