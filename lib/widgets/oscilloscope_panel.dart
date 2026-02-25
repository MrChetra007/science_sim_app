import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/wave_provider.dart';
import '../physics/wave_solver.dart';

class OscilloscopePanel extends ConsumerWidget {
  const OscilloscopePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(waveProvider);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A1929).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF00E5FF).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'OSCILLOSCOPE',
                style: TextStyle(
                  color: Color(0xFF00E5FF),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                'y(x=5.0, t)',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 9,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 1,
                  verticalInterval: 0.5,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.white.withValues(alpha: 0.05),
                    strokeWidth: 1,
                  ),
                  getDrawingVerticalLine: (value) => FlLine(
                    color: Colors.white.withValues(alpha: 0.05),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minX: state.currentTime - 2.0,
                maxX: state.currentTime,
                minY: -5.0,
                maxY: 5.0,
                lineBarsData: _generateLineBarsData(
                  state,
                  _generateMultiSpots(state),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<LineChartBarData> _generateLineBarsData(
    WaveState state,
    Map<String, List<FlSpot>> allSpots,
  ) {
    final List<LineChartBarData> bars = [];

    allSpots.forEach((key, spots) {
      final isResultant = key == 'resultant';
      bars.add(
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: isResultant
              ? const Color(0xFF00E5FF)
              : (key == 'y1'
                    ? Colors.cyan.withOpacity(0.3)
                    : Colors.amber.withOpacity(0.3)),
          barWidth: isResultant ? 2 : 1,
          dashArray: isResultant ? null : [5, 5],
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: isResultant,
            color: const Color(0xFF00E5FF).withOpacity(0.05),
          ),
        ),
      );
    });

    return bars;
  }

  Map<String, List<FlSpot>> _generateMultiSpots(WaveState state) {
    final Map<String, List<FlSpot>> multiSpots = {'resultant': []};
    if (state.mode == WaveMode.interference) {
      multiSpots['y1'] = [];
      multiSpots['y2'] = [];
    }

    final double x0 = 5.0;
    const int numResolution = 40;
    const double windowSize = 2.0;

    for (int i = 0; i <= numResolution; i++) {
      final double t =
          state.currentTime - (windowSize * (1 - i / numResolution));

      double y = 0;
      switch (state.mode) {
        case WaveMode.simulation:
          y = WaveSolver.calculateDisplacement(
            amplitude: state.amplitude,
            frequency: state.frequency,
            waveSpeed: state.waveSpeed / 10,
            x: x0,
            t: t,
            isDampingEnabled: state.isDampingEnabled,
          );
          break;
        case WaveMode.standing:
          y = WaveSolver.calculateStandingWaveDisplacement(
            amplitude: state.amplitude,
            frequency: state.frequency,
            length: 10,
            harmonic: state.harmonic,
            x: x0,
            t: t,
          );
          break;
        case WaveMode.interference:
          final d1 = WaveSolver.calculateDisplacement(
            amplitude: state.amplitude,
            frequency: state.frequency,
            waveSpeed: state.waveSpeed / 10,
            x: x0,
            t: t,
          );
          final d2 = WaveSolver.calculateDisplacement(
            amplitude: state.secondaryAmplitude,
            frequency: state.secondaryFrequency,
            waveSpeed: state.waveSpeed / 10,
            x: x0,
            t: t,
            phi: state.phaseDifference,
          );
          multiSpots['y1']!.add(FlSpot(t, d1));
          multiSpots['y2']!.add(FlSpot(t, d2));
          y = d1 + d2;
          break;
        case WaveMode.doppler:
          y = WaveSolver.calculateDisplacement(
            amplitude: state.amplitude,
            frequency: state.frequency,
            waveSpeed: state.waveSpeed / 10,
            x: x0,
            t: t,
          );
          break;
      }
      multiSpots['resultant']!.add(FlSpot(t, y));
    }
    return multiSpots;
  }
}
