import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../injection_imports.dart';
import '../../../../../../l10n/l10n_extension.dart';


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

extension TaskPriorityColor on String {
  Color toPriorityColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (toLowerCase()) {
      case 'high':
        return colorScheme.error;
      case 'medium':
        return colorScheme.primary;
      case 'low':
        return colorScheme.secondary;
      default:
        return colorScheme.onSurface.withAlpha( 120);
    }
  }
}

/// Returns a localized label for priority string values (high/medium/low).
extension TaskPriorityLabel on String {
  String toPriorityLabel(BuildContext context) {
    final l10n = context.l10n;
    switch (toLowerCase()) {
      case 'high':
        return l10n.priorityHigh;
      case 'medium':
        return l10n.priorityMedium;
      case 'low':
        return l10n.priorityLow;
      default:
        return this;
    }
  }
}
