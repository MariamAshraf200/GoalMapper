import 'package:flutter/material.dart';

class PlanCardCombined extends StatelessWidget {
  final String title;
  final int daysLeft;
  final int totalDay;
  final double completeness;

  const PlanCardCombined({
    super.key,
    required this.title,
    required this.daysLeft,
    required this.totalDay,
    required this.completeness,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (totalDay > 0) ? (totalDay - daysLeft) / totalDay : 0.0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Circular Progress Indicator for Days Left
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    backgroundColor: Colors.grey[300],
                    color: Colors.deepPurple,
                    strokeWidth: 6,
                  ),
                ),
                // Days Left in the Center
                Text(
                  "$daysLeft d",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plan Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Completeness Line (Linear Progress Bar)
                  LinearProgressIndicator(
                    value: completeness.clamp(0.0, 1.0),
                    color: Colors.green,
                    backgroundColor: Colors.grey[300],
                    minHeight: 8,
                  ),
                  const SizedBox(height: 8),
                  // Additional Info (Optional)
                  Text(
                    "Total: $totalDay days",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Completion Percentage with "complete" on the next line
            Text(
              "${(completeness * 100).toStringAsFixed(0)}%\ncomplete",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
