import 'package:flutter/material.dart';
import '../../../core/services/walkthrough_service.dart';
import '../../../core/widgets/walkthrough_tooltip.dart';

class NewtonLabWalkthrough extends StatefulWidget {
  final Widget child;
  final VoidCallback? onComplete;
  final GlobalKey? law1Key;
  final GlobalKey? law2Key;
  final GlobalKey? law3Key;
  final GlobalKey? proKey;

  const NewtonLabWalkthrough({
    super.key,
    required this.child,
    this.onComplete,
    this.law1Key,
    this.law2Key,
    this.law3Key,
    this.proKey,
  });

  @override
  State<NewtonLabWalkthrough> createState() => _NewtonLabWalkthroughState();
}

class _NewtonLabWalkthroughState extends State<NewtonLabWalkthrough> {
  int _currentStep = 0;

  final List<_WalkthroughStep> _steps = [
    _WalkthroughStep(
      title: "NewtonLab",
      description:
          "Explore Newton's Three Laws of Motion through interactive physics simulations.",
      tip: "This lab covers Inertia, F=ma, and Action-Reaction principles.",
    ),
    _WalkthroughStep(
      title: "Law 1: Inertia",
      description:
          "An object remains at rest or in uniform motion unless acted upon by a net force.",
      tip: "Change the surface type (ice, wood, etc.) to see how friction affects motion!",
    ),
    _WalkthroughStep(
      title: "Law 2: F = ma",
      description:
          "The acceleration of an object depends on its mass and the force applied.",
      tip: "Try adjusting both force and mass to see how acceleration changes!",
    ),
    _WalkthroughStep(
      title: "Law 3: Action & Reaction",
      description:
          "For every action, there is an equal and opposite reaction.",
      tip: "Switch between Collisions and Rocket Propulsion demos!",
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
        return widget.law1Key;
      case 2:
        return widget.law2Key;
      case 3:
        return widget.law3Key;
      case 4:
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
    WalkthroughService.markLabOnboardingShown(WalkthroughService.keyNewtonLab);
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
