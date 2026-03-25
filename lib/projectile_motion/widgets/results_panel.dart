import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/simulation_provider.dart';
import '../../core/widgets/plan_picker.dart';
import 'math_solver_overlay.dart';

class ResultsPanel extends ConsumerWidget {
  const ResultsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(simulationProvider);
    final traj = state.trajectory;

    final range = traj != null ? traj.range : 0.0;
    final maxH = traj != null ? traj.maxHeight : 0.0;
    final hang = traj != null ? traj.hangTime : 0.0;

    final isActive = state.hasResults;
    final isPro = state.isPro;

    return Container(
      height: 80,
      color: const Color(0xFF0A1520),
      child: Row(
        children: [
          _ResultTile(
            label: 'Range',
            value: isActive ? '${range.toStringAsFixed(1)} m' : '— m',
            icon: Icons.swap_horiz_rounded,
            color: const Color(0xFF00E5FF),
          ),
          _ResultTile(
            label: 'Height',
            value: isActive ? '${maxH.toStringAsFixed(1)} m' : '— m',
            icon: Icons.arrow_upward_rounded,
            color: const Color(0xFF69FF47),
          ),
          _ResultTile(
            label: 'Time',
            value: isActive ? '${hang.toStringAsFixed(2)} s' : '— s',
            icon: Icons.timer_rounded,
            color: const Color(0xFFFFD740),
          ),
          if (isActive) ...[
            _Divider(),
            _MathButton(isPro: isPro),
          ],
        ],
      ),
    );
  }
}

class _MathButton extends StatelessWidget {
  final bool isPro;
  const _MathButton({required this.isPro});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: isPro
                    ? () => MathSolverOverlay.show(context)
                    : () => showGlobalPlanDialog(context),
                icon: Icon(
                  Icons.functions_rounded,
                  color: isPro
                      ? const Color(0xFF00E5FF)
                      : const Color(0xFF00E5FF).withValues(alpha: 0.3),
                ),
                tooltip: isPro ? 'View Math' : 'Pro Feature',
              ),
              if (!isPro)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Color(0xFF0A1520),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_rounded,
                      color: Color(0xFFFFD740),
                      size: 10,
                    ),
                  ),
                ),
            ],
          ),
          Text(
            'MATH',
            style: TextStyle(
              color: isPro
                  ? const Color(0xFF00E5FF)
                  : const Color(0xFF00E5FF).withValues(alpha: 0.5),
              fontSize: 8,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// Ensure ProUpgradeOverlay is imported
// Ignoring the need to import since it's likely handled if I add it to the top.

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 40, color: const Color(0xFF1E3A4A));
  }
}

class _ResultTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _ResultTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 14),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: color.withValues(alpha: 0.8),
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
