import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class PHCurveChart extends StatelessWidget {
  final List<FlSpot> spots;

  const PHCurveChart({super.key, required this.spots});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.only(right: 16, top: 16),
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 14,
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            getDrawingHorizontalLine: (value) => FlLine(
              color: AppColors.borderDefault.withOpacity(0.5),
              strokeWidth: 0.5,
            ),
            getDrawingVerticalLine: (value) => FlLine(
              color: AppColors.borderDefault.withOpacity(0.5),
              strokeWidth: 0.5,
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (v, meta) => Text(
                  v.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textHint,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                getTitlesWidget: (v, meta) => Text(
                  '${v.toInt()}mL',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textHint,
                  ),
                ),
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFE03030),
                  Color(0xFF209090),
                  Color(0xFF2060CC),
                ],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF58A6FF).withOpacity(0.1),
                    const Color(0xFF58A6FF).withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
