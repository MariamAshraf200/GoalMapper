import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Widget/customContainerTask.dart';
import '../bloc/bloc.dart';
import 'AddNewAndUpdateTaskScreen.dart';
import '../bloc/state.dart';
import '../bloc/event.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<TaskBloc>().add(const GetTasksByStatusEvent('to do'));

    return Scaffold(
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            final filteredTasks = state.tasks
                .where((task) => task.status == 'to do')
                .toList();
              return filteredTasks.isEmpty
                  ? const Center(
                child: Text(
                  "No tasks available. Add a new task!",
                  style: TextStyle(fontSize: 18),
                ),
              )
                  : ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Text(
                    "You have ${filteredTasks.length} Tasks",
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...filteredTasks.map((task) => TaskCard(
                    title: task.title,
                    description: task.description,
                    date: task.date,
                    time: task.time,
                    priority: task.priority,
                    onViewClicked: () async {
                      try {
                        context.read<TaskBloc>().add(
                          UpdateTaskStatusEvent(
                            task.id,
                            'In Progress',
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Failed to update task status: $e")),
                        );
                      }
                    },
                    taskId: task.id,
                    status: task.status,
                  )),
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
      floatingActionButton: FloatingActionButton(
        shape: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
                bottomRight: Radius.elliptical(50, 50))),
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTaskAndUpdateScreen(),
            ),
          );
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
