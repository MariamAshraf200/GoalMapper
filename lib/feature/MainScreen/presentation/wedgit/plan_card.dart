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
    return Card(
      elevation: 5,
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
                    value: (totalDay - daysLeft) / totalDay, // Updated progress calculation
                    backgroundColor: Colors.grey[300],
                    color: Colors.deepPurple,
                    strokeWidth: 8,
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
                  ),
                  const SizedBox(height: 8),
                  // Completeness Line (Linear Progress Bar)
                  LinearProgressIndicator(
                    value: completeness,
                    color: Colors.green,
                    minHeight: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Completion Percentage with "complete" on the next line
            Text(
              "${(completeness * 100).toStringAsFixed(0)}%\ncomplete",
              textAlign: TextAlign.center, // Center align the text
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
