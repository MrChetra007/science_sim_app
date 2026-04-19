import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/simulation_provider.dart';
import '../../../l10n/generated/app_localizations.dart';

class SimulationGraphs extends ConsumerStatefulWidget {
  const SimulationGraphs({super.key});

  @override
  ConsumerState<SimulationGraphs> createState() => _SimulationGraphsState();
}

class _SimulationGraphsState extends ConsumerState<SimulationGraphs>
    with SingleTickerProviderStateMixin {
  int _selectedTab = 0;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnimation =
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(simulationProvider);
    final traj = state.trajectory;

    if (traj == null || traj.points.isEmpty) {
      return _EmptyState(pulseAnimation: _pulseAnimation, l10n: l10n);
    }

    final isAltitude = _selectedTab == 0;

    return Column(
      children: [
        const SizedBox(height: 12),

        // ── Custom glass tab switcher ─────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _GlassPanel(
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                _TabButton(
                  label: l10n.pAltitudeVsDist,
                  icon: Icons.show_chart_rounded,
                  color: const Color(0xFF00E5FF),
                  isSelected: _selectedTab == 0,
                  onTap: () => setState(() => _selectedTab = 0),
                ),
                _TabButton(
                  label: l10n.pVelocityVsTime,
                  icon: Icons.speed_rounded,
                  color: const Color(0xFFFFD740),
                  isSelected: _selectedTab == 1,
                  onTap: () => setState(() => _selectedTab = 1),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // ── Chart area ────────────────────────────────────────────────
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _GlassPanel(
              padding: const EdgeInsets.all(0),
              child: Column(
                children: [
                  // HUD tag header
                  _ChartHeader(
                    label: isAltitude
                        ? l10n.pAltitudeVsDistance
                        : l10n.pVelocityVsTime,
                    color: isAltitude
                        ? const Color(0xFF00E5FF)
                        : const Color(0xFFFFD740),
                    xLabel: isAltitude ? l10n.pDistanceM : l10n.pTimeS,
                    yLabel: isAltitude ? l10n.pHeightM : l10n.pSpeedMs,
                  ),

                  // Chart
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 16, 20, 12),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: isAltitude
                            ? _AltitudeGraph(
                                key: const ValueKey('alt'),
                                points: traj.points,
                              )
                            : _VelocityGraph(
                                key: const ValueKey('vel'),
                                points: traj.points,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Charts
// ─────────────────────────────────────────────────────────────────────────────

class _AltitudeGraph extends StatelessWidget {
  final List<dynamic> points;
  const _AltitudeGraph({required this.points, super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        backgroundColor: Colors.transparent,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (_) => FlLine(
            color: const Color(0xFF00E5FF).withValues(alpha: 0.08),
            strokeWidth: 1,
          ),
          getDrawingVerticalLine: (_) => FlLine(
            color: const Color(0xFF00E5FF).withValues(alpha: 0.08),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (val, _) => Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  val.toInt().toString(),
                  style: TextStyle(
                    fontFamily: 'monospace',
                    color: const Color(0xFF00E5FF).withValues(alpha: 0.5),
                    fontSize: 9,
                  ),
                ),
              ),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 38,
              getTitlesWidget: (val, _) => Text(
                val.toInt().toString(),
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: const Color(0xFF00E5FF).withValues(alpha: 0.5),
                  fontSize: 9,
                ),
              ),
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: const Color(0xFF00E5FF).withValues(alpha: 0.12),
            width: 1,
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: points.map((p) => FlSpot(p.x, p.y)).toList(),
            isCurved: true,
            gradient: const LinearGradient(
              colors: [Color(0xFF64FFDA), Color(0xFF00E5FF)],
            ),
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF00E5FF).withValues(alpha: 0.18),
                  const Color(0xFF00E5FF).withValues(alpha: 0.01),
                ],
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => const Color(0xFF040D17),
            tooltipBorder: BorderSide(
              color: const Color(0xFF00E5FF).withValues(alpha: 0.3),
            ),
            getTooltipItems: (spots) => spots
                .map((s) => LineTooltipItem(
                      'x: ${s.x.toStringAsFixed(1)} m\ny: ${s.y.toStringAsFixed(1)} m',
                      const TextStyle(
                        fontFamily: 'monospace',
                        color: Color(0xFF00E5FF),
                        fontSize: 11,
                        height: 1.6,
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _VelocityGraph extends StatelessWidget {
  final List<dynamic> points;
  const _VelocityGraph({required this.points, super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        backgroundColor: Colors.transparent,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (_) => FlLine(
            color: const Color(0xFFFFD740).withValues(alpha: 0.07),
            strokeWidth: 1,
          ),
          getDrawingVerticalLine: (_) => FlLine(
            color: const Color(0xFFFFD740).withValues(alpha: 0.07),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (val, _) => Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  val.toStringAsFixed(1),
                  style: TextStyle(
                    fontFamily: 'monospace',
                    color: const Color(0xFFFFD740).withValues(alpha: 0.5),
                    fontSize: 9,
                  ),
                ),
              ),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 38,
              getTitlesWidget: (val, _) => Text(
                val.toInt().toString(),
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: const Color(0xFFFFD740).withValues(alpha: 0.5),
                  fontSize: 9,
                ),
              ),
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: const Color(0xFFFFD740).withValues(alpha: 0.12),
            width: 1,
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: points.map((p) => FlSpot(p.t, p.speed)).toList(),
            isCurved: true,
            gradient: const LinearGradient(
              colors: [Color(0xFFFFD740), Color(0xFFFF8F00)],
            ),
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFFFD740).withValues(alpha: 0.18),
                  const Color(0xFFFFD740).withValues(alpha: 0.01),
                ],
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => const Color(0xFF040D17),
            tooltipBorder: BorderSide(
              color: const Color(0xFFFFD740).withValues(alpha: 0.3),
            ),
            getTooltipItems: (spots) => spots
                .map((s) => LineTooltipItem(
                      't: ${s.x.toStringAsFixed(2)} s\nv: ${s.y.toStringAsFixed(1)} m/s',
                      const TextStyle(
                        fontFamily: 'monospace',
                        color: Color(0xFFFFD740),
                        fontSize: 11,
                        height: 1.6,
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Supporting widgets
// ─────────────────────────────────────────────────────────────────────────────

class _ChartHeader extends StatelessWidget {
  final String label;
  final Color color;
  final String xLabel;
  final String yLabel;

  const _ChartHeader({
    required this.label,
    required this.color,
    required this.xLabel,
    required this.yLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
        border: Border(
          bottom: BorderSide(
            color: color.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // ✅ Wrap badge in Flexible so it can shrink
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '[ $label ]',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  color: color,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
                overflow: TextOverflow.ellipsis, // ✅ clips instead of overflows
              ),
            ),
          ),
          const SizedBox(width: 8),
          // ✅ Legends in a Row that can also shrink
          _AxisLegend(label: 'X: $xLabel', color: color),
          const SizedBox(width: 8),
          _AxisLegend(label: 'Y: $yLabel', color: color),
        ],
      ),
    );
  }
}

class _AxisLegend extends StatelessWidget {
  final String label;
  final Color color;
  const _AxisLegend({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 8,
        color: color.withValues(alpha: 0.45),
        letterSpacing: 0.8,
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          height: 38,
          decoration: BoxDecoration(
            color:
                isSelected ? color.withValues(alpha: 0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? color.withValues(alpha: 0.4)
                  : Colors.transparent,
              width: 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.15),
                      blurRadius: 10,
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 13,
                color: isSelected ? color : const Color(0xFF546E7A),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: isSelected ? color : const Color(0xFF546E7A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final Animation<double> pulseAnimation;
  final AppLocalizations l10n;
  const _EmptyState({required this.pulseAnimation, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _GlassPanel(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: pulseAnimation,
              builder: (_, _) => Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF00E5FF)
                      .withValues(alpha: 0.05 + pulseAnimation.value * 0.05),
                  border: Border.all(
                    color: const Color(0xFF00E5FF)
                        .withValues(alpha: 0.2 + pulseAnimation.value * 0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00E5FF)
                          .withValues(alpha: 0.1 * pulseAnimation.value),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.ssid_chart_rounded,
                  color: const Color(0xFF00E5FF)
                      .withValues(alpha: 0.4 + pulseAnimation.value * 0.3),
                  size: 24,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              l10n.pLaunchSimulation,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: Color(0xFF00E5FF),
                letterSpacing: 3,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.pLaunchSimulation,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: const Color(0xFF80DEEA).withValues(alpha: 0.4),
                height: 1.6,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const _GlassPanel({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFF00E5FF).withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF00E5FF).withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00E5FF).withValues(alpha: 0.04),
            blurRadius: 20,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: child,
      ),
    );
  }
}
