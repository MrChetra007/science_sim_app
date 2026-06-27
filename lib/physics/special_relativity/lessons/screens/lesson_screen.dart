import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../../sims/time_dilation/time_dilation_screen.dart';
import '../../sims/length_contraction/length_contraction_screen.dart';
import '../../sims/simultaneity/simultaneity_screen.dart';
import '../../sims/mass_energy/mass_energy_screen.dart';
import 'package:science_lab/l10n/generated/app_localizations.dart';

class LessonScreen extends StatefulWidget {
  final Lesson lesson;

  const LessonScreen({
    super.key,
    required this.lesson,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToSimulation(BuildContext context, SimMode mode) {
    Widget screen;
    switch (mode) {
      case SimMode.timeDilation:
        screen = const TimeDilationScreen();
        break;
      case SimMode.lengthContraction:
        screen = const LengthContractionScreen();
        break;
      case SimMode.simultaneity:
        screen = const SimultaneityScreen();
        break;
      case SimMode.massEnergy:
        screen = const MassEnergyScreen();
        break;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final steps = widget.lesson.steps;

    return Scaffold(
      backgroundColor: const Color(0xff0a0a1a),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.lesson.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicators
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Row(
                children: List.generate(steps.length, (index) {
                  final isActive = index == _currentPage;
                  return Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      height: 6,
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xff4fc3f7)
                            : const Color(0xff4fc3f7).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: const Color(0xff4fc3f7).withOpacity(0.5),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                )
                              ]
                            : null,
                      ),
                    ),
                  );
                }),
              ),
            ),
            
            // Swipeable lesson pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: steps.length,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  final step = steps[index];
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xff4fc3f7).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                widget.lesson.emoji,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                step.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Body text with parsed markdown/latex math formatting helper
                        Text(
                          step.body.replaceAll('\$', ''), // clean math delimiters for simple view
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 16,
                            height: 1.6,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Formula box if formula step
                        if (step.type == StepType.formula && step.formula != null) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: const Color(0xff051405),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xff00ff41).withOpacity(0.3),
                                width: 1.0,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.relFormulaReference,
                                  style: TextStyle(
                                    color: const Color(0xff00ff41).withOpacity(0.6),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  step.formula!,
                                  style: const TextStyle(
                                    color: Color(0xff00ff41),
                                    fontFamily: 'monospace',
                                    fontSize: 15,
                                    height: 1.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                        
                        // Interactive simulator link
                        if (step.type == StepType.interactive && step.linkedSim != null) ...[
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xff4fc3f7).withOpacity(0.3),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  )
                                ],
                              ),
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff4fc3f7),
                                  foregroundColor: const Color(0xff0a0a1a),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 0,
                                ),
                                icon: const Icon(Icons.rocket_launch),
                                label: Text(
                                  AppLocalizations.of(context)!.relOpen2DSimulation,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                onPressed: () => _navigateToSimulation(context, step.linkedSim!),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
            
            // Bottom control row
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back / Previous button
                  TextButton(
                    onPressed: _currentPage > 0
                        ? () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white54,
                    ),
                    child: Row(
                      children: [
                        if (_currentPage > 0) const Icon(Icons.arrow_back_ios, size: 16),
                        const SizedBox(width: 4),
                        Text(_currentPage > 0 ? AppLocalizations.of(context)!.relPrev : ""),
                      ],
                    ),
                  ),
                  
                  // Next / Finish button
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage < steps.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff15152a),
                      foregroundColor: const Color(0xff4fc3f7),
                      side: const BorderSide(
                        color: Color(0xff4fc3f7),
                        width: 1.0,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      _currentPage < steps.length - 1 ? AppLocalizations.of(context)!.relNext : AppLocalizations.of(context)!.relFinish,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
