import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/customColor.dart';
import '../../../../core/util/widgets/custom_FAB.dart';

import '../../../taskHome/presintation/bloc/taskBloc/bloc.dart';
import '../../../taskHome/presintation/bloc/taskBloc/state.dart';
import 'home_screen_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CustomColor color = CustomColor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            final tasks = state.tasks;
            final doneTasksCount = tasks.where((task) => task.status == "Done").length;
            final totalTasksCount = tasks.length;

            // Calculate task completion percentage
            double taskCompletionPercentage = totalTasksCount > 0 ? doneTasksCount / totalTasksCount : 0;

            return Column(
              children: [
                _buildHeader(doneTasksCount, totalTasksCount, taskCompletionPercentage),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: HomeScreenForm(tasks: tasks), // Pass tasks to HomeScreenForm
                ),
              ],
            );
          } else if (state is TaskError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text("No tasks found."));
          }
        },
      ),
      floatingActionButton: CustomFAB(context: context),
    );
  }

  Widget _buildHeader(int doneTasksCount, int totalTasksCount, double taskCompletionPercentage) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SafeArea(
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Hi Mariam',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications, color: Colors.deepPurple),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.menu, color: Colors.deepPurple),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Today',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$doneTasksCount/$totalTasksCount tasks',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 85,
                        height: 85,
                        child: TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 800),
                          tween: Tween<double>(begin: 0, end: taskCompletionPercentage),
                          builder: (context, value, child) {
                            return CircularProgressIndicator(
                              value: value,
                              strokeWidth: 6,
                              valueColor: const AlwaysStoppedAnimation(Colors.white),
                              backgroundColor: Colors.white.withOpacity(0.2),
                            );
                          },
                        ),
                      ),
                      const CircleAvatar(
                        radius: 35,
                        backgroundImage: AssetImage('assets/images/1.jpg'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}