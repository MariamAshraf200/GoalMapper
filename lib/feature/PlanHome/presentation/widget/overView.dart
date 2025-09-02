import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapperapp/feature/PlanHome/domain/entities/plan_entity.dart';
import 'package:mapperapp/feature/PlanHome/presentation/bloc/bloc.dart';
import '../../../taskHome/domain/entity/task_enum.dart';
import '../../../taskHome/presintation/bloc/taskBloc/bloc.dart';
import '../../../taskHome/presintation/bloc/taskBloc/event.dart';
import '../../../taskHome/presintation/bloc/taskBloc/state.dart';
import '../../../taskHome/presintation/screen/add_task_screen.dart';
import '../bloc/event.dart';


class OverviewContent extends StatelessWidget {
  final PlanDetails plan;

  const OverviewContent({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TaskLoaded) {
          final tasks = state.tasks;

          final allTasksCompleted = tasks.every((task) => task.status == 'Done');
          final hasToDoTasks = tasks.any((task) => task.status == 'to do');

          if (allTasksCompleted && plan.status != 'Completed') {
            context.read<PlanBloc>().add(
              UpdatePlanStatusEvent(plan.id, 'Completed'),
            );
          } else if (hasToDoTasks && plan.status != 'Not Completed') {
            context.read<PlanBloc>().add(
              UpdatePlanStatusEvent(plan.id, 'Not Completed'),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Description and Category Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepPurple.shade50,
                        Colors.deepPurple.shade100,
                        Colors.deepPurple.shade200,
                        Colors.deepPurple.shade300
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withAlpha( 50),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.description,
                              color: Colors.deepPurple.shade700, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            "Description",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        plan.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade800,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(Icons.category,
                              color: Colors.deepPurple.shade700, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            "Category",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        plan.category,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Tasks Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tasks",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddTaskScreen(planId: plan.id),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: tasks.map((task) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: task.status == 'Done',
                                    onChanged: (value) {
                                      context.read<TaskBloc>().add(
                                        UpdateTaskStatusEvent(
                                          task.id,
                                          value! ? TaskStatus.completed : TaskStatus.pending,
                                          updatedTime: '',
                                        ),
                                      );
                                      context.read<TaskBloc>().add(
                                          GetTasksByPlanIdEvent(plan.id)); // Refresh tasks
                                    },
                                  ),
                                  Text(
                                    task.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                      decoration: task.status == 'Done'
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  context.read<TaskBloc>().add(
                                    DeleteTaskEvent(task.id),
                                  );
                                  context.read<TaskBloc>().add(
                                      GetTasksByPlanIdEvent(plan.id)); // Refresh tasks
                                },
                                icon:
                                const Icon(Icons.close, color: Colors.red),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else if (state is TaskError) {
          return Center(
            child: Text("Failed to load tasks: ${state.message}"),
          );
        } else {
          return const Center(child: Text("No tasks available"));
        }
      },
    );
  }
}