import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entity/taskEntity.dart';

class TaskTimeColumn extends StatelessWidget {
  final TaskDetails task;

  const TaskTimeColumn({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    // Parse and format the start time
    final DateTime parsedStartTime = _parseTaskTime(task.time);
    final String formattedStartTime = _formatTaskTime(parsedStartTime);

    // Parse and format the end time
    final DateTime parsedEndTime = _parseTaskTime(task.endTime);
    final String formattedEndTime = _formatTaskTime(parsedEndTime);

    return Column(
      children: [
        // Top Time Display (Start Time)
        Text(
          formattedStartTime,
          style: const TextStyle(fontSize: 12),
        ),

        // Vertical Divider
        Container(
          width: 1.5,
          height: 100, // Fixed height for the line
          margin: const EdgeInsets.symmetric(vertical: 4),
          color: Colors.grey,
        ),

        // Bottom Time Display (End Time)
        Text(
          formattedEndTime,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  // Parse the time from the task's string
  DateTime _parseTaskTime(String time) {
    try {
      return DateFormat('hh:mm a').parseStrict(time);
    } catch (e) {
      // Fallback to current time if parsing fails
      return DateTime.now();
    }
  }

  // Format the time for display
  String _formatTaskTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }
}
