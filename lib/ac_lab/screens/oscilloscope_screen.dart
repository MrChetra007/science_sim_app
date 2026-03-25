import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flame/game.dart';
import '../providers/ac_provider.dart';
import '../flame/ac_game.dart';
import 'explanation_screen.dart';
import '../../core/widgets/plan_picker.dart';

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
    // We can reuse ACGame but maybe with a flag for full-screen mode
    _oscGame = ACGame(provider: context.read<ACProvider>());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADVANCED OSCILLOSCOPE'),
        backgroundColor: const Color(0xFF0D1117),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ModuleExplanationScreen(
                  title: 'Oscilloscope Guide',
                  accentColor: Colors.cyan,
                  whatIsIt: 'An oscilloscope is a diagnostic instrument that visualizes electrical voltage signals as waveforms over time. In this lab, it helps you see the AC sine wave in real-time.',
                  howItWorks: [
                    'Volts/Div adjusts the vertical scale (amplitude). Higher values make the wave look smaller.',
                    'Time/Div adjusts the horizontal scale (time). It changes how many cycles you see on screen.',
                    'The grid helps you measure peak voltage (Vp) and the period of the wave.',
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
    final provider = context.watch<ACProvider>();
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF161B22),
      child: Column(
        children: [
          _buildDivSlider(
            label: 'Volts / Div',
            value: provider.voltsPerDiv,
            min: 10,
            max: 100,
            onChanged: provider.setVoltsPerDiv,
            unit: 'V',
          ),
          const SizedBox(height: 10),
          _buildDivSlider(
            label: 'Time / Div',
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
