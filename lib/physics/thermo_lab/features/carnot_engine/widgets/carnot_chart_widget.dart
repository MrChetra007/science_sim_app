import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class CarnotChartWidget extends StatelessWidget {
  final double currentP;
  final double currentV;
  final double Th;
  final double Tc;

  const CarnotChartWidget({
    super.key,
    required this.currentP,
    required this.currentV,
    required this.Th,
    required this.Tc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
      decoration: BoxDecoration(
        color: AppColors.bgSurface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Stack(
        children: [
          LineChart(
            LineChartData(
              minX: 0, maxX: 3.0,
              minY: 0, maxY: 16, // increased maxY to fit high-temp Boyle points
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                // The Carnot Loop
                LineChartBarData(
                  spots: _generateLoop(),
                  isCurved: true,
                  color: AppColors.accentCarnot,
                  barWidth: 2,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppColors.accentCarnot.withValues(alpha: 0.1),
                  ),
                ),
                // Current Point Marker
                LineChartBarData(
                  spots: [FlSpot(currentV, currentP)],
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) =>
                        FlDotCirclePainter(
                      radius: 5,
                      color: AppColors.accentHeat, // Brighter color for visibility
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            left: 0, top: 0,
            child: Text('P', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
          const Positioned(
            right: 0, bottom: 0,
            child: Text('V', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generateLoop() {
    const v1 = 0.5;
    const v2 = 1.5;
    const v3 = 2.5;
    const v4 = 1.2;

    List<FlSpot> spots = [];
    
    // Stage 1: Isothermal Expansion
    for (double i = 0; i <= 1.0; i += 0.1) {
      final v = v1 + (v2 - v1) * i;
      spots.add(FlSpot(v, _P(v, Th)));
    }
    // Stage 2: Adiabatic Expansion
    for (double i = 0; i <= 1.0; i += 0.1) {
      final v = v2 + (v3 - v2) * i;
      final t = Th + (Tc - Th) * i;
      spots.add(FlSpot(v, _P(v, t)));
    }
    // Stage 3: Isothermal Compression
    for (double i = 0; i <= 1.0; i += 0.1) {
      final v = v3 - (v3 - v4) * i;
      spots.add(FlSpot(v, _P(v, Tc)));
    }
    // Stage 4: Adiabatic Compression
    for (double i = 0; i <= 1.0; i += 0.1) {
      final v = v4 - (v4 - v1) * i;
      final t = Tc + (Th - Tc) * i;
      spots.add(FlSpot(v, _P(v, t)));
    }
    
    return spots;
  }

  double _P(double V, double T) => (T / 100) / V;
}
