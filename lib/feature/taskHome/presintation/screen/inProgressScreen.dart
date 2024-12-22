import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Widget/customContainerTask.dart';
import '../bloc/bloc.dart';
import '../bloc/state.dart';
import '../bloc/event.dart';

class InProgressScreen extends StatelessWidget {
  const InProgressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<TaskBloc>().add(const GetTasksByStatusEvent('In Progress'));

    return Scaffold(
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            final inProgressTasks = state.tasks
                .where((task) => task.status == 'In Progress')
                .toList();
            const CircularProgressIndicator(value: 20,);

            return inProgressTasks.isEmpty
                ? const Center(
                    child: Text(
                      "No tasks in progress.",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      Text(
                        "You have ${inProgressTasks.length} tasks in progress",
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...inProgressTasks.map(
                        (task) => TaskCard(
                          title: task.title,
                          description: task.description,
                          date: task.date,
                          time: task.time,
                          priority: task.priority,
                          taskId: task.id,
                          status: task.status,
                          onViewClicked: () async {
                            try {
                              context.read<TaskBloc>().add(
                                    UpdateTaskStatusEvent(
                                      task.id,
                                      'done',
                                    ),
                                  );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        "Failed to update task status: $e")),
                              );
                            }
                          }, category: task.category,
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
          return const SizedBox();
        },
      ),
    );
  }

}
