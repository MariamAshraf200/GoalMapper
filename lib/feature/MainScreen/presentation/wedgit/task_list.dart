import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapperapp/feature/taskHome/presintation/bloc/taskBloc/bloc.dart';
import 'package:mapperapp/feature/taskHome/presintation/bloc/taskBloc/state.dart';
import '../../../taskHome/presintation/bloc/taskBloc/event.dart';
import '../wedgit/task_card.dart';

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<TaskBloc>().add(
      FilterTasksEvent(
        date: DateTime.now().toIso8601String(),
      ),
    );

    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TaskLoaded) {
          final tasks = state.tasks;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: tasks.map((task) {
                  return TaskCard(
                    title: task.title,
                    description: task.description,
                    time: task.time,
                    priority: task.priority,
                    status: task.status,
                  );
                }).toList(),
              ),
            ),
          );
        } else if (state is TaskError) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text("No tasks found."));
        }
      },
    );
  }
}