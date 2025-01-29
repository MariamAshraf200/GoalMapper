import 'package:flutter/material.dart';
import 'package:mapperapp/feature/taskHome/domain/entity/taskEntity.dart';
import 'package:mapperapp/feature/taskHome/presintation/screen/taskTrack.dart';
import '../wedgit/plan_list.dart';
import '../wedgit/task_list.dart';

class HomeScreenForm extends StatelessWidget {
  final List<TaskDetails> tasks;

  const HomeScreenForm({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSectionTitle("My Tasks", () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => TaskTrack()));
        }),
        const SizedBox(height: 6),
        TaskList(tasks: tasks),
        const SizedBox(height: 12),
        _buildSectionTitle("My Plan", () {
          print("See All Plans pressed");
        }),
        const SizedBox(height: 6),
        const PlanList(), // Use the PlanList widget
      ],
    );
  }

  Widget _buildSectionTitle(String title, VoidCallback onSeeAllPressed) {
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
          child: const Text(
            'See All',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
