import 'package:flutter/material.dart';
import '../../../core/services/walkthrough_service.dart';
import '../../../core/widgets/walkthrough_tooltip.dart';

class WaveLabWalkthrough extends StatefulWidget {
  final Widget child;
  final VoidCallback? onComplete;
  final GlobalKey? enterLabKey;
  final GlobalKey? formulaKey;
  final GlobalKey? challengeKey;
  final GlobalKey? proKey;

  const WaveLabWalkthrough({
    super.key,
    required this.child,
    this.onComplete,
    this.enterLabKey,
    this.formulaKey,
    this.challengeKey,
    this.proKey,
  });

  @override
  State<WaveLabWalkthrough> createState() => _WaveLabWalkthroughState();
}

class _WaveLabWalkthroughState extends State<WaveLabWalkthrough> {
  int _currentStep = 0;

  final List<_WalkthroughStep> _steps = [
    _WalkthroughStep(
      title: "Wave Lab",
      description:
          "Explore wave mechanics through interactive simulations. See transverse waves, standing waves, interference, and the Doppler effect!",
      tip: "Waves are everywhere - sound, light, water, and more!",
    ),
    _WalkthroughStep(
      title: "Enter Lab",
      description:
          "Start the main simulation to explore different wave types.",
      tip: "You can simulate transverse, longitudinal, standing waves, and more!",
    ),
    _WalkthroughStep(
      title: "Formula Reference",
      description:
          "Access all wave equations and formulas for learning.",
      tip: "Great for studying wave mechanics and physics exams!",
    ),
    _WalkthroughStep(
      title: "Challenge Mode",
      description:
          "Test your knowledge with wave challenges.",
      tip: "Complete challenges to earn points and master wave concepts!",
    ),
    _WalkthroughStep(
      title: "Pro Features",
      description:
          "Unlock all wave types, remove ads, and get premium features.",
      tip: "Tap the version info to see subscription options!",
      isLastStep: true,
    ),
  ];

  GlobalKey? _getKeyForStep(int step) {
    switch (step) {
      case 1:
        return widget.enterLabKey;
      case 2:
        return widget.formulaKey;
      case 3:
        return widget.challengeKey;
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
    WalkthroughService.markLabOnboardingShown(WalkthroughService.keyWaveLab);
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
