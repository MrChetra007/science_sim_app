import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flame/game.dart';
import '../providers/ac_provider.dart';
import '../flame/ac_game.dart';
import 'explanation_screen.dart';
import '../../../core/widgets/plan_picker.dart';
import '../../../l10n/generated/app_localizations.dart';

class OscilloscopeScreen extends StatefulWidget {
  const OscilloscopeScreen({super.key});

  @override
  State<OscilloscopeScreen> createState() => _OscilloscopeScreenState();
}

class _OscilloscopeScreenState extends State<OscilloscopeScreen> {
  late ACGame _oscGame;

  @override
  void initState() {
    super.initState();
    _oscGame = ACGame(provider: context.read<ACProvider>());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.advancedOscilloscope),
        backgroundColor: const Color(0xFF0D1117),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ModuleExplanationScreen(
                  title: l10n.oscilloscopeGuide,
                  accentColor: Colors.cyan,
                  whatIsIt: l10n.oscilloscopeDesc,
                  howItWorks: [
                    l10n.voltsDivDesc,
                    l10n.timeDivDesc,
                    l10n.gridDesc,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: Container(
              color: Colors.black,
              child: GameWidget(game: _oscGame),
            ),
          ),
          Expanded(
            flex: 3,
            child: _buildControls(context),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<ACProvider>();
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF161B22),
      child: Column(
        children: [
          _buildDivSlider(
            label: l10n.voltsPerDiv,
            value: provider.voltsPerDiv,
            min: 10,
            max: 100,
            onChanged: provider.setVoltsPerDiv,
            unit: 'V',
          ),
          const SizedBox(height: 10),
          _buildDivSlider(
            label: l10n.timePerDiv,
            value: provider.timePerDiv,
            min: 1,
            max: 10,
            onChanged: provider.setTimePerDiv,
            unit: 'ms',
          ),
        ],
      ),
    );
  }

  Widget _buildDivSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required Function(double) onChanged,
    required String unit,
  }) {
    final isLocked = !context.read<ACProvider>().isOscilloscopeUnlocked;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: isLocked ? () => showGlobalPlanDialog(context) : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$label: ${value.toStringAsFixed(1)} $unit', 
                style: TextStyle(
                  color: isLocked ? Colors.grey : Colors.cyan, 
                  fontSize: 12, 
                  fontWeight: FontWeight.bold
                )),
              if (isLocked)
                const Icon(Icons.lock, color: Colors.amber, size: 14),
            ],
          ),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: isLocked ? null : onChanged,
          activeColor: Colors.cyan,
          inactiveColor: isLocked ? Colors.white10 : null,
        ),
      ],
    );
  }
}
