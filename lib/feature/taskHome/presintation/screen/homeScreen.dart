import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapper_app/core/di.dart';
import 'package:mapper_app/feature/taskHome/presintation/screen/todoScreen.dart';
import '../../domain/entity/taskEntity.dart';
import '../Widget/customContainerHome.dart';
import '../Widget/data_format.dart';
import '../bloc/bloc.dart';
import '../bloc/event.dart';
import '../bloc/state.dart';
import 'AddNewTaskScreen.dart';
import 'doneScreen.dart';
import 'inProgressScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  List<TaskEntity> filteredTasks = [];

  @override
  void initState() {
    super.initState();
    sl<TaskBloc>().add(GetTasksEvent());
  }

  void filterTasks(List<TaskEntity> tasks, String status) {
    setState(() {
      filteredTasks = tasks.where((task) => task.status == status).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const DataFormat(),
          // Container row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: CustomContainer(
                  label: 'To Do',
                  number: filteredTasks.where((task) => task.status == 'To Do').length,
                  isSelected: selectedIndex == 0,
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                ),
              ),
              Expanded(
                child: CustomContainer(
                  label: 'In Progress',
                  number: filteredTasks.where((task) => task.status == 'In Progress').length,
                  isSelected: selectedIndex == 1,
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                ),
              ),
              Expanded(
                child: CustomContainer(
                  label: 'Done',
                  number: filteredTasks.where((task) => task.status == 'Done').length,
                  isSelected: selectedIndex == 2,
                  onTap: () {
                    setState(() {
                      selectedIndex = 2;
                    });
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: selectedIndex == 0
                ? BlocBuilder<TaskBloc, TaskState>(
              bloc: sl<TaskBloc>(),
              builder: (context, state) {
                if (state is TaskLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TaskLoaded) {
                  filterTasks(state.tasks, 'To Do');
                  return TaskListScreen(tasks: filteredTasks);
                } else if (state is TaskError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text('Unknown Error'));
                }
              },
            )
                : selectedIndex == 1
                ? BlocBuilder<TaskBloc, TaskState>(
              bloc: sl<TaskBloc>(),
              builder: (context, state) {
                if (state is TaskLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TaskLoaded) {
                  filterTasks(state.tasks, 'In Progress');
                  return InProgressScreen(tasks: filteredTasks);
                } else if (state is TaskError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text('Unknown Error'));
                }
              },
            )
                : BlocBuilder<TaskBloc, TaskState>(
              bloc: sl<TaskBloc>(),
              builder: (context, state) {
                if (state is TaskLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TaskLoaded) {
                  // Filter tasks based on 'Done' status
                  filterTasks(state.tasks, 'Done');
                  return DoneScreen(tasks: filteredTasks);
                } else if (state is TaskError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text('Unknown Error'));
                }
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
                bottomRight: Radius.elliptical(50, 50))),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(),
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
