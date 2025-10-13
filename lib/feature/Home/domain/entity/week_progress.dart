
class WeeklyProgress {
  final List<DateTime> days;
  final Map<DateTime, double> dailyProgress;
  final double avgProgress;
  final String bestDayName;
  final int todayIndex;

  WeeklyProgress({
    required this.days,
    required this.dailyProgress,
    required this.avgProgress,
    required this.bestDayName,
    required this.todayIndex,
  });
}
