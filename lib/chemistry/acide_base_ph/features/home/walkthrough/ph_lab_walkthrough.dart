import 'package:flutter/material.dart';
import '../../../../../core/services/walkthrough_service.dart';
import '../../../../../core/widgets/walkthrough_tooltip.dart';

class PhLabWalkthrough extends StatefulWidget {
  final Widget child;
  final VoidCallback? onComplete;
  final GlobalKey? explorerKey;
  final GlobalKey? titrationKey;
  final GlobalKey? quizKey;
  final GlobalKey? proKey;

  const PhLabWalkthrough({
    super.key,
    required this.child,
    this.onComplete,
    this.explorerKey,
    this.titrationKey,
    this.quizKey,
    this.proKey,
  });

  @override
  State<PhLabWalkthrough> createState() => _PhLabWalkthroughState();
}

class _PhLabWalkthroughState extends State<PhLabWalkthrough> {
  int _currentStep = 0;

  final List<_WalkthroughStep> _steps = [
    _WalkthroughStep(
      title: "pH Lab",
      description:
          "Explore acids and bases through interactive chemistry simulations. Test substances, perform titrations, and learn about pH!",
      tip: "pH measures how acidic or basic a solution is on a scale from 0 to 14.",
    ),
    _WalkthroughStep(
      title: "pH Explorer",
      description:
          "Explore the full pH scale and test various substances.",
      tip: "Drag different substances into the beaker to see their pH values and color changes!",
    ),
    _WalkthroughStep(
      title: "Titration Lab (Pro)",
      description:
          "Perform acid-base titrations to determine concentration.",
      tip: "Slowly add acid to base until the indicator changes color - that's your endpoint!",
    ),
    _WalkthroughStep(
      title: "Quiz Mode",
      description:
          "Test your pH knowledge with interactive quizzes.",
      tip: "Perfect for studying and reinforcing what you've learned!",
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
        return widget.explorerKey;
      case 2:
        return widget.titrationKey;
      case 3:
        return widget.quizKey;
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
    WalkthroughService.markLabOnboardingShown(WalkthroughService.keyPhLab);
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
