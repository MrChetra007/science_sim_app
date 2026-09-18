import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../games/sprites.dart';
import '../theme.dart';

typedef Formatter = String Function(double value);

String fmtNum(double v) => v.toStringAsFixed(0);

class ValueSlider extends StatelessWidget {
  const ValueSlider({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.formatter = fmtNum,
    this.divisions,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final Formatter formatter;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                    color: AppColors.dim,
                    fontSize: 12.5,
                    fontFamily: 'monospace'),
              ),
            ),
            Text(
              formatter(value),
              style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'monospace'),
            ),
          ],
        ),
        Slider(
          value: value.clamp(min, max).toDouble(),
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class ToggleGroup extends StatelessWidget {
  const ToggleGroup({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final List<String> options;
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: List.generate(options.length, (i) {
          final active = i == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: active ? AppColors.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  options[i],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: active ? const Color(0xFF000000) : AppColors.dim,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class ReadoutCard extends StatelessWidget {
  const ReadoutCard({super.key, required this.rows, this.title});

  final String? title;
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null)
            Text(
              title!,
              style: const TextStyle(
                color: AppColors.accent,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          if (title != null) const SizedBox(height: 6),
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0)
              const Divider(color: AppColors.border, height: 10, thickness: 0.6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    rows[i].$1,
                    style: const TextStyle(
                        color: AppColors.dim, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  rows[i].$2,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 12.5,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class SpritePicker extends StatelessWidget {
  const SpritePicker({super.key, required this.selected, required this.onChanged});

  final ObjectSprite selected;
  final ValueChanged<ObjectSprite> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.opticObjectLabel,
            style: const TextStyle(
                color: AppColors.dim, fontSize: 12.5, fontFamily: 'monospace')),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ObjectSprite.values.map((s) {
            final active = s == selected;
            return GestureDetector(
              onTap: () => onChanged(s),
              child: Container(
                width: 88,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: active ? AppColors.hover : AppColors.card,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: active ? AppColors.accent : AppColors.border,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                      child: s.asset == null
                          ? const Icon(Icons.arrow_upward,
                              size: 24, color: AppColors.warning)
                          : Image.asset(s.asset!, fit: BoxFit.contain),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      s.label(l10n),
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: active ? AppColors.text : AppColors.dim,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: AppColors.dim,
        fontSize: 10.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.1,
      ),
    );
  }
}