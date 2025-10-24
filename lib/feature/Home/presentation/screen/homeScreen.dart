import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/util/date_and_time/date_format_util.dart';
import '../../../../core/util/widgets/custom_FAB.dart';
import '../../../taskHome/presintation/bloc/taskBloc/bloc.dart';
import '../../../taskHome/presintation/bloc/taskBloc/event.dart';
import '../../../taskHome/presintation/bloc/taskBloc/state.dart' as taskState;
import '../wedgit/home_header.dart';
import '../wedgit/task_status_card.dart';
import '../wedgit/weekly_progress.dart';
import 'home_screen_form.dart';
import 'package:mapperapp/app_bootstrapper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  late String _viewDate;

  @override
  void initState() {
    super.initState();
    _viewDate = DateFormatUtil.getCurrentDateFormatted();
    context.read<TaskBloc>().add(GetAllTasksEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext() {
    context.read<TaskBloc>().add(GetAllTasksEvent());
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
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
            final today = _viewDate;
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

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                    child: const WeeklyProgressWidget(),
                  ),

                  // 🔹 Today’s tasks
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: HomeScreenForm(tasks: tasksForToday),
                  ),
                ],
              ),
            );
          } else if (state is taskState.TaskError) {
            return Center(child: Text(state.message));
          }
          return SizedBox.shrink();
        },
      ),
      floatingActionButton: CustomFAB(context: context),
    );
  }
}
