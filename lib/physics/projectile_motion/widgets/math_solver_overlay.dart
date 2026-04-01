import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/simulation_provider.dart';
import '../physics/math_solver.dart';

class MathSolverOverlay extends ConsumerWidget {
  const MathSolverOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(simulationProvider);

    final solver = MathSolver(
      v0: state.initialSpeed,
      angleDeg: state.angle,
      h0: state.initialHeight,
      g: state.gravity,
      airResistance: state.airResistance,
    );

    final raw = solver.generateFullDerivation();
    final sections = _parseSections(raw);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: const Color(0xFF040D17),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(
          color: const Color(0xFF00E5FF).withValues(alpha: 0.18),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00E5FF).withValues(alpha: 0.07),
            blurRadius: 30,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Stack(
          children: [
            // Grid background
            CustomPaint(
              painter: _GridPainter(),
              size: Size(
                MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height * 0.75,
              ),
            ),

            Column(
              children: [
                // Drag handle
                Container(
                  margin: const EdgeInsets.only(top: 14, bottom: 10),
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: const Color(0xFF00E5FF).withValues(alpha: 0.4),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00E5FF).withValues(alpha: 0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),

                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 12, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 3,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E5FF).withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DERIVATION MODULE',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 9,
                              color: const Color(0xFF00E5FF)
                                  .withValues(alpha: 0.5),
                              letterSpacing: 3,
                            ),
                          ),
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Color(0xFFE0F7FA), Color(0xFF00E5FF)],
                            ).createShader(bounds),
                            child: const Text(
                              'MATHEMATICAL DERIVATION',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF00E5FF).withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFF00E5FF)
                                  .withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: const Icon(Icons.close_rounded,
                              color: Color(0xFF80DEEA), size: 18),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Gradient divider
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        const Color(0xFF00E5FF).withValues(alpha: 0.4),
                        const Color(0xFF00E5FF).withValues(alpha: 0.4),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                // Sections
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                    itemCount: sections.length,
                    itemBuilder: (context, i) =>
                        _SectionCard(section: sections[i], index: i),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Text cleaner ────────────────────────────────────────────────────────────
  // Strips all markdown + LaTeX into clean readable text
  static String _cleanLine(String line) {
    String s = line;

    // ── LaTeX fractions: \frac{a}{b} → a/b ──────────────────────────────
    s = s.replaceAllMapped(
      RegExp(r'\\frac\{([^}]+)\}\{([^}]+)\}'),
      (m) => '${m[1]}/${m[2]}',
    );

    // ── LaTeX superscripts: x^{2} → x², x^2 → x² ───────────────────────
    const supMap = {
      '0': '⁰',
      '1': '¹',
      '2': '²',
      '3': '³',
      '4': '⁴',
      '5': '⁵',
      '6': '⁶',
      '7': '⁷',
      '8': '⁸',
      '9': '⁹',
    };
    s = s.replaceAllMapped(
      RegExp(r'\^\{([^}]+)\}|\^(\w)'),
      (m) {
        final exp = (m[1] ?? m[2])!;
        return exp.split('').map((c) => supMap[c] ?? c).join();
      },
    );

    // ── LaTeX subscripts: x_{0} → x₀, x_0 → x₀ ────────────────────────
    const subMap = {
      '0': '₀',
      '1': '₁',
      '2': '₂',
      '3': '₃',
      '4': '₄',
      '5': '₅',
      '6': '₆',
      '7': '₇',
      '8': '₈',
      '9': '₉',
      'x': 'ₓ',
    };
    s = s.replaceAllMapped(
      RegExp(r'_\{([^}]+)\}|_(\w)'),
      (m) {
        final sub = (m[1] ?? m[2])!;
        return sub.split('').map((c) => subMap[c] ?? c).join();
      },
    );

    // ── Common LaTeX symbols ─────────────────────────────────────────────
    s = s
        .replaceAll(r'\cdot', '·')
        .replaceAll(r'\times', '×')
        .replaceAll(r'\circ', '°')
        .replaceAll(r'\approx', '≈')
        .replaceAll(r'\neq', '≠')
        .replaceAll(r'\leq', '≤')
        .replaceAll(r'\geq', '≥')
        .replaceAll(r'\pi', 'π')
        .replaceAll(r'\theta', 'θ')
        .replaceAll(r'\alpha', 'α')
        .replaceAll(r'\beta', 'β')
        .replaceAll(r'\Delta', 'Δ')
        .replaceAll(r'\sqrt', '√')
        .replaceAll(r'\text{ m/s}', ' m/s')
        .replaceAll(r'\text{ s}', ' s')
        .replaceAll(r'\text{ m}', ' m')
        .replaceAllMapped(RegExp(r'\\text\{([^}]*)\}'), (m) => m[1]!);

    // ── Strip inline math delimiters: $...$ ──────────────────────────────
    s = s.replaceAllMapped(RegExp(r'\$([^$]+)\$'), (m) => m[1]!);

    // ── Strip markdown bold/italic: **text** *text* ──────────────────────
    s = s.replaceAllMapped(RegExp(r'\*\*(.+?)\*\*'), (m) => m[1]!);
    s = s.replaceAllMapped(RegExp(r'\*(.+?)\*'), (m) => m[1]!);

    // ── Strip markdown blockquote > ──────────────────────────────────────
    s = s.replaceFirst(RegExp(r'^>\s*'), '');

    // ── Strip leading bullet - ───────────────────────────────────────────
    s = s.replaceFirst(RegExp(r'^-\s+'), '  • ');

    return s;
  }

  // ── Section parser ──────────────────────────────────────────────────────────
  // Splits on ### headers and treats [!NOTE] blocks as a special section
  static List<_Section> _parseSections(String raw) {
    final sections = <_Section>[];
    String? currentTitle;
    final buffer = StringBuffer();

    for (final rawLine in raw.split('\n')) {
      final trimmed = rawLine.trim();

      // ### N. Title  →  section header
      if (trimmed.startsWith('###')) {
        if (buffer.isNotEmpty || currentTitle != null) {
          sections.add(_Section(
            title: currentTitle ?? 'INFO',
            body: buffer.toString().trim(),
          ));
          buffer.clear();
        }
        currentTitle = trimmed
            .replaceFirst(RegExp(r'^###\s*'), '')
            .replaceFirst(RegExp(r'^\d+\.\s*'), '')
            .trim()
            .toUpperCase();
        continue;
      }

      // # Top-level heading
      if (trimmed.startsWith('# ')) {
        if (buffer.isNotEmpty || currentTitle != null) {
          sections.add(_Section(
            title: currentTitle ?? 'INFO',
            body: buffer.toString().trim(),
          ));
          buffer.clear();
        }
        currentTitle = trimmed.replaceFirst(RegExp(r'^#\s*'), '').toUpperCase();
        continue;
      }

      // Skip empty lines at the start of a section
      if (buffer.isEmpty && trimmed.isEmpty) continue;

      buffer.writeln(_cleanLine(rawLine));
    }

    if (buffer.isNotEmpty) {
      sections.add(_Section(
        title: currentTitle ?? 'RESULT',
        body: buffer.toString().trim(),
      ));
    }

    return sections.isEmpty
        ? [_Section(title: 'DERIVATION', body: _cleanLine(raw))]
        : sections;
  }

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const MathSolverOverlay(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section model
// ─────────────────────────────────────────────────────────────────────────────

class _Section {
  final String title;
  final String body;
  const _Section({required this.title, required this.body});
}

// ─────────────────────────────────────────────────────────────────────────────
// Section card
// ─────────────────────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final _Section section;
  final int index;
  const _SectionCard({required this.section, required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF00E5FF).withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF00E5FF).withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF00E5FF).withValues(alpha: 0.07),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFF00E5FF).withValues(alpha: 0.12),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 22,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E5FF).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    (index + 1).toString().padLeft(2, '0'),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 9,
                      color: Color(0xFF00E5FF),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '[ ${section.title} ]',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: Color(0xFF00E5FF),
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.all(14),
            child: SelectableText.rich(
              _buildRichText(section.body),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12.5,
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextSpan _buildRichText(String text) {
    final spans = <TextSpan>[];

    for (final line in text.split('\n')) {
      // Bullet lines get a teal accent
      final isBullet = line.trimLeft().startsWith('•');
      // Result lines with = get highlighted value
      final isResult = line.contains('=') && !line.contains('==');

      final lineSpans = <TextSpan>[];
      final pattern = RegExp(
        r'(\b\d+\.?\d*\b'
        r'|[₀₁₂₃₄₅₆₇₈₉⁰¹²³⁴⁵⁶⁷⁸⁹]+'
        r'|[θαβπΔ√·×≈≤≥°]'
        r'|v₀|h₀|v[xyz]|[a-zA-Z]₀?'
        r')',
      );
      int last = 0;
      for (final match in pattern.allMatches(line)) {
        if (match.start > last) {
          lineSpans.add(TextSpan(
            text: line.substring(last, match.start),
            style: TextStyle(
              color: isBullet ? Colors.white60 : Colors.white54,
            ),
          ));
        }
        final token = match.group(0)!;
        final isNum = RegExp(r'^\d+\.?\d*$').hasMatch(token);
        final isSymbol =
            RegExp(r'^[θαβπΔ√·×≈≤≥°₀₁₂₃₄₅₆₇₈₉⁰¹²³⁴⁵⁶⁷⁸⁹]+$').hasMatch(token);
        lineSpans.add(TextSpan(
          text: token,
          style: TextStyle(
            color: isNum
                ? const Color(0xFF64FFDA) // teal  → numbers
                : isSymbol
                    ? const Color(0xFFFFD740) // amber → symbols/units
                    : isResult
                        ? const Color(
                            0xFF00E5FF) // cyan  → variables in equations
                        : const Color(0xFF80DEEA), // light blue → other vars
            fontWeight: FontWeight.w600,
          ),
        ));
        last = match.end;
      }
      if (last < line.length) {
        lineSpans.add(TextSpan(
          text: line.substring(last),
          style: TextStyle(
            color: isBullet ? Colors.white60 : Colors.white54,
          ),
        ));
      }

      spans.addAll(lineSpans);
      spans.add(const TextSpan(text: '\n'));
    }

    return TextSpan(children: spans);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Grid painter
// ─────────────────────────────────────────────────────────────────────────────

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.025)
      ..strokeWidth = 0.7;
    const step = 32.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => false;
}
