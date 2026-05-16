import 'package:flutter/material.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import '../../../../../core/services/walkthrough_service.dart';
import '../../../../../core/widgets/walkthrough_tooltip.dart';

class ElectrochemistryWalkthrough extends StatefulWidget {
  final Widget child;
  final VoidCallback? onComplete;
  final GlobalKey? galvanicKey;
  final GlobalKey? electrolysisKey;
  final GlobalKey? nernstKey;
  final GlobalKey? electroplatingKey;
  final GlobalKey? proKey;

  const ElectrochemistryWalkthrough({
    super.key,
    required this.child,
    this.onComplete,
    this.galvanicKey,
    this.electrolysisKey,
    this.nernstKey,
    this.electroplatingKey,
    this.proKey,
  });

  @override
  State<ElectrochemistryWalkthrough> createState() => _ElectrochemistryWalkthroughState();
}

class _ElectrochemistryWalkthroughState extends State<ElectrochemistryWalkthrough> {
  int _currentStep = 0;
  List<_WalkthroughStep> _steps = [];

  List<_WalkthroughStep> _buildSteps(AppLocalizations l10n) {
    return [
      _WalkthroughStep(
        title: l10n.electrochemWalkthroughTitle,
        description: l10n.electrochemWalkthroughDesc,
        tip: l10n.electrochemWalkthroughTip,
      ),
      _WalkthroughStep(
        title: l10n.galvanicCell,
        description: l10n.galvanicCellWalkthroughDesc,
        tip: l10n.galvanicCellWalkthroughTip,
      ),
      _WalkthroughStep(
        title: l10n.electrolysisWalkthroughTitle,
        description: l10n.electrolysisWalkthroughDesc,
        tip: l10n.electrolysisWalkthroughTip,
      ),
      _WalkthroughStep(
        title: l10n.nernstEquationTitle,
        description: l10n.nernstWalkthroughDesc,
        tip: l10n.nernstWalkthroughTip,
      ),
      _WalkthroughStep(
        title: l10n.electroplating,
        description: l10n.electroplatingWalkthroughDesc,
        tip: l10n.electroplatingWalkthroughTip,
      ),
      _WalkthroughStep(
        title: l10n.proFeaturesWalkthroughTitle,
        description: l10n.proFeaturesWalkthroughDesc,
        tip: l10n.proFeaturesWalkthroughTip,
        isLastStep: true,
      ),
    ];
  }

  GlobalKey? _getKeyForStep(int step) {
    switch (step) {
      case 1:
        return widget.galvanicKey;
      case 2:
        return widget.electrolysisKey;
      case 3:
        return widget.nernstKey;
      case 4:
        return widget.electroplatingKey;
      case 5:
        return widget.proKey;
      default:
        return null;
    }
  }

  Offset? _getStepPosition(int step) {
    final key = _getKeyForStep(step);
    if (key?.currentContext == null) return null;

    final box = key!.currentContext!.findRenderObject() as RenderBox;
    return box.localToGlobal(Offset.zero);
  }

  Size? _getStepSize(int step) {
    final key = _getKeyForStep(step);
    if (key?.currentContext == null) return null;

    final box = key!.currentContext!.findRenderObject() as RenderBox;
    return box.size;
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
    } else {
      _complete();
    }
  }

  void _complete() {
    WalkthroughService.markLabOnboardingShown(WalkthroughService.keyElectrochemistry);
    widget.onComplete?.call();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    _steps = _buildSteps(l10n);
    final step = _steps[_currentStep];

    return Stack(
      children: [
        widget.child,
        WalkthroughTooltip(
          title: step.title,
          description: step.description,
          tipText: step.tip,
          isLastStep: step.isLastStep,
          onNext: _nextStep,
          onSkip: _complete,
          targetPosition: _getStepPosition(_currentStep),
          targetSize: _getStepSize(_currentStep),
        ),
      ],
    );
  }
}

class _WalkthroughStep {
  final String title;
  final String description;
  final String tip;
  final bool isLastStep;

  _WalkthroughStep({
    required this.title,
    required this.description,
    required this.tip,
    this.isLastStep = false,
  });
}
