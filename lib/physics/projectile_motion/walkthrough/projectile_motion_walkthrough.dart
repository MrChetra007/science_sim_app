import 'package:flutter/material.dart';
import '../../../core/services/walkthrough_service.dart';
import '../../../core/widgets/walkthrough_tooltip.dart';

class ProjectileMotionWalkthrough extends StatefulWidget {
  final Widget child;
  final VoidCallback? onComplete;
  final GlobalKey? launchButtonKey;
  final GlobalKey? controlPanelKey;
  final GlobalKey? angleSliderKey;
  final GlobalKey? speedSliderKey;
  final GlobalKey? gravityKey;
  final GlobalKey? projectileKey;
  final GlobalKey? proKey;

  const ProjectileMotionWalkthrough({
    super.key,
    required this.child,
    this.onComplete,
    this.launchButtonKey,
    this.controlPanelKey,
    this.angleSliderKey,
    this.speedSliderKey,
    this.gravityKey,
    this.projectileKey,
    this.proKey,
  });

  @override
  State<ProjectileMotionWalkthrough> createState() => _ProjectileMotionWalkthroughState();
}

class _ProjectileMotionWalkthroughState extends State<ProjectileMotionWalkthrough> {
  int _currentStep = 0;

  final List<_WalkthroughStep> _steps = [
    _WalkthroughStep(
      title: "Physics Shot",
      description:
          "Explore projectile motion through interactive simulations. Launch projectiles and watch their trajectories!",
      tip: "This lab features 8 projectiles, 4 planets with different gravity, and air resistance simulation.",
    ),
    _WalkthroughStep(
      title: "Launch Button",
      description:
          "Tap this button to launch the projectile from the cannon.",
      tip: "The trajectory is calculated using real physics equations!",
    ),
    _WalkthroughStep(
      title: "Control Panel",
      description:
          "Adjust all simulation parameters here - angle, speed, height, gravity, and more.",
      tip: "Swipe up to see more controls!",
    ),
    _WalkthroughStep(
      title: "Angle Control",
      description:
          "Set the launch angle from 0° to 90°.",
      tip: "45° gives maximum range in ideal conditions (no air resistance)!",
    ),
    _WalkthroughStep(
      title: "Speed Control",
      description:
          "Set the initial launch speed of the projectile.",
      tip: "Higher speed = longer distance traveled!",
    ),
    _WalkthroughStep(
      title: "Gravity Presets",
      description:
          "Choose from different planets: Earth, Moon, Mars, or Jupiter.",
      tip: "Each planet has different gravity affecting the trajectory!",
    ),
    _WalkthroughStep(
      title: "Projectile Selection",
      description:
          "Choose different projectiles with varying mass, size, and drag coefficients.",
      tip: "Try launching a basketball vs a golf ball - same speed, different trajectories!",
    ),
    _WalkthroughStep(
      title: "Pro Features",
      description:
          "Unlock all planets, projectiles, velocity vectors, and remove ads with premium.",
      tip: "Tap the stars icon to see subscription options!",
      isLastStep: true,
    ),
  ];

  GlobalKey? _getKeyForStep(int step) {
    switch (step) {
      case 1:
        return widget.launchButtonKey;
      case 2:
        return widget.controlPanelKey;
      case 3:
        return widget.angleSliderKey;
      case 4:
        return widget.speedSliderKey;
      case 5:
        return widget.gravityKey;
      case 6:
        return widget.projectileKey;
      case 7:
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
    WalkthroughService.markLabOnboardingShown(WalkthroughService.keyProjectileMotion);
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
