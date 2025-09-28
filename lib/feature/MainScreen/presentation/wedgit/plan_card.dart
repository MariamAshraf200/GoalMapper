import 'package:flutter/material.dart';
import '../../../PlanHome/domain/entities/taskPlan.dart';
import 'package:mapperapp/core/util/date_format_util.dart';
import 'package:mapperapp/core/util/time_format_util.dart';

class PlanCardCombined extends StatelessWidget {
  final String title;
  final List<TaskPlan> tasks; // ✅ بدل days/total هنعتمد على tasks
  final String? endDateRaw; // raw date string from model (e.g., 'dd/MM/yyyy' or ISO)
  final String? updatedTimeRaw; // raw time string (e.g., '3:30 PM' or '15:30')

  const PlanCardCombined({
    super.key,
    required this.title,
    required this.tasks,
    this.endDateRaw,
    this.updatedTimeRaw,
  });

  // 🔹 نفس لوجيك PlanDetailsProgress
  double _calculateProgress(List<TaskPlan> tasks) {
    if (tasks.isEmpty) return 0.0;
    final completed = tasks.where((t) => t.status == TaskPlanStatus.done).length;
    return completed / tasks.length;
  }

  String? _formatEndDate() {
    if (endDateRaw == null) return null;
    final raw = endDateRaw!.trim();
    if (raw.isEmpty) return null;
    try {
      return DateFormatUtil.formatFullDateFromRaw(raw);
    } catch (_) {
      return raw;
    }
  }

  String? _formatTime(BuildContext context) {
    if (updatedTimeRaw == null) return null;
    final raw = updatedTimeRaw!.trim();
    if (raw.isEmpty) return null;
    // Try AM/PM parser
    try {
      final tod = TimeFormatUtil.parseTime(raw);
      return TimeFormatUtil.formatTime(tod, context);
    } catch (_) {}
    // Fallback: HH:mm 24h
    final match = RegExp(r'^(\d{1,2}):(\d{2})$').firstMatch(raw);
    if (match != null) {
      final hour = int.tryParse(match.group(1)!) ?? 0;
      final minute = int.tryParse(match.group(2)!) ?? 0;
      if (hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59) {
        final tod = TimeOfDay(hour: hour, minute: minute);
        return TimeFormatUtil.formatTime(tod, context);
      }
    }
    return raw;
  }

  @override
  Widget build(BuildContext context) {
    final progress = _calculateProgress(tasks);
    final formattedDate = _formatEndDate();
    final formattedTime = _formatTime(context);
    final endDisplay = formattedDate != null ? (formattedTime != null ? '$formattedDate • $formattedTime' : formattedDate) : null;

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
            // 🔹 Circular Progress (Tasks Completed)
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[300],
                    color: Colors.deepPurple,
                    strokeWidth: 6,
                  ),
                ),
                // عدد التاسكات المكتملة/الكل
                Text(
                  "${tasks.where((t) => t.status == TaskPlanStatus.done).length}/${tasks.length}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),

            // 🔹 Title + Linear Progress + Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
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

                  // Linear Progress for completeness
                  LinearProgressIndicator(
                    value: progress,
                    color: Colors.deepPurple,
                    backgroundColor: Colors.grey[300],
                    minHeight: 8,
                  ),
                  const SizedBox(height: 8),

                  // Optional: End date or info
                  if (endDisplay != null)
                    Text(
                      endDisplay,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // 🔹 % Complete
            Text(
              "${(progress * 100).toStringAsFixed(0)}%\ncomplete",
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
