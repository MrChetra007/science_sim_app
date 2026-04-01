import 'package:flutter/material.dart';
import '../widgets/formula_triangle.dart';
import 'package:provider/provider.dart';
import '../providers/circuit_provider.dart';
import '../core/theme.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LEARN OHM'S LAW"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "The Fundamental Law",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.blue),
            ),
            const SizedBox(height: 16),
            const Text(
              "Ohm's Law states that the current through a conductor between two points is directly proportional to the voltage across the two points.",
              style: TextStyle(fontSize: 16, height: 1.5, color: Colors.white70),
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
              "VOLTAGE (V)",
              "The electrical potential difference between two points. Think of it as electrical pressure.",
              AppTheme.amber,
              "Measured in Volts (V)",
            ),
            const SizedBox(height: 16),
            _buildTheoryCard(
              context,
              "CURRENT (I)",
              "The flow of electric charge. Think of it as the volume of water flowing through a pipe.",
              AppTheme.blue,
              "Measured in Amperes (A)",
            ),
            const SizedBox(height: 16),
            _buildTheoryCard(
              context,
              "RESISTANCE (R)",
              "A measure of the difficulty to pass an electric current through a conductor.",
              AppTheme.green,
              "Measured in Ohms (Ω)",
            ),
            const SizedBox(height: 40),
            Text(
              "The Formula",
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
                  _buildFormulaItem("V = I × R", "To find Voltage"),
                  const Divider(color: Colors.white10, height: 24),
                  _buildFormulaItem("I = V / R", "To find Current"),
                  const Divider(color: Colors.white10, height: 24),
                  _buildFormulaItem("R = V / I", "To find Resistance"),
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
