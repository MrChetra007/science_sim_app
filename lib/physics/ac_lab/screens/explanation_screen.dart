import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../l10n/generated/app_localizations.dart';

class ModuleExplanationScreen extends StatelessWidget {
  final String title;
  final String whatIsIt;
  final List<String> howItWorks;
  final Color accentColor;

  const ModuleExplanationScreen({
    super.key,
    required this.title,
    required this.whatIsIt,
    required this.howItWorks,
    this.accentColor = Colors.cyan,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(title.toUpperCase(), 
          style: const TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: const Color(0xFF0D1117),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              l10n.whatIsIt,
              whatIsIt,
              Icons.info_outline,
            ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1, end: 0),
            
            const SizedBox(height: 30),
            
            _buildSection(
              context,
              l10n.howItWorks,
              '', 
              Icons.settings_suggest,
              child: Column(
                children: howItWorks.map((point) => _buildPoint(point)).toList(),
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideX(begin: 0.1, end: 0),
            
            const SizedBox(height: 40),
            
            Center(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: Text(l10n.gotIt),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor.withOpacity(0.2),
                  foregroundColor: accentColor,
                  side: BorderSide(color: accentColor),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ).animate().fadeIn(delay: 500.ms).scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String description, IconData icon, {Widget? child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accentColor, size: 28),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
            ],
          ),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 15),
            Text(
              description,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white70,
                height: 1.5,
              ),
            ),
          ],
          if (child != null) ...[
            const SizedBox(height: 15),
            child,
          ],
        ],
      ),
    );
  }

  Widget _buildPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, color: accentColor.withOpacity(0.5), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
