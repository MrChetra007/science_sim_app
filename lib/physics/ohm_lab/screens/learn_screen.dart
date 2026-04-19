import 'package:flutter/material.dart';
import '../widgets/formula_triangle.dart';
import 'package:provider/provider.dart';
import '../providers/circuit_provider.dart';
import '../core/theme.dart';
import '../../../l10n/generated/app_localizations.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.learnOhmsLaw),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.fundamentalLaw,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.blue),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.fundamentalLawDesc,
              style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.white70),
            ),
            const SizedBox(height: 32),
            Center(
              child: Consumer<CircuitProvider>(
                builder: (context, provider, child) {
                  return SizedBox(
                    width: 200,
                    child: FormulaTriangle(
                      voltage: provider.voltage,
                      current: provider.current,
                      resistance: provider.resistance,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            _buildTheoryCard(
              context,
              l10n.voltageV,
              l10n.voltageDesc,
              AppTheme.amber,
              l10n.voltageUnit,
            ),
            const SizedBox(height: 16),
            _buildTheoryCard(
              context,
              l10n.currentI,
              l10n.currentDesc,
              AppTheme.blue,
              l10n.currentUnit,
            ),
            const SizedBox(height: 16),
            _buildTheoryCard(
              context,
              l10n.resistanceR,
              l10n.resistanceDesc,
              AppTheme.green,
              l10n.resistanceUnit,
            ),
            const SizedBox(height: 40),
            Text(
              l10n.theFormula,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  _buildFormulaItem("V = I × R", l10n.findVoltage),
                  const Divider(color: Colors.white10, height: 24),
                  _buildFormulaItem("I = V / R", l10n.findCurrent),
                  const Divider(color: Colors.white10, height: 24),
                  _buildFormulaItem("R = V / I", l10n.findResistance),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTheoryCard(BuildContext context, String title, String desc, Color color, String unit) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          const SizedBox(height: 8),
          Text(desc, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          Text(unit, style: TextStyle(color: color.withOpacity(0.7), fontSize: 12, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  Widget _buildFormulaItem(String formula, String desc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(formula, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'ShareTechMono')),
        Text(desc, style: const TextStyle(color: Colors.white38, fontSize: 14)),
      ],
    );
  }
}
