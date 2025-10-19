import 'package:intl/intl.dart';
import '../../../../../injection_imports.dart';


extension TaskDetailsX on TaskDetails {
  bool get isCompleted => status == TaskStatus.done.toTaskStatusString();
  bool get isPending => status == TaskStatus.pending.toTaskStatusString();
  bool get isMissed => status == TaskStatus.missed.toTaskStatusString();
  bool get isToDo => status == TaskStatus.toDo.toTaskStatusString();

  /// Domain rule: determine if this task should be marked missed
  bool shouldBeMissed(DateTime now) {
    try {
      final end = DateFormat('dd/MM/yyyy hh:mm a').parse('$date $endTime');
      return end.isBefore(now) && !isCompleted && !isPending;
    } catch (_) {
      return false;
    }
  }
}
