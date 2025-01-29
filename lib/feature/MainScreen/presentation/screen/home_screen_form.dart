import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapperapp/feature/taskHome/presintation/bloc/taskBloc/event.dart';
import 'package:mapperapp/feature/taskHome/presintation/screen/taskTrack.dart';
import '../../../taskHome/presintation/bloc/taskBloc/bloc.dart';
import '../wedgit/plan_list.dart';
import '../wedgit/task_list.dart';

class HomeScreenForm extends StatelessWidget {
  const HomeScreenForm({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<TaskBloc>().add(FilterTasksEvent(date: DateTime.now().toIso8601String(), status: 'to do'));

    return Column(
      children: [
        _buildSectionTitle("My Tasks", () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => TaskTrack()));
        }),
        const SizedBox(height: 6),
        const TaskList(), // Use the TaskList widget
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