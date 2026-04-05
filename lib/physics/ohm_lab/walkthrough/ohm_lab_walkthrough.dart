import 'package:flutter/material.dart';
import '../../../core/services/walkthrough_service.dart';
import '../../../core/widgets/walkthrough_tooltip.dart';

class OhmLabWalkthrough extends StatefulWidget {
  final Widget child;
  final VoidCallback? onComplete;
  final GlobalKey? simulatorKey;
  final GlobalKey? voltageSliderKey;
  final GlobalKey? resistanceSliderKey;
  final GlobalKey? learnTabKey;
  final GlobalKey? proKey;

  const OhmLabWalkthrough({
    super.key,
    required this.child,
    this.onComplete,
    this.simulatorKey,
    this.voltageSliderKey,
    this.resistanceSliderKey,
    this.learnTabKey,
    this.proKey,
  });

  @override
  State<OhmLabWalkthrough> createState() => _OhmLabWalkthroughState();
}

class _OhmLabWalkthroughState extends State<OhmLabWalkthrough> {
  int _currentStep = 0;

  final List<_WalkthroughStep> _steps = [
    _WalkthroughStep(
      title: "OhmLab",
      description:
          "Explore Ohm's Law through interactive circuit simulations. See how voltage, current, and resistance relate to each other.",
      tip: "Ohm's Law: V = I × R",
    ),
    _WalkthroughStep(
      title: "Circuit Simulator",
      description:
          "Watch electrons flow through the circuit in real-time. Adjust parameters and see the circuit respond.",
      tip: "The electron particles speed up with higher voltage and slow down with more resistance!",
    ),
    _WalkthroughStep(
      title: "Voltage Control",
      description:
          "Voltage is the electrical pressure that pushes current through a circuit.",
      tip: "Range: 1V to 120V. Higher voltage = more electron flow!",
    ),
    _WalkthroughStep(
      title: "Resistance Control",
      description:
          "Resistance limits the current flow. Think of it as the 'narrowness' of a pipe.",
      tip: "Range: 1Ω to 1000Ω. Higher resistance = slower electron flow!",
    ),
    _WalkthroughStep(
      title: "Learn Tab",
      description:
          "Visit the Learn tab for detailed explanations of Ohm's Law and formulas.",
      tip: "Use the Formula Triangle to quickly calculate V, I, or R!",
    ),
    _WalkthroughStep(
      title: "Pro Features",
      description:
          "Unlock all labs and remove ads with a premium subscription.",
      tip: "Tap the stars icon to see subscription options!",
      isLastStep: true,
    ),
  ];

  GlobalKey? _getKeyForStep(int step) {
    switch (step) {
      case 1:
        return widget.simulatorKey;
      case 2:
        return widget.voltageSliderKey;
      case 3:
        return widget.resistanceSliderKey;
      case 4:
        return widget.learnTabKey;
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
    WalkthroughService.markLabOnboardingShown(WalkthroughService.keyOhmLab);
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
