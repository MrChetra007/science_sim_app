import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/nernst_state.dart';
import '../../../core/theme/app_colors.dart';

class NernstChart extends StatelessWidget {
  final NernstState state;
  final List<FlSpot> spots;

  const NernstChart({
    super.key,
    required this.state,
    required this.spots,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      padding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDefault, width: 0.5),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            getDrawingHorizontalLine: (value) => FlLine(
              color: AppColors.borderDefault.withValues(alpha: 0.2),
              strokeWidth: 1,
            ),
            getDrawingVerticalLine: (value) => FlLine(
              color: AppColors.borderDefault.withValues(alpha: 0.2),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              axisNameWidget: const Text('[Red]/[Ox] Ratio', style: TextStyle(color: AppColors.textSecondary, fontSize: 10)),
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) => Text(
                  value.toStringAsFixed(1),
                  style: const TextStyle(color: AppColors.textHint, fontSize: 10),
                ),
              ),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: const Text('E (V)', style: TextStyle(color: AppColors.textSecondary, fontSize: 10)),
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) => Text(
                  value.toStringAsFixed(2),
                  style: const TextStyle(color: AppColors.textHint, fontSize: 10),
                ),
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 5.1,
          minY: state.standardPotential - 0.2,
          maxY: state.standardPotential + 0.2,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppColors.accentPurple,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.accentPurple.withValues(alpha: 0.1),
              ),
            ),
            // Current point dot
            LineChartBarData(
              spots: [FlSpot(state.reactionQuotient, state.actualPotential)],
              showingIndicators: [0],
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                  radius: 6,
                  color: AppColors.accentPurple,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
