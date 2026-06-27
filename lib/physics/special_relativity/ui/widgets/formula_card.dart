import 'package:flutter/material.dart';

class FormulaCard extends StatelessWidget {
  final String formulaTitle;
  final String latexFormula;
  final Map<String, String> variables;

  const FormulaCard({
    super.key,
    required this.formulaTitle,
    required this.latexFormula,
    required this.variables,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xff051405), // dark terminal green tint
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xff00ff41).withOpacity(0.3),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            formulaTitle.toUpperCase(),
            style: TextStyle(
              color: const Color(0xff00ff41).withOpacity(0.7),
              fontWeight: FontWeight.bold,
              fontSize: 10,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            latexFormula,
            style: const TextStyle(
              color: Color(0xff00ff41),
              fontFamily: 'monospace',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 1,
            color: const Color(0xff00ff41).withOpacity(0.15),
          ),
          const SizedBox(height: 4),
          ...variables.entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontFamily: 'monospace',
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    entry.value,
                    style: const TextStyle(
                      color: Color(0xff00ff41),
                      fontFamily: 'monospace',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
