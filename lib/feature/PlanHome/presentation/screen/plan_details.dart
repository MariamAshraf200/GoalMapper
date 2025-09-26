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
  late PlanDetails plan;

  @override
  void initState() {
    super.initState();
    plan = widget.plan;

    // 🔹 Load tasks for this plan
    context.read<PlanBloc>().add(GetAllTasksPlanEvent(plan.id));
  }

  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
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
                backgroundColor: Colors.deepPurple,
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
                  context.read<PlanBloc>().add(
                    AddTaskToPlanEvent(planId: plan.id, task: newTask),
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
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            PlanDetailsHeader(
              onBack: () {
                Navigator.pop(context, plan);
              },
              onMore: () {},
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PlanDetailsTitleDescription(plan: plan),
                    const SizedBox(height: 16),
                    BlocBuilder<PlanBloc, PlanState>(
                      builder: (context, state) {
                        if (state is PlanAndTasksLoaded) {
                          return PlanDetailsProgress(tasks: state.tasks);
                        } else if (state is TasksLoading) {
                          return const LinearProgressIndicator();
                        }
                        return PlanDetailsProgress(tasks: []);
                      },
                    ),
                    const SizedBox(height: 24),
                    PlanDetailsDates(plan: plan),
                    const SizedBox(height: 24),
                    PlanDetailsSubtasks(
                      plan: plan,
                      onAddTask: _showAddTaskDialog,
                      subTaskCardBuilder: (context, task) => PlanDetailsSubtaskCard(plan: plan, task: task),
                    ),
                  ],
                ),
              ),
            ),
            PlanDetailsBottomButton(
              onEdit: () async {
                final updatedPlan = await navigateToScreenWithSlideTransition(
                  context,
                  UpdatePlanScreen(plan: plan),
                  // Optionally: beginOffset: Offset(1, 0),
                  // transitionDuration: Duration(milliseconds: 500),
                );
                if (updatedPlan != null && updatedPlan is PlanDetails && mounted) {
                  setState(() {
                    plan = updatedPlan;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
