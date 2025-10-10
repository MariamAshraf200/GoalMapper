import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mapperapp/feature/PlanHome/presentation/screen/addPlan.dart';
import 'package:mapperapp/feature/taskHome/presintation/screen/add_task_screen.dart';

class CustomFAB extends StatelessWidget {
  final BuildContext context;

  const CustomFAB({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SpeedDial(
      animatedIcon: AnimatedIcons.add_event,
      animatedIconTheme: const IconThemeData(size: 28.0),
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      visible: true,
      curve: Curves.elasticInOut,
      overlayOpacity: 0.5,
      elevation: 8.0,
      shape: const CircleBorder(),
      children: [

        SpeedDialChild(
          child: Icon(Icons.event_note, color: colorScheme.onSecondary),
          backgroundColor: colorScheme.secondary,
          label: 'Add New Plan',
          labelStyle: TextStyle(fontSize: 16.0, color: colorScheme.onSecondary),
          labelBackgroundColor: colorScheme.secondary,
          onTap: () => _addNewPlan(),
          shape: const CircleBorder(),
          elevation: 4.0,
        ),
        SpeedDialChild(
          child: Icon(Icons.task, color: colorScheme.onPrimary),
          backgroundColor: colorScheme.primary,
          label: 'Add New Task',
          labelStyle: TextStyle(fontSize: 16.0, color: colorScheme.onPrimary),
          labelBackgroundColor: colorScheme.primary,
          onTap: () => _addNewTask(),
          shape: const CircleBorder(),
          elevation: 4.0,
        ),
      ],
    );
  }

  void _addNewTask() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskScreen()),
    );
  }

  void _addNewPlan() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddPlanScreen(),));
  }
}