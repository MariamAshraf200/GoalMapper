import 'package:intl/intl.dart';
import '../../../../core/util/date_and_time/date_format_util.dart';
import '../../../taskHome/domain/entity/taskEntity.dart';
import '../entity/week_progress.dart';

class UpdateDailyProgressUsecase {
  WeeklyProgress update({
    required WeeklyProgress previousProgress,
    required List<TaskDetails> allTasks,
  }) {
    final now = DateTime.now();
    final days = previousProgress.days;

    // Collect all affected (changed) dates from tasks
    final affectedDates = allTasks.map((t) {
      final source = (t.updatedTime?.trim().isNotEmpty ?? false)
          ? t.updatedTime!
          : t.date;
      final parsed = DateFormatUtil.tryParseFlexible(source)
          ?? DateFormatUtil.parseDate(source);
      return DateTime(parsed.year, parsed.month, parsed.day);
    }).toSet();

    final dailyProgress = Map<DateTime, double>.from(previousProgress.dailyProgress);

    // Update only affected days
    for (final day in days) {
      if (affectedDates.contains(day)) {
        final dayTasks = allTasks.where((t) {
          final source = (t.updatedTime?.trim().isNotEmpty ?? false)
              ? t.updatedTime!
              : t.date;
          final parsed = DateFormatUtil.tryParseFlexible(source)
              ?? DateFormatUtil.parseDate(source);
          final normalized = DateTime(parsed.year, parsed.month, parsed.day);
          return normalized.isAtSameMomentAs(day);
        }).toList();

        dailyProgress[day] = dayTasks.isEmpty
            ? 0.0
            : (dayTasks.where((t) => t.status.toLowerCase().trim() == 'done').length /
            dayTasks.length);
      }
    }

    final avg = dailyProgress.isEmpty
        ? 0.0
        : (dailyProgress.values.reduce((a, b) => a + b) / dailyProgress.length);
    final bestEntry = dailyProgress.isNotEmpty
        ? dailyProgress.entries.reduce((a, b) => a.value > b.value ? a : b)
        : null;
    final bestDayName =
    bestEntry != null ? DateFormat('EEEE').format(bestEntry.key) : '';
    final todayIndex = days.indexWhere((d) =>
    d.year == now.year && d.month == now.month && d.day == now.day);

    return WeeklyProgress(
      days: days,
      dailyProgress: dailyProgress,
      avgProgress: avg,
      bestDayName: bestDayName,
      todayIndex: todayIndex,
    );
  }
}
