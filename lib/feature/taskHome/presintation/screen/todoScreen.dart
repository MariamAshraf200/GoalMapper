import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entity/taskEntity.dart';
import '../Widget/customContainerTask.dart';
import '../bloc/bloc.dart';
import 'AddNewTaskScreen.dart';
import 'InProgressScreen.dart'; // Import the InProgress screen
import '../bloc/state.dart';
import '../bloc/event.dart';

class TaskListScreen extends StatefulWidget {
  final String status;

  const TaskListScreen({super.key, required this.status});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late List<TaskEntity> tasks;

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(GetTasksByStatusEvent(widget.status));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remove the AppBar here
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            final filteredTasks = state.tasks;

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
                  priorityColor: _getPriorityColor(task.priority),
                  onViewClicked: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InProgressScreen(),
                      ),
                    );
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
          final TaskEntity? newTask = await Navigator.push<TaskEntity>(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTaskScreen(),
            ),
          );
          if (newTask != null) {
            context.read<TaskBloc>().add(GetTasksByStatusEvent(widget.status));
          }
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
