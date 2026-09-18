import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/ad_widgets.dart';
import '../../../l10n/generated/app_localizations.dart';
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
  Locale? _gameLocale;

  @override
  void initState() {
    super.initState();
    // Game creation must wait until didChangeDependencies: AppLocalizations
    // is an inherited widget and is not yet available during initState.
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Create the game on first build and recreate only if the locale
    // actually changes.
    final locale = Localizations.localeOf(context);
    if (_gameLocale != locale) {
      final old = _gameLocale == null ? null : _game;
      _gameLocale = locale;
      _game = _createGame(widget.mode);
      _game.onUiChanged = () => _revision.value++;
      if (old != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => old.dispose());
      }
    }
  }

  BaseOpticsGame _createGame(OpticsMode mode) {
    final l10n = AppLocalizations.of(context)!;
    return switch (mode) {
      OpticsMode.plane => PlaneMirrorGame(l10n: l10n),
      OpticsMode.curved => CurvedMirrorGame(l10n: l10n),
      OpticsMode.refraction => RefractionGame(l10n: l10n),
      OpticsMode.lens => ThinLensGame(l10n: l10n),
      OpticsMode.dispersion => DispersionGame(l10n: l10n),
    };
  }

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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        titleSpacing: 20,
        title: Row(
          children: [
            Text(widget.mode.emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(widget.mode.title(l10n),
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: l10n.opticResetTooltip,
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
                      l10n.opticSimulationFailed,
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
              widget.mode.tip(l10n),
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
                              title: l10n.opticLiveReadout,
                              rows: _game.readoutRows),
                        ),
                        const SizedBox(height: 16),
                        _buildControls(),
                        const SizedBox(height: 16),
                        ReadoutCard(
                          rows: [
                            (l10n.opticRayLegendRay1, l10n.opticRayLegendRay1Desc),
                            (l10n.opticRayLegendRay2, l10n.opticRayLegendRay2Desc),
                            (l10n.opticRayLegendRay3, l10n.opticRayLegendRay3Desc),
                            (l10n.opticRayLegendVirtual, l10n.opticRayLegendVirtualDesc),
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
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(l10n.opticControls),
        const SizedBox(height: 12),
        SpritePicker(selected: game.sprite, onChanged: game.setSprite),
        const SizedBox(height: 16),
        ValueSlider(
          label: l10n.opticMirrorAngle,
          value: game.mirrorAngle,
          min: 0,
          max: 180,
          formatter: (v) => '${v.toStringAsFixed(0)}°',
          onChanged: game.setMirrorAngle,
        ),
        ValueSlider(
          label: l10n.opticLightSourceAngle,
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
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(l10n.opticControls),
        const SizedBox(height: 12),
        ToggleGroup(
          options: [l10n.opticConcave, l10n.opticConvex],
          selected: game.type == MirrorType.concave ? 0 : 1,
          onChanged: (i) => game.setType(
              i == 0 ? MirrorType.concave : MirrorType.convex),
        ),
        const SizedBox(height: 16),
        SpritePicker(selected: game.sprite, onChanged: game.setSprite),
        const SizedBox(height: 16),
        ValueSlider(
          label: l10n.opticFocalLengthAbs,
          value: game.focalLength,
          min: 60,
          max: 220,
          formatter: (v) => '${v.toStringAsFixed(0)} px',
          onChanged: game.setFocalLength,
        ),
        ValueSlider(
          label: l10n.opticObjectDistance,
          value: game.objectDistance,
          min: 40,
          max: 420,
          formatter: (v) => '${v.toStringAsFixed(0)} px',
          onChanged: game.setObjectDistance,
        ),
        ValueSlider(
          label: l10n.opticObjectHeight,
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
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(l10n.opticControls),
        const SizedBox(height: 12),
        ValueSlider(
          label: l10n.opticMedium1Index,
          value: game.n1,
          min: 1.0,
          max: 2.6,
          divisions: 160,
          formatter: (v) => 'n₁ = ${v.toStringAsFixed(3)}',
          onChanged: game.setN1,
        ),
        ValueSlider(
          label: l10n.opticMedium2Index,
          value: game.n2,
          min: 1.0,
          max: 2.6,
          divisions: 160,
          formatter: (v) => 'n₂ = ${v.toStringAsFixed(3)}',
          onChanged: game.setN2,
        ),
        ValueSlider(
          label: l10n.opticIncidentAngleTheta,
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
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(l10n.opticControls),
        const SizedBox(height: 12),
        ToggleGroup(
          options: [l10n.opticConvex, l10n.opticConcave],
          selected: game.type == LensType.convex ? 0 : 1,
          onChanged: (i) =>
              game.setType(i == 0 ? LensType.convex : LensType.concave),
        ),
        const SizedBox(height: 16),
        SpritePicker(selected: game.sprite, onChanged: game.setSprite),
        const SizedBox(height: 16),
        ValueSlider(
          label: l10n.opticFocalLengthAbs,
          value: game.focalLength,
          min: 60,
          max: 220,
          formatter: (v) => '${v.toStringAsFixed(0)} px',
          onChanged: game.setFocalLength,
        ),
        ValueSlider(
          label: l10n.opticObjectDistance,
          value: game.objectDistance,
          min: 40,
          max: 420,
          formatter: (v) => '${v.toStringAsFixed(0)} px',
          onChanged: game.setObjectDistance,
        ),
        ValueSlider(
          label: l10n.opticObjectHeight,
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
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(l10n.opticControls),
        const SizedBox(height: 12),
        ValueSlider(
          label: l10n.opticPrismApexAngle,
          value: game.apexAngle,
          min: 40,
          max: 75,
          formatter: (v) => '${v.toStringAsFixed(0)}°',
          onChanged: game.setApexAngle,
        ),
        ValueSlider(
          label: l10n.opticBeamHeight,
          value: game.beamYOffset,
          min: -90,
          max: 70,
          formatter: (v) => '${v.toStringAsFixed(0)} px',
          onChanged: game.setBeamYOffset,
        ),
        ValueSlider(
          label: l10n.opticBaseIndex,
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