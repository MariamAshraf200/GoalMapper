import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapperapp/feature/PlanHome/domain/entities/plan_entity.dart';
import 'package:mapperapp/feature/taskHome/presintation/bloc/taskBloc/bloc.dart';
import 'package:mapperapp/feature/taskHome/presintation/bloc/taskBloc/state.dart';
import 'package:mapperapp/feature/taskHome/presintation/screen/add_task_screen.dart';

import '../../../taskHome/presintation/bloc/taskBloc/event.dart';

class OverviewTab extends StatelessWidget {
  final PlanDetails plan;

  const OverviewTab({Key? key, required this.plan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TaskLoaded) {
          final tasks = state.tasks;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Description and Category Card
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.description, color: Theme.of(context).primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            "Description",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        plan.description.isNotEmpty
                            ? plan.description
                            : "No description provided.",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade700,
                          fontStyle: plan.description.isEmpty
                              ? FontStyle.italic
                              : FontStyle.normal,
                        ),
                      ),
                      const Divider(height: 32, thickness: 1.2),
                      Row(
                        children: [
                          Icon(Icons.category, color: Theme.of(context).primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            "Category",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        plan.category.isNotEmpty
                            ? plan.category
                            : "No category assigned.",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade700,
                          fontStyle: plan.category.isEmpty
                              ? FontStyle.italic
                              : FontStyle.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Tasks Card
              Card(
                elevation: 6,
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
                          Row(
                            children: [
                              Icon(Icons.task, color: Theme.of(context).primaryColor),
                              const SizedBox(width: 8),
                              Text(
                                "Tasks",
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, color: Colors.green),
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
                      tasks.isEmpty
                          ? Center(
                        child: Column(
                          children: [
                            const Icon(Icons.task_alt, size: 48, color: Colors.grey),
                            const SizedBox(height: 8),
                            Text(
                              "No tasks available.",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey.shade600,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      )
                          : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: tasks.length,
                        separatorBuilder: (context, index) =>
                        const Divider(height: 16, thickness: 1),
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Checkbox(
                              value: task.status == 'Done',
                              onChanged: (value) {
                                context.read<TaskBloc>().add(
                                  UpdateTaskStatusEvent(
                                    task.id,
                                    value! ? 'Done' : 'to do',
                                    updatedTime: '',
                                  ),
                                );
                              },
                            ),
                            title: Text(
                              task.title,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                decoration: task.status == 'Done'
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                context.read<TaskBloc>().add(
                                  DeleteTaskEvent(task.id),
                                );
                              },
                            ),
                          );
                        },
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