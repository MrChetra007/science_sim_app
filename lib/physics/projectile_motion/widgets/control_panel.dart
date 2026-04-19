import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/projectile_object.dart';
import '../physics/gravity_presets.dart';
import '../physics/projectile_objects.dart';
import '../providers/simulation_provider.dart';
import '../../../core/widgets/plan_picker.dart';
import '../../../l10n/generated/app_localizations.dart';

class ControlPanel extends ConsumerWidget {
  const ControlPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(simulationProvider);
    final notifier = ref.read(simulationProvider.notifier);

    return Container(
      color: const Color(0xFF101F2E),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── ACTION BUTTONS ──────────────────────────────────────────
            Row(
              children: [
                _ActionButton(
                  icon: Icons.rocket_launch_rounded,
                  label: l10n.pLaunch,
                  color: const Color(0xFF00BCD4),
                  onTap: (state.isIdle || state.isCompleted || state.isPaused)
                      ? notifier.launch
                      : null,
                ),
                const SizedBox(width: 8),
                _ActionButton(
                  icon: state.isRunning
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  label: state.isRunning ? l10n.pPause : l10n.pResume,
                  color: const Color(0xFFFFD740),
                  onTap: state.isRunning
                      ? notifier.pause
                      : state.isPaused
                          ? notifier.resume
                          : null,
                ),
                const SizedBox(width: 8),
                _ActionButton(
                  icon: Icons.refresh_rounded,
                  label: l10n.pReset,
                  color: const Color(0xFFFF5252),
                  onTap: notifier.reset,
                ),
                const SizedBox(width: 8),
                _ActionButton(
                  icon: state.slowMotion
                      ? Icons.speed_rounded
                      : Icons.slow_motion_video_rounded,
                  label: state.slowMotion ? l10n.pNormal : l10n.pSlowMo,
                  color: const Color(0xFF69FF47),
                  onTap: notifier.toggleSlowMotion,
                  active: state.slowMotion,
                ),
              ],
            ),
            const SizedBox(height: 12),
            const _Divider(),

            // ── SLIDERS ──────────────────────────────────────────────────
            _SliderRow(
              label: l10n.pAngle,
              value: state.angle,
              min: 0,
              max: 90,
              unit: '°',
              color: const Color(0xFF00E5FF),
              onChanged: notifier.updateAngle,
            ),
            _SliderRow(
              label: l10n.pSpeed,
              value: state.initialSpeed,
              min: 1,
              max: 50,
              unit: ' m/s',
              color: const Color(0xFFFFD740),
              onChanged: notifier.updateSpeed,
            ),
            _SliderRow(
              label: l10n.pHeight,
              value: state.initialHeight,
              min: 0,
              max: 30,
              unit: ' m',
              color: const Color(0xFF69FF47),
              onChanged: notifier.updateHeight,
            ),
            const _Divider(),

            // ── GRAVITY PRESETS ──────────────────────────────────────────
            _SectionLabel(l10n.pGravity),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                ...gravityPresets.map((p) {
                  final selected = state.selectedGravityId == p.id;
                  final isLocked = !state.isPro && p.id != 'earth';
                  return GestureDetector(
                    onTap: isLocked
                        ? () => showGlobalPlanDialog(context)
                        : () => notifier.selectGravity(p.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFF00BCD4).withValues(alpha: 0.2)
                            : const Color(0xFF1E3A4A),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected
                              ? const Color(0xFF00BCD4)
                              : const Color(0xFF1E3A4A),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${p.emoji} ${p.name}',
                            style: TextStyle(
                              color: selected
                                  ? const Color(0xFF00E5FF)
                                  : const Color(0xFF80DEEA),
                              fontSize: 12,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.normal,
                            ),
                          ),
                          if (isLocked) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.lock_rounded,
                                color: Color(0xFFFFD740), size: 10),
                          ],
                        ],
                      ),
                    ),
                  );
                }),
                // Custom gravity button
                GestureDetector(
                  onTap: !state.isPro
                      ? () => showGlobalPlanDialog(context)
                      : () => notifier.updateGravity(state.gravity),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: state.selectedGravityId == 'custom'
                          ? const Color(0xFF00BCD4).withValues(alpha: 0.2)
                          : const Color(0xFF1E3A4A),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: state.selectedGravityId == 'custom'
                            ? const Color(0xFF00BCD4)
                            : const Color(0xFF1E3A4A),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '⚙️ ${l10n.pCustom}',
                          style: TextStyle(
                            color: state.selectedGravityId == 'custom'
                                ? const Color(0xFF00E5FF)
                                : const Color(0xFF80DEEA),
                            fontSize: 12,
                            fontWeight: state.selectedGravityId == 'custom'
                                ? FontWeight.w700
                                : FontWeight.normal,
                          ),
                        ),
                        if (!state.isPro) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.lock_rounded,
                              color: Color(0xFFFFD740), size: 10),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (state.selectedGravityId == 'custom') ...[
              const SizedBox(height: 8),
              _SliderRow(
                label: l10n.pGravity,
                value: state.gravity,
                min: 0,
                max: 30,
                unit: ' m/s²',
                color: const Color(0xFF00BCD4),
                onChanged: notifier.updateGravity,
              ),
            ],
            const SizedBox(height: 10),
            const _Divider(),

            // ── PROJECTILE SELECTOR ──────────────────────────────────────
            _SectionLabel(l10n.pProjectile),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: projectileObjects.map((obj) {
                final selected = state.selectedObjectId == obj.id;
                final isLocked = !state.isPro &&
                    obj.id != 'cannonball' &&
                    obj.id != 'golfball';
                return GestureDetector(
                  onTap: isLocked
                      ? () => showGlobalPlanDialog(context)
                      : () => notifier.selectObject(obj.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF00BCD4).withValues(alpha: 0.2)
                          : const Color(0xFF1E3A4A),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selected
                            ? const Color(0xFF00BCD4)
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(obj.emoji,
                                style: const TextStyle(fontSize: 16)),
                            const SizedBox(height: 2),
                            Text(
                              obj.name,
                              style: TextStyle(
                                color: selected
                                    ? const Color(0xFF00E5FF)
                                    : const Color(0xFF80DEEA)
                                        .withValues(alpha: 0.7),
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                        if (isLocked)
                          const Positioned(
                            top: -4,
                            right: -4,
                            child: Icon(Icons.lock_rounded,
                                color: Color(0xFFFFD740), size: 10),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            // Object Specs
            const SizedBox(height: 12),
            _ObjectSpecs(object: objectById(state.selectedObjectId)),
            const SizedBox(height: 10),
            const _Divider(),

            // ── CHALLENGE MODE TOGGLE ───────────────────────────────────
            Row(
              children: [
                _SectionLabel(l10n.challengeMode),
                const Spacer(),
                Switch(
                  value: state.isChallengeMode,
                  onChanged: (_) => notifier.toggleChallengeMode(),
                  thumbColor: const WidgetStatePropertyAll(Colors.white),
                  trackColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return const Color(0xFFFF5252);
                    }
                    return const Color(0xFF1E3A4A);
                  }),
                ),
              ],
            ),
            if (state.isChallengeMode)
              Container(
                margin: const EdgeInsets.only(top: 4, bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5252).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFFF5252).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.pTargetDistance,
                          style: TextStyle(
                            color: Color(0xFF546E7A),
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${state.targetDistance?.toStringAsFixed(1) ?? "???"} m',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          l10n.pCurrentScore,
                          style: TextStyle(
                            color: Color(0xFF546E7A),
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${state.score}',
                          style: const TextStyle(
                            color: Color(0xFFFFD740),
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            const _Divider(),

            // ── AIR RESISTANCE TOGGLE ────────────────────────────────────
            Row(
              children: [
                _SectionLabel(l10n.pAirResistance),
                const Spacer(),
                Switch(
                  value: state.airResistance,
                  onChanged: (val) {
                    notifier.toggleAirResistance();
                  },
                  thumbColor: const WidgetStatePropertyAll(Colors.white),
                  trackColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return const Color(0xFF00BCD4);
                    }
                    return const Color(0xFF1E3A4A);
                  }),
                ),
              ],
            ),
            if (state.airResistance)
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4),
                child: Text(
                  '${l10n.pUsingDrag} ${objectById(state.selectedObjectId).name}',
                  style: TextStyle(
                    color: const Color(0xFF80DEEA).withValues(alpha: 0.7),
                    fontSize: 11,
                  ),
                ),
              ),
            const _Divider(),

            // ── VECTOR VISUALIZATION TOGGLES ────────────────────────────
            Row(
              children: [
                _SectionLabel(l10n.pShowForces),
                const Spacer(),
                Switch(
                  value: state.showForces,
                  onChanged: (_) => notifier.toggleForces(),
                  thumbColor: const WidgetStatePropertyAll(Colors.white),
                  trackColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return const Color(0xFF00E5FF);
                    }
                    return const Color(0xFF1E3A4A);
                  }),
                ),
              ],
            ),
            Row(
              children: [
                _SectionLabel(l10n.pShowVelocity),
                const Spacer(),
                Switch(
                  value: state.showVelocity,
                  onChanged: (val) {
                    if (!state.isPro) {
                      showGlobalPlanDialog(context);
                    } else {
                      notifier.toggleVelocity();
                    }
                  },
                  thumbIcon: !state.isPro
                      ? const WidgetStatePropertyAll(Icon(Icons.lock_rounded,
                          size: 12, color: Color(0xFFFFD740)))
                      : null,
                  thumbColor: const WidgetStatePropertyAll(Colors.white),
                  trackColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return const Color(0xFF69FF47);
                    }
                    return const Color(0xFF1E3A4A);
                  }),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const _Divider(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}


// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _SliderRow extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final String unit;
  final Color color;
  final ValueChanged<double> onChanged;

  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.unit,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 54,
            child: Text(
              label,
              style: TextStyle(
                color: color.withValues(alpha: 0.9),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: color,
                thumbColor: color,
                inactiveTrackColor: color.withValues(alpha: 0.15),
                overlayColor: color.withValues(alpha: 0.1),
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              ),
              child: Slider(
                value: value,
                min: min,
                max: max,
                onChanged: onChanged,
              ),
            ),
          ),
          SizedBox(
            width: 60,
            child: Text(
              '${value.toStringAsFixed(value >= 10 ? 0 : 1)}$unit',
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final bool active;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 48,
          decoration: BoxDecoration(
            color: active
                ? color.withValues(alpha: 0.25)
                : enabled
                    ? color.withValues(alpha: 0.12)
                    : const Color(0xFF1A2A35),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color:
                  enabled ? color.withValues(alpha: 0.5) : Colors.transparent,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  color: enabled ? color : color.withValues(alpha: 0.3),
                  size: 18),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: enabled ? color : color.withValues(alpha: 0.3),
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: Color(0xFF546E7A),
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Divider(color: Color(0xFF1E3A4A), height: 1),
    );
  }
}

class _ObjectSpecs extends StatelessWidget {
  final ProjectileObject object;
  const _ObjectSpecs({required this.object});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1520),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1E3A4A)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _SpecItem(
            label: l10n.pMass,
            value: '${object.mass.toStringAsFixed(2)} kg',
            color: const Color(0xFF80DEEA),
          ),
          Container(width: 1, height: 20, color: const Color(0xFF1E3A4A)),
          _SpecItem(
            label: l10n.pRadius,
            value: '${object.radius.toStringAsFixed(2)} m',
            color: const Color(0xFF80DEEA),
          ),
          Container(width: 1, height: 20, color: const Color(0xFF1E3A4A)),
          _SpecItem(
            label: l10n.pDragCoeff,
            value: object.dragCoefficient.toStringAsFixed(2),
            color: const Color(0xFF80DEEA),
          ),
        ],
      ),
    );
  }
}

class _SpecItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SpecItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: color.withValues(alpha: 0.5),
            fontSize: 8,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }
}
