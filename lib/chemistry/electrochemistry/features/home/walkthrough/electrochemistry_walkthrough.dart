import 'package:flutter/material.dart';
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

  final List<_WalkthroughStep> _steps = [
    _WalkthroughStep(
      title: "Electrochemistry Lab",
      description:
          "Explore electrochemical cells, electrolysis, and electrochemical equations through interactive simulations.",
      tip: "Electrochemistry is everywhere - from batteries to plating to corrosion!",
    ),
    _WalkthroughStep(
      title: "Galvanic Cell",
      description:
          "Build voltaic cells and measure equilibrium potential (E°cell).",
      tip: "Galvanic cells convert chemical energy to electrical energy!",
    ),
    _WalkthroughStep(
      title: "Electrolysis (Pro)",
      description:
          "Apply external voltage to drive non-spontaneous reactions.",
      tip: "Electrolysis is used in electroplating and metal purification!",
    ),
    _WalkthroughStep(
      title: "Nernst Equation",
      description:
          "Explore how concentration and temperature affect cell potential.",
      tip: "The Nernst equation relates cell potential to concentration!",
    ),
    _WalkthroughStep(
      title: "Electroplating",
      description:
          "Calculate mass deposition using Faraday's Law.",
      tip: "Faraday's Law connects electric charge to the amount of substance deposited!",
    ),
    _WalkthroughStep(
      title: "Pro Features",
      description:
          "Unlock Electrolysis and remove ads with premium.",
      tip: "Tap the stars icon to see subscription options!",
      isLastStep: true,
    ),
  ];

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
