import 'package:flutter/material.dart';
import 'package:mapperapp/l10n/l10n_extension.dart';
import '../../../PlanHome/presentation/screen/PlanTrack.dart';
import '../../../taskHome/domain/entity/taskEntity.dart';
import '../../../taskHome/presintation/screen/taskTrack.dart';
import '../wedgit/plan_list.dart';
import '../wedgit/task_list.dart';

class HomeScreenForm extends StatelessWidget {
  final List<TaskDetails> tasks;

  const HomeScreenForm({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        _buildSectionTitle(context, l10n.myTasks, () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => TaskTrack()));
        }),
        const SizedBox(height: 6),
        TaskList(tasks: tasks),
        const SizedBox(height: 12),
        _buildSectionTitle(context, l10n.myPlan, () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => PlanTrackerScreen()));
        }),
        const SizedBox(height: 6),
        const PlanList(),
        const SizedBox(height: 40),

      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, VoidCallback onSeeAllPressed) {
    final l10n = context.l10n;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: onSeeAllPressed,
          child: Text(
            l10n.seeAll,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
