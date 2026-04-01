import 'package:flutter/material.dart';
import '../../core/constants.dart';

class SceneCard extends StatelessWidget {
  final String title;
  final String tagline;
  final VoidCallback onTap;

  const SceneCard({
    super.key,
    required this.title,
    required this.tagline,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        side: BorderSide(color: AppColors.primaryAccent.withOpacity(0.3)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        splashColor: AppColors.primaryAccent.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.primaryAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tagline,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.primaryAccent.withOpacity(0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
