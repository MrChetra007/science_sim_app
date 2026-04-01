import 'package:flutter/material.dart';
import '../../core/constants.dart';

class InfoPanel extends StatefulWidget {
  final String title;
  final String description;
  final String formula;

  const InfoPanel({
    super.key,
    required this.title,
    required this.description,
    required this.formula,
  });

  @override
  State<InfoPanel> createState() => _InfoPanelState();
}

class _InfoPanelState extends State<InfoPanel> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    if (!_isExpanded) {
      return Align(
        alignment: Alignment.topRight,
        child: IconButton(
          icon: const Icon(
            Icons.info_outline,
            color: AppColors.primaryAccent,
            size: 32,
          ),
          onPressed: () {
            setState(() {
              _isExpanded = true;
            });
          },
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(
          alpha: AppConstants.infoPanelOpacity,
        ),
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        border: Border.all(
          color: AppColors.primaryAccent.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primaryAccent,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  setState(() {
                    _isExpanded = false;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.formula,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.secondaryAccent,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
