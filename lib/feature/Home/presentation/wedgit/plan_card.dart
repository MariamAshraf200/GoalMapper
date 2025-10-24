import 'package:flutter/material.dart';
import 'package:mapperapp/l10n/l10n_extension.dart';
import '../../../PlanHome/domain/entities/taskPlan.dart';
import 'package:mapperapp/core/util/date_and_time/date_format_util.dart';
import 'package:mapperapp/core/util/date_and_time/time_format_util.dart';

import '../../../PlanHome/presentation/screen/plan_details.dart';

class PlanCardCombined extends StatelessWidget {
  final String title;
  final List<TaskPlan> tasks;
  final String? endDateRaw;
  final String? updatedTimeRaw;
final String id;
  const PlanCardCombined({
    super.key,
    required this.title,
    required this.tasks,
    this.endDateRaw,
    this.updatedTimeRaw,
    required this.id,
  });

  double _calculateProgress(List<TaskPlan> tasks) {
    if (tasks.isEmpty) return 0.0;
    final completed =
        tasks.where((t) => t.status == TaskPlanStatus.done).length;
    return completed / tasks.length;
  }

  String? _formatEndDate(BuildContext context) {
    if (endDateRaw == null) return null;
    final raw = endDateRaw!.trim();
    if (raw.isEmpty) return null;
    try {
      final locale = Localizations.localeOf(context).toString();
      return DateFormatUtil.formatFullDateFromRaw(raw, locale: locale);
    } catch (_) {
      return raw;
    }
  }

  String? _formatTime(BuildContext context) {
    if (updatedTimeRaw == null) return null;
    final raw = updatedTimeRaw!.trim();
    if (raw.isEmpty) return null;
    return TimeFormatUtil.formatFlexibleTime(raw, context);
  }

  @override
  Widget build(BuildContext context) {
    final progress = _calculateProgress(tasks);
    final formattedDate = _formatEndDate(context);
    final formattedTime = _formatTime(context);
    final endDisplay = formattedDate != null
        ? (formattedTime != null
            ? '$formattedDate • $formattedTime'
            : formattedDate)
        : null;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlanDetailsScreen(
            id: id,
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[300],
                      color: colorScheme.secondary,
                      strokeWidth: 6,
                    ),
                  ),
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
                    LinearProgressIndicator(
                      value: progress,
                      color: colorScheme.secondary,
                      backgroundColor: Colors.grey[300],
                      minHeight: 8,
                    ),
                    const SizedBox(height: 8),
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
              Text(
                "${(progress * 100).toStringAsFixed(0)}%\n${context.l10n.complete}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
