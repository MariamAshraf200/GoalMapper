import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/customColor.dart';
import '../../../../core/util/widgets/custom_FAB.dart';
import '../bloc/main_bloc.dart';
import '../bloc/main_event.dart';
import '../bloc/main_state.dart';
import 'home_screen_form.dart';
import 'package:mapperapp/main.dart'; // Ensure this imports your global routeObserver

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  CustomColor color = CustomColor();

  @override
  void initState() {
    super.initState();
    // Initial data load
    context.read<MainTaskBloc>().add(GetMainTasksEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe this screen to the route observer.
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    // Unsubscribe from the route observer
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when the current route is re-shown (i.e. when returning from another screen)
    // Refresh the tasks by dispatching the event.
    context.read<MainTaskBloc>().add(GetMainTasksEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MainTaskBloc, MainState>(
        builder: (context, state) {
          if (state is MainTaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MainTaskLoaded) {
            final tasks = state.tasks;
            final doneTasksCount =
                tasks.where((task) => task.status.trim().toLowerCase() == "done").length;
            final totalTasksCount = tasks.length;

            final today = DateFormat('dd/MM/yyyy').format(DateTime.now());
            final tasksForToday = tasks.where((task) {
              return task.date == today && task.status.trim().toLowerCase() == "to do";
            }).toList();

            double taskCompletionPercentage =
            totalTasksCount > 0 ? doneTasksCount / totalTasksCount : 0;

            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(doneTasksCount, totalTasksCount, taskCompletionPercentage),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: HomeScreenForm(tasks: tasksForToday),
                  ),
                ],
              ),
            );
          } else if (state is MainTaskError) {
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
