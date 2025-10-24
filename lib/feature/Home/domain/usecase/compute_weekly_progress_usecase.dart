
import 'package:intl/intl.dart';

import '../../../../core/util/date_and_time/date_format_util.dart';
import '../../../taskHome/domain/entity/taskEntity.dart';
import '../entity/week_progress.dart';

class ComputeWeeklyProgressUsecase {


  WeeklyProgress call(List<TaskDetails> allTasks, {bool forceFullRecompute = false}) {
    final now = DateTime.now();
    final daysToSubtract = (now.weekday + 1) % 7; // Saturday -> 0
    final startOfWeek = DateTime(now.year, now.month, now.day).subtract(Duration(days: daysToSubtract));
    final days = List.generate(7, (i) {
      final d = startOfWeek.add(Duration(days: i));
      return DateTime(d.year, d.month, d.day);
    });

    final dailyProgress = <DateTime, double>{};
    for (final day in days) {
      final dayTasks = allTasks.where((t) {
        final source = (t.updatedTime?.trim().isNotEmpty ?? false) ? t.updatedTime! : t.date;
        final parsed = DateFormatUtil.tryParseFlexible(source) ?? DateFormatUtil.parseDate(source);
        final normalized = DateTime(parsed.year, parsed.month, parsed.day);
        return normalized.isAtSameMomentAs(day);
      }).toList();

      dailyProgress[day] = dayTasks.isEmpty ? 0.0
          : (dayTasks.where((t) => t.status.toLowerCase().trim() == 'done').length / dayTasks.length);
    }

    final avg = dailyProgress.isEmpty ? 0.0
        : dailyProgress.values.reduce((a, b) => a + b) / dailyProgress.length;
    final bestEntry = dailyProgress.isNotEmpty
        ? dailyProgress.entries.reduce((a, b) => a.value > b.value ? a : b)
        : null;
    final bestDayName = bestEntry != null ? DateFormat('EEEE').format(bestEntry.key) : '';
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
