import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc.dart';
import '../bloc/event.dart';

class TaskCard extends StatelessWidget {
  final String taskId;
  final String title;
  final String description;
  final String date;
  final String time;
  final String priority;
  final Color? priorityColor;
  final VoidCallback onViewClicked;

  const TaskCard({
    Key? key,
    required this.taskId,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.priority,
    this.priorityColor,
    required this.onViewClicked,
  }) : super(key: key);

  void _deleteTask(BuildContext context) {
    context.read<TaskBloc>().add(DeleteTaskEvent(taskId));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 6.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: onViewClicked,
                      icon: const Icon(
                        CupertinoIcons.arrow_up_right,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => _deleteTask(context),
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.grey,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16.0,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    date,
                    style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 16.0,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4.0),
                  Text(
                    time,
                    style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  color: priorityColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  priority,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
