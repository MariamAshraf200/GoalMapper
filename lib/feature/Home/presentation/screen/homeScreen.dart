import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/util/widgets/custom_FAB.dart';
import '../../../../core/util/date_format_util.dart';
import '../../../taskHome/presintation/bloc/taskBloc/bloc.dart';
import '../../../taskHome/presintation/bloc/taskBloc/event.dart';
import '../../../taskHome/presintation/bloc/taskBloc/state.dart' as taskState;
import '../wedgit/home_header.dart';
import '../wedgit/task_status_card.dart';
import 'home_screen_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(GetAllTasksEvent());
  }

  @override
  void didPopNext() {
    context.read<TaskBloc>().add(GetAllTasksEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TaskBloc, taskState.TaskState>(
        builder: (context, state) {
          if (state is taskState.TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is taskState.TaskLoaded) {
            final tasks = state.tasks;

            final today = DateFormatUtil.getCurrentDateFormatted();
            final tasksForToday = tasks.where((task) => task.date == today).toList();

            final doneTasksCount = tasksForToday
                .where((task) => task.status.trim().toLowerCase() == "done")
                .length;

            final totalTasksCount = tasksForToday.length;

            final taskCompletionPercentage =
            totalTasksCount > 0 ? doneTasksCount / totalTasksCount : 0.0;

            return SingleChildScrollView(
              child: Column(
                children: [
                  // 🔹 New Header
                  HomeHeader(),

                  // 🔹 Stats card
                  TaskStatsCard(
                    doneTasks: doneTasksCount,
                    totalTasks: totalTasksCount,
                    completionPercentage: taskCompletionPercentage,
                  ),

                  // 🔹 Today’s tasks
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: HomeScreenForm(
                      tasks: tasksForToday
                          .where((task) =>
                      task.status.trim().toLowerCase() == "to do")
                          .toList(),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is taskState.TaskError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text("No tasks found ."));
        },
      ),
      floatingActionButton: CustomFAB(context: context),
    );
  }
}
