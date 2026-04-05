import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/gas_provider.dart';

class PVChartWidget extends StatelessWidget {
  final double currentP;
  final double currentV;
  final double currentT;
  final GasLaw law;

  const PVChartWidget({
    super.key,
    required this.currentP,
    required this.currentV,
    required this.currentT,
    required this.law,
  });

  @override
  Widget build(BuildContext context) {
    // Generate isotherm/isobar/isochore curve
    final spots = _generateCurve();

    return Container(
      height: 220,
      padding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Stack(
        children: [
          LineChart(
            LineChartData(
              minX: 0,
              maxX: 5.5,
              minY: 0,
              maxY: 11,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.white.withValues(alpha: 0.05),
                  strokeWidth: 1,
                ),
                getDrawingVerticalLine: (value) => FlLine(
                  color: Colors.white.withValues(alpha: 0.05),
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) => Text(
                      value % 5 == 0 ? value.toInt().toString() : '',
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                    reservedSize: 20,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) => Text(
                      value % 1 == 0 ? value.toInt().toString() : '',
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                    reservedSize: 20,
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              lineBarsData: [
                // Background curve
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: AppColors.accentCarnot.withValues(alpha: 0.5),
                  barWidth: 2,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppColors.accentCarnot.withValues(alpha: 0.05),
                  ),
                ),
                // Current Point Marker
                LineChartBarData(
                  spots: [FlSpot(currentV, currentP)],
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) =>
                        FlDotCirclePainter(
                      radius: 6,
                      color: AppColors.accentGas,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    ),
                  ),
                ),
              ],
              extraLinesData: ExtraLinesData(
                horizontalLines: [
                  HorizontalLine(
                    y: currentP,
                    color: AppColors.accentGas.withValues(alpha: 0.2),
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  ),
                ],
                verticalLines: [
                  VerticalLine(
                    x: currentV,
                    color: AppColors.accentGas.withValues(alpha: 0.2),
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  ),
                ],
              ),
            ),
          ),
          // Axis Labels Overlay
          const Positioned(
            left: 5,
            top: 0,
            child: Text(
              'P (atm)',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Positioned(
            right: 0,
            bottom: 0,
            child: Text(
              'V (L)',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _generateCurve() {
    switch (law) {
      case GasLaw.boyle:
        final constant = currentP * currentV;
        // Generate points with higher density near V=0.1 where the curve is steepest
        return List.generate(60, (i) {
          // Logarithmic-like distribution to get more points at low V
          final v = 0.1 + (i * i) / (60 * 60) * 4.9;
          final p = constant / v;
          return FlSpot(v, p.clamp(0.0, 11.0));
        });
      case GasLaw.charles:
        // P is constant, V varies from min to max
        return [
          const FlSpot(0.1, 0), // handle min boundary
          FlSpot(0.1, currentP),
          FlSpot(5.0, currentP),
        ];
      case GasLaw.gayLussac:
        // V is constant, P varies from 0 to 10
        return [
          FlSpot(currentV, 0.1),
          FlSpot(currentV, 10.0),
        ];
    }
  }
}
