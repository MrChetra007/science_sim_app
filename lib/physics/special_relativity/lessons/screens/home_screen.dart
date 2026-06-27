import 'dart:math';
import 'package:flutter/material.dart';
import 'lesson_screen.dart';
import 'quiz_screen.dart';
import '../lesson_data.dart';
import '../models/lesson.dart';
import '../../sims/time_dilation/time_dilation_screen.dart';
import '../../sims/length_contraction/length_contraction_screen.dart';
import '../../sims/simultaneity/simultaneity_screen.dart';
import '../../sims/mass_energy/mass_energy_screen.dart';
import '../../../../core/widgets/ad_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openLessonList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff0f0f26),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Select a Structured Lesson",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: lessons.length,
                    itemBuilder: (context, index) {
                      final lesson = lessons[index];
                      return Card(
                        color: const Color(0xff15152a),
                        margin: const EdgeInsets.symmetric(vertical: 6.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: const Color(0xff4fc3f7).withOpacity(0.15),
                          ),
                        ),
                        child: ListTile(
                          leading: Text(
                            lesson.emoji,
                            style: const TextStyle(fontSize: 24),
                          ),
                          title: Text(
                            lesson.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            lesson.subtitle,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xff4fc3f7),
                            size: 16,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LessonScreen(lesson: lesson),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0a0a1a),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Subtle star field background decoration
                Positioned.fill(
                  child: CustomPaint(
                    painter: StarFieldPainter(),
                  ),
                ),
                
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        // Header
                        const Center(
                          child: Text(
                            "SPECIAL RELATIVITY",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Center(
                          child: Text(
                            "Interactive 2D Flame Physics Lab",
                            style: TextStyle(
                              color: const Color(0xff4fc3f7).withOpacity(0.8),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Grid of Simulations
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.1,
                            children: [
                              _buildMenuCard(
                                title: "Time Dilation",
                                subtitle: "Light clock ticks",
                                icon: Icons.timer,
                                color: const Color(0xff4fc3f7),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TimeDilationScreen(),
                                  ),
                                ),
                              ),
                              _buildMenuCard(
                                title: "Length Contraction",
                                subtitle: "Spaceship shrinkage",
                                icon: Icons.compress,
                                color: const Color(0xff00ff41),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LengthContractionScreen(),
                                  ),
                                ),
                              ),
                              _buildMenuCard(
                                title: "Simultaneity",
                                subtitle: "Train & Lightning",
                                icon: Icons.flash_on,
                                color: const Color(0xffffd700),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SimultaneityScreen(),
                                  ),
                                ),
                              ),
                              _buildMenuCard(
                                title: "E = mc²",
                                subtitle: "Mass-Energy Equiv.",
                                icon: Icons.blur_on,
                                color: const Color(0xffff9800),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MassEnergyScreen(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Bottom Panel: Lessons & Quiz
                        Row(
                          children: [
                            Expanded(
                              child: _buildActionCard(
                                title: "Lessons",
                                subtitle: "5 Structured Guides",
                                icon: Icons.menu_book,
                                color: const Color(0xff4fc3f7),
                                onTap: () => _openLessonList(context),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildActionCard(
                                title: "Quiz",
                                subtitle: "Test Your Knowledge",
                                icon: Icons.quiz,
                                color: const Color(0xffffffd700),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const QuizScreen(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SafeArea(
            child: GlobalBannerAdWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xff15152a),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: color.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 28),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xff15152a),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: color.withOpacity(0.25),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 10,
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

class StarFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(42); // deterministic seed
    final paint = Paint()..color = Colors.white.withOpacity(0.25);
    for (int i = 0; i < 40; i++) {
      final double x = rng.nextDouble() * size.width;
      final double y = rng.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), 1.0, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
