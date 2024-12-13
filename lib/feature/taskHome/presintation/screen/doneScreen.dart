import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Widget/customContainerTask.dart';
import '../bloc/bloc.dart';
import '../bloc/state.dart';
import '../bloc/event.dart';

class DoneScreen extends StatelessWidget {
  const DoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<TaskBloc>().add(const GetTasksByStatusEvent('done'));

    return Scaffold(
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            final doneTasks =
                state.tasks.where((task) => task.status == 'done').toList();

            return doneTasks.isEmpty
                ? const Center(
                    child: Text(
                      "No tasks completed yet.",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      Text(
                        "You have ${doneTasks.length} completed tasks",
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...doneTasks.map(
                        (task) => TaskCard(
                          title: task.title,
                          description: task.description,
                          date: task.date,
                          time: task.time,
                          priority: task.priority,
                          taskId: task.id,
                          status: task.status,
                          onViewClicked: () {},
                        ),
                      ),
                    ],
                  );
          } else if (state is TaskError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(fontSize: 18),
              ),
            );
          }
          return const SizedBox(); // Default empty state
        },
      ),
    );
  }

}
