import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entity/taskEntity.dart';

class TaskTimeColumn extends StatelessWidget {
  final TaskDetails task; // Replace with your actual task model

  const TaskTimeColumn({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    // Parse and format the time
    final DateTime parsedTime = _parseTaskTime(task.time);
    final String formattedTime = _formatTaskTime(parsedTime);

    return Column(
      children: [
        // Top Time Display
        Text(
          formattedTime,
          style: const TextStyle(color: Colors.black, fontSize: 12),
        ),

        // Vertical Divider
        Container(
          width: 1.5,
          height: 100, // Fixed height for the line
          margin: const EdgeInsets.symmetric(vertical: 4),
          color: Colors.grey,
        ),

        // Bottom Time Display
        Text(
          formattedTime,
          style: const TextStyle(color: Colors.black, fontSize: 12),
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
