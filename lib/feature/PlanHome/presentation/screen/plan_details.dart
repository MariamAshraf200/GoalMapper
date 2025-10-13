import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../../injection_imports.dart';
import '../../../../core/util/custom_builders/navigate_to_screen.dart';

class PlanDetailsScreen extends StatefulWidget {
  final PlanDetails plan;

  const PlanDetailsScreen({super.key, required this.plan});

  @override
  State<PlanDetailsScreen> createState() => _PlanDetailsScreenState();
}

class _PlanDetailsScreenState extends State<PlanDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // ✅ خليك في البلوك، هات التاسكات للخطة دي
    context.read<PlanBloc>().add(GetAllTasksPlanEvent(widget.plan.id));
  }

  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                backgroundColor: colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  final newTask = TaskPlan(
                    id: const Uuid().v4(),
                    text: controller.text.trim(),
                    status: TaskPlanStatus.toDo,
                  );
                  // ✅ البلوك هيتكفل بالتحديث
                  context.read<PlanBloc>().add(
                    AddTaskToPlanEvent(planId: widget.plan.id, task: newTask),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            PlanDetailsHeader(
              onBack: () {
                Navigator.pop(context); // ❌ بدون true — مش محتاج
              },
              onMore: () {},
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: BlocBuilder<PlanBloc, PlanState>(
                  builder: (context, state) {
                    if (state is TasksLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is PlanAndTasksLoaded) {
                      final currentPlan = state.plans.firstWhere(
                            (p) => p.id == widget.plan.id,
                        orElse: () => widget.plan, // fallback
                      );
                      final tasks = state.tasks;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PlanDetailsTitleDescription(plan: currentPlan),
                          const SizedBox(height: 16),

                          // ✅ Progress bar
                          PlanDetailsProgress(tasks: tasks),
                          const SizedBox(height: 24),

                          // ✅ Dates
                          PlanDetailsDates(plan: currentPlan),
                          const SizedBox(height: 24),

                          // ✅ Subtasks
                          PlanDetailsSubtasks(
                            plan: currentPlan,
                            onAddTask: _showAddTaskDialog,
                            subTaskCardBuilder: (context, task) =>
                                PlanDetailsSubtaskCard(
                                  plan: currentPlan,
                                  task: task,
                                ),
                          ),
                        ],
                      );
                    } else if (state is TaskError) {
                      return Center(
                        child: Text("Error: ${state.message}",
                            style: const TextStyle(color: Colors.red)),
                      );
                    }
                    return const Center(child: Text("No data available."));
                  },
                ),
              ),
            ),
            PlanDetailsBottomButton(
              onEdit: () async {
                final updatedPlan =
                await navigateToScreenWithSlideTransition(
                  context,
                  UpdatePlanScreen(plan: widget.plan),
                );

                if (updatedPlan != null &&
                    updatedPlan is PlanDetails &&
                    mounted) {
                  // ✅ البلوك فقط اللي يحدث
                  context.read<PlanBloc>().add(UpdatePlanEvent(updatedPlan));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
