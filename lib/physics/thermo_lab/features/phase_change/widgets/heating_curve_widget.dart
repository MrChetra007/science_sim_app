import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class HeatingCurveChart extends StatelessWidget {
  final List<FlSpot> spots;
  final double meltingPoint;
  final double boilingPoint;
  final double currentTemp;

  const HeatingCurveChart({
    super.key,
    required this.spots,
    required this.meltingPoint,
    required this.boilingPoint,
    required this.currentTemp,
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
              minX: spots.isEmpty ? 0 : spots.first.x,
              maxX: spots.isEmpty ? 60 : spots.last.x + 10,
              minY: meltingPoint - 40,
              maxY: boilingPoint + 100,
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              extraLinesData: ExtraLinesData(
                horizontalLines: [
                  HorizontalLine(
                    y: meltingPoint,
                    color: AppColors.accentGas.withValues(alpha: 0.3),
                    strokeWidth: 1,
                    dashArray: [5, 5],
                    label: HorizontalLineLabel(
                      show: true,
                      alignment: Alignment.topRight,
                      labelResolver: (_) => 'Melting Pt: ${meltingPoint}°C',
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ),
                  HorizontalLine(
                    y: boilingPoint,
                    color: AppColors.accentHeat.withValues(alpha: 0.3),
                    strokeWidth: 1,
                    dashArray: [5, 5],
                    label: HorizontalLineLabel(
                      show: true,
                      alignment: Alignment.topRight,
                      labelResolver: (_) => 'Boiling Pt: ${boilingPoint}°C',
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ),
                ],
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: false,
                  color: AppColors.accentPhase,
                  barWidth: 3,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppColors.accentPhase.withValues(alpha: 0.1),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            left: 0, top: 0,
            child: Text('Temp (°C)', style: TextStyle(color: Colors.grey, fontSize: 10)),
          ),
          const Positioned(
            right: 0, bottom: 0,
            child: Text('Time', style: TextStyle(color: Colors.grey, fontSize: 10)),
          ),
        ],
      ),
    );
  }
}
