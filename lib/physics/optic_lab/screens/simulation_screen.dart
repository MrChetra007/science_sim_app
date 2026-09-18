import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/ad_widgets.dart';
import '../games/base_optics_game.dart';
import '../games/curved_mirror_game.dart';
import '../games/dispersion_game.dart';
import '../games/plane_mirror_game.dart';
import '../games/refraction_game.dart';
import '../games/thin_lens_game.dart';
import '../models/optics_mode.dart';
import '../theme.dart';
import '../widgets/controls.dart';

class SimulationScreen extends StatefulWidget {
  const SimulationScreen({super.key, required this.mode});

  final OpticsMode mode;

  @override
  State<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen> {
  late BaseOpticsGame _game;
  final ValueNotifier<int> _revision = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _game = _createGame(widget.mode);
    _game.onUiChanged = () => _revision.value++;
  }

  BaseOpticsGame _createGame(OpticsMode mode) => switch (mode) {
        OpticsMode.plane => PlaneMirrorGame(),
        OpticsMode.curved => CurvedMirrorGame(),
        OpticsMode.refraction => RefractionGame(),
        OpticsMode.lens => ThinLensGame(),
        OpticsMode.dispersion => DispersionGame(),
      };

  void _reset() {
    final old = _game;
    setState(() {
      _game = _createGame(widget.mode);
      _game.onUiChanged = () => _revision.value++;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => old.dispose());
  }

  @override
  void dispose() {
    _revision.dispose();
    _game.dispose();
    super.dispose();
  }

  Widget _buildControls() => ListenableBuilder(
        listenable: _revision,
        builder: (context, _) {
          return switch (widget.mode) {
            OpticsMode.plane => _PlaneControls(game: _game as PlaneMirrorGame),
            OpticsMode.curved =>
              _CurvedMirrorControls(game: _game as CurvedMirrorGame),
            OpticsMode.refraction =>
              _RefractionControls(game: _game as RefractionGame),
            OpticsMode.lens => _LensControls(game: _game as ThinLensGame),
            OpticsMode.dispersion =>
              _DispersionControls(game: _game as DispersionGame),
          };
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        titleSpacing: 20,
        title: Row(
          children: [
            Text(widget.mode.emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(widget.mode.title,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Reset',
            icon: const Icon(Icons.refresh, color: AppColors.dim),
            onPressed: _reset,
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanStart: (d) =>
                  _game.startDrag(d.localPosition.dx, d.localPosition.dy),
              onPanUpdate: (d) =>
                  _game.updateDrag(d.localPosition.dx, d.localPosition.dy),
              onPanEnd: (_) => _game.endDrag(),
              child: GameWidget(
                game: _game,
                loadingBuilder: (context) => const Center(
                  child: CircularProgressIndicator(color: AppColors.accent),
                ),
                errorBuilder: (context, error) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Simulation failed to start',
                      style: const TextStyle(color: AppColors.danger),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 12,
            top: 12,
            child: ListenableBuilder(
              listenable: _revision,
              builder: (context, _) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    _game.headline,
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'monospace',
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            right: 12,
            bottom: 16,
            child: Text(
              widget.mode.tip,
              style: const TextStyle(color: AppColors.dim, fontSize: 11),
            ),
          ),
        ],
      ),
      bottomSheet: DraggableScrollableSheet(
        initialChildSize: 0.28,
        minChildSize: 0.2,
        maxChildSize: 0.85,
        expand: false,
        builder: (context, scrollController) {
          return ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(18)),
child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.border,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ListenableBuilder(
                          listenable: _revision,
                          builder: (context, _) => ReadoutCard(
                              title: 'Live Readout', rows: _game.readoutRows),
                        ),
                        const SizedBox(height: 16),
                        _buildControls(),
                        const SizedBox(height: 16),
                        const ReadoutCard(
                          rows: [
                            ('Ray 1', 'Parallel to axis'),
                            ('Ray 2', 'Focal point / optical centre'),
                            ('Ray 3', 'Through curvature / focus'),
                            ('Virtual', 'Dashed projections'),
                          ],
                        ),
                      ],
                    ),
                    ),
                    const SafeArea(child: GlobalBannerAdWidget()),
                  ],
                ),
              ),
          );
        },
      ),
    );
  }
}

class _PlaneControls extends StatelessWidget {
  const _PlaneControls({required this.game});

  final PlaneMirrorGame game;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Controls'),
        const SizedBox(height: 12),
        SpritePicker(selected: game.sprite, onChanged: game.setSprite),
        const SizedBox(height: 16),
        ValueSlider(
          label: 'Mirror Angle (°)',
          value: game.mirrorAngle,
          min: 0,
          max: 180,
          formatter: (v) => '${v.toStringAsFixed(0)}°',
          onChanged: game.setMirrorAngle,
        ),
        ValueSlider(
          label: 'Light Source Angle (°)',
          value: game.incidentAngle,
          min: -85,
          max: 85,
          formatter: (v) => '${v.toStringAsFixed(0)}°',
          onChanged: game.setLightAngle,
        ),
      ],
    );
  }
}

