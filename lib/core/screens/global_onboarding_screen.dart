import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/walkthrough_service.dart';

class GlobalOnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const GlobalOnboardingScreen({super.key, required this.onComplete});

  @override
  State<GlobalOnboardingScreen> createState() => _GlobalOnboardingScreenState();
}

class _GlobalOnboardingScreenState extends State<GlobalOnboardingScreen> {
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = [
    _OnboardingPage(
      title: 'Welcome to Science Lab',
      description:
          'Your virtual experiment suite for exploring physics and chemistry through interactive simulations.',
      icon: Icons.science,
      color: Colors.cyanAccent,
    ),
    _OnboardingPage(
      title: 'Physics Simulations',
      description:
          'Explore Newton\'s Laws, circuits, projectile motion, waves, and alternating current with real-time physics calculations.',
      icon: Icons.speed,
      color: Colors.cyanAccent,
      child: _buildPhysicsList(),
    ),
    _OnboardingPage(
      title: 'Chemistry Simulations',
      description:
          'Dive into pH scales, atomic structures, molecular geometry, and electrochemistry with visual simulations.',
      icon: Icons.science,
      color: Colors.greenAccent,
      child: _buildChemistryList(),
    ),
    _OnboardingPage(
      title: 'Getting Started',
      description:
          'Each lab has a guided tour on your first visit. Look for highlighted tips and interactive demonstrations.',
      icon: Icons.lightbulb_outline,
      color: Colors.amberAccent,
      tip: 'Tap any lab card to start your first simulation!',
    ),
  ];

  static Widget _buildPhysicsList() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        _buildChip('NewtonLab', Icons.architecture, Colors.cyanAccent),
        _buildChip('OhmLab', Icons.bolt, Colors.amberAccent),
        _buildChip('Projectile', Icons.rocket_launch, Colors.deepPurpleAccent),
        _buildChip('AC Lab', Icons.vibration, Colors.orangeAccent),
        _buildChip('Wave Lab', Icons.waves, Colors.lightBlueAccent),
      ],
    );
  }

  static Widget _buildChemistryList() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        _buildChip('pH Lab', Icons.science, Colors.greenAccent),
        _buildChip('Atomic & Molecular', Icons.blur_circular, Colors.purpleAccent),
        _buildChip('Electrochemistry', Icons.bolt, Colors.orangeAccent),
      ],
    );
  }

  static Widget _buildChip(String label, IconData icon, Color color) {
    return Chip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      backgroundColor: color.withOpacity(0.15),
      side: BorderSide(color: color.withOpacity(0.3)),
    );
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      setState(() => _currentPage++);
    } else {
      _complete();
    }
  }

  void _complete() {
    WalkthroughService.markGlobalOnboardingShown();
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blueGrey.shade900,
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _complete,
                  child: const Text(
                    'Skip',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: page.color.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: page.color.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          page.icon,
                          size: 50,
                          color: page.color,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        page.title,
                        style: GoogleFonts.orbitron(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: page.color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        page.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (page.child != null) ...[
                        const SizedBox(height: 24),
                        page.child!,
                      ],
                      if (page.tip != null) ...[
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.amber.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.tips_and_updates,
                                color: Colors.amber,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  page.tip!,
                                  style: const TextStyle(
                                    color: Colors.amber,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (index) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == _currentPage
                                ? page.color
                                : page.color.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: page.color.withOpacity(0.2),
                          foregroundColor: page.color,
                          side: BorderSide(color: page.color),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _currentPage == _pages.length - 1
                              ? 'Start Exploring'
                              : 'Next',
                          style: GoogleFonts.orbitron(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Widget? child;
  final String? tip;

  _OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.child,
    this.tip,
  });
}
