import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/plan_entity.dart';
import '../bloc/bloc.dart';
import '../bloc/event.dart';
import '../bloc/state.dart';

class PlanDetailsScreen extends StatefulWidget {
  final PlanDetails plan;

  const PlanDetailsScreen({super.key, required this.plan});

  @override
  State<PlanDetailsScreen> createState() => _PlanDetailsScreenState();
}

class _PlanDetailsScreenState extends State<PlanDetailsScreen> {
  late PlanDetails plan;

  @override
  void initState() {
    super.initState();
    plan = widget.plan;

    // 🔹 اطلب التاسكات الخاصة بالبلان
    context.read<PlanBloc>().add(GetAllTasksPlanEvent(plan.id));
  }

  @override
  Widget build(BuildContext context) {
    double progress = plan.progress ?? 0.0;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleButton(
                    icon: Icons.arrow_back_ios_new,
                    onTap: () => Navigator.pop(context, plan),
                  ),
                  _circleButton(
                    icon: Icons.more_horiz,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Title
                    Text(
                      plan.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // 🔹 Description
                    if (plan.description.isNotEmpty)
                      Text(
                        plan.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    const SizedBox(height: 16),

                    // 🔹 Progress
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey.shade300,
                            color: Colors.deepPurple,
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "${(progress * 100).toInt()}%",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 🔹 Dates
                    Row(
                      children: [
                        Expanded(
                          child: _infoTile(
                            label: "Start Date",
                            icon: Icons.event,
                            value: plan.startDate,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _infoTile(
                            label: "End Date",
                            icon: Icons.flag,
                            value: plan.endDate,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 🔹 Subtasks section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Subtasks",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => _showAddTaskDialog(context),
                          icon: const Icon(Icons.add, color: Colors.deepPurple),
                          label: const Text(
                            "Add Subtask",
                            style: TextStyle(color: Colors.deepPurple),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // 🔹 BlocBuilder to listen for tasks
                    BlocBuilder<PlanBloc, PlanState>(
                      builder: (context, state) {
                        if (state is TasksLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is PlanAndTasksLoaded) {
                          final tasks = state.tasks;
                          if (tasks.isEmpty) {
                            return const Center(
                              child: Text(
                                "No subtasks yet.",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              ),
                            );
                          }
                          return Column(
                            children: tasks
                                .map((task) => _subTaskCard(task, "-", false))
                                .toList(),
                          );
                        } else if (state is TaskError) {
                          return Center(
                              child: Text("Error: ${state.message}"));
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),

            // 🔹 Bottom Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, plan);
                  },
                  child: const Text(
                    "Edit Plan",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Circle icon button
  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade400, width: 1.5),
      ),
      child: IconButton(
        icon: Icon(icon, size: 20, color: Colors.black87),
        onPressed: onTap,
      ),
    );
  }

  // 🔹 Info tile
  Widget _infoTile({
    required String label,
    required IconData icon,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.deepPurple, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Subtask card
  Widget _subTaskCard(String title, String date, bool isDone) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDone ? Colors.green.shade50 : Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isDone ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                decoration: isDone ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.access_time, size: 14, color: Colors.black54),
          const SizedBox(width: 4),
          Text(
            date,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // 🔹 Add subtask dialog with Bloc
  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            "Add Subtask",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Enter task title...",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  context.read<PlanBloc>().add(
                    AddTaskToPlanEvent(
                      planId: plan.id,
                      task: controller.text.trim(),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