class _CurvedMirrorControls extends StatelessWidget {
  const _CurvedMirrorControls({required this.game});

  final CurvedMirrorGame game;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Controls'),
        const SizedBox(height: 12),
        ToggleGroup(
          options: const ['Concave', 'Convex'],
          selected: game.type == MirrorType.concave ? 0 : 1,
          onChanged: (i) => game.setType(
              i == 0 ? MirrorType.concave : MirrorType.convex),
        ),
        const SizedBox(height: 16),
        SpritePicker(selected: game.sprite, onChanged: game.setSprite),
        const SizedBox(height: 16),
        ValueSlider(
          label: 'Focal Length (|f| px)',
          value: game.focalLength,
          min: 60,
          max: 220,
          formatter: (v) => '${v.toStringAsFixed(0)} px',
          onChanged: game.setFocalLength,
        ),
        ValueSlider(
          label: 'Object Distance (do px)',
          value: game.objectDistance,
          min: 40,
          max: 420,
          formatter: (v) => '${v.toStringAsFixed(0)} px',
          onChanged: game.setObjectDistance,
        ),
        ValueSlider(
          label: 'Object Height (ho px)',
          value: game.objectHeight,
          min: 30,
          max: 110,
          formatter: (v) => '${v.toStringAsFixed(0)} px',
          onChanged: game.setObjectHeight,
        ),
      ],
    );
  }
}

class _RefractionControls extends StatelessWidget {
  const _RefractionControls({required this.game});

  final RefractionGame game;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Controls'),
        const SizedBox(height: 12),
        ValueSlider(
          label: 'Medium 1 Index (n₁)',
          value: game.n1,
          min: 1.0,
          max: 2.6,
          divisions: 160,
          formatter: (v) => 'n₁ = ${v.toStringAsFixed(3)}',
          onChanged: game.setN1,
        ),
        ValueSlider(
          label: 'Medium 2 Index (n₂)',
          value: game.n2,
          min: 1.0,
          max: 2.6,
          divisions: 160,
          formatter: (v) => 'n₂ = ${v.toStringAsFixed(3)}',
          onChanged: game.setN2,
        ),
        ValueSlider(
          label: 'Incident Angle (θ₁)',
          value: game.theta1,
          min: 0,
          max: 89,
          formatter: (v) => '${v.toStringAsFixed(1)}°',
          onChanged: game.setTheta1,
        ),
      ],
    );
  }
}

class _LensControls extends StatelessWidget {
  const _LensControls({required this.game});

  final ThinLensGame game;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Controls'),
        const SizedBox(height: 12),
        ToggleGroup(
          options: const ['Convex', 'Concave'],
          selected: game.type == LensType.convex ? 0 : 1,
          onChanged: (i) =>
              game.setType(i == 0 ? LensType.convex : LensType.concave),
        ),
        const SizedBox(height: 16),
        SpritePicker(selected: game.sprite, onChanged: game.setSprite),
        const SizedBox(height: 16),
        ValueSlider(
          label: 'Focal Length (|f| px)',
          value: game.focalLength,
          min: 60,
          max: 220,
          formatter: (v) => '${v.toStringAsFixed(0)} px',
          onChanged: game.setFocalLength,
        ),
        ValueSlider(
          label: 'Object Distance (do px)',
          value: game.objectDistance,
          min: 40,
          max: 420,
          formatter: (v) => '${v.toStringAsFixed(0)} px',
          onChanged: game.setObjectDistance,
        ),
        ValueSlider(
          label: 'Object Height (ho px)',
          value: game.objectHeight,
          min: 30,
          max: 110,
          formatter: (v) => '${v.toStringAsFixed(0)} px',
          onChanged: game.setObjectHeight,
        ),
      ],
    );
  }
}

class _DispersionControls extends StatelessWidget {
  const _DispersionControls({required this.game});

  final DispersionGame game;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Controls'),
        const SizedBox(height: 12),
        ValueSlider(
          label: 'Prism Apex Angle (α)',
          value: game.apexAngle,
          min: 40,
          max: 75,
          formatter: (v) => '${v.toStringAsFixed(0)}°',
          onChanged: game.setApexAngle,
        ),
        ValueSlider(
          label: 'Beam Height (Y px)',
          value: game.beamYOffset,
          min: -90,
          max: 70,
          formatter: (v) => '${v.toStringAsFixed(0)} px',
          onChanged: game.setBeamYOffset,
        ),
        ValueSlider(
          label: 'Base Refractive Index (nd)',
          value: game.baseN,
          min: 1.45,
          max: 1.85,
          divisions: 40,
          formatter: (v) => v.toStringAsFixed(2),
          onChanged: game.setBaseN,
        ),
      ],
    );
  }
}