import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/entity/taskEntity.dart';

class TaskTimeColumn extends StatelessWidget {
  final TaskDetails task;

  const TaskTimeColumn({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    // Parse and format the start time or return an empty space
    final String formattedStartTime = _parseAndFormatTaskTime(task.time);

    // Parse and format the end time or return an empty space
    final String formattedEndTime = _parseAndFormatTaskTime(task.endTime);

    return Column(
      children: [
        Text(
          formattedStartTime,
          style: const TextStyle(fontSize: 12),
        ),
        Container(
          width: 1.5,
          height: 100,
          margin: const EdgeInsets.symmetric(vertical: 4),
          color: Colors.grey,
        ),

        Text(
          formattedEndTime,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  String _parseAndFormatTaskTime(String? time) {
    if (time == null || time.trim().isEmpty) {
      return ' ';
    }
    try {
      // Parse the time string
      final DateTime parsedTime = DateFormat('hh:mm a').parseStrict(time);
      return _formatTaskTime(parsedTime);
    } catch (e) {
      // Return an empty space if parsing fails
      return ' ';
    }
  }

  // Format the time for display
  String _formatTaskTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }
}
