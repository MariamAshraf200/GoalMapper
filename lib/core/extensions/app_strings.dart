class AppStrings {
  static const String taskNotEditable =
      'This task is already completed or missed and cannot be changed.';
  static const String updateTaskDescription =
      'Do you want to update this task?';
  static const String deleteTaskDescription =
      'Are you sure you want to delete this task?';

  // Weekly progress widget strings
  static const String weeklyProgressTitle = '📊 Weekly Progress Analysis';

  static String weeklyBestDayMessage(String bestDayName) =>
      '🔥 Excellent consistency! Best day: $bestDayName';

  static const String weeklyGoodEffortMessage = '💪 Good effort! Keep it up.';
  static const String weeklyBackOnTrackMessage = "🚀 Let's get back on track next week!";
}
