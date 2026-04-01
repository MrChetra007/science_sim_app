import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ac_provider.dart';

class RewardedTimerChip extends StatelessWidget {
  const RewardedTimerChip({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ACProvider>();
    final timeLeft = provider.rewardedTimeLeft;

    if (timeLeft == null || provider.userTier != UserTier.free) {
      return const SizedBox.shrink();
    }

    final minutes = timeLeft.inMinutes;
    final seconds = timeLeft.inSeconds % 60;
    final timeStr = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    
    final isUrgent = timeLeft.inSeconds < 60;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isUrgent ? Colors.red.withOpacity(0.2) : Colors.amber.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isUrgent ? Colors.red : Colors.amber,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer,
            size: 16,
            color: isUrgent ? Colors.red : Colors.amber,
          ),
          const SizedBox(width: 6),
          Text(
            timeStr,
            style: TextStyle(
              color: isUrgent ? Colors.red : Colors.amber,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              fontFamily: 'Orbitron', // Using the app's font
            ),
          ),
        ],
      ),
    );
  }
}
