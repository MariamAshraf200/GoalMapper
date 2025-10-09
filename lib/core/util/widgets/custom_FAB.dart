import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mapperapp/feature/PlanHome/presentation/screen/addPlan.dart';
import 'package:mapperapp/feature/taskHome/presintation/screen/add_task_screen.dart';

class CustomFAB extends StatelessWidget {
  final BuildContext context;

  const CustomFAB({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.add_event,
      animatedIconTheme: const IconThemeData(size: 28.0),
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
      visible: true,
      curve: Curves.elasticInOut,
      overlayOpacity: 0.5,
      elevation: 8.0,
      shape: const CircleBorder(),
      children: [

        SpeedDialChild(
          child: const Icon(Icons.event_note, color: Colors.white),
          backgroundColor: Colors.green,
          label: 'Add New Plan',
          labelStyle: const TextStyle(fontSize: 16.0, color: Colors.white),
          labelBackgroundColor: Colors.green,
          onTap: () => _addNewPlan(),
          shape: const CircleBorder(),
          elevation: 4.0,
        ),
        SpeedDialChild(
          child: const Icon(Icons.task, color: Colors.white),
          backgroundColor: Colors.blue,
          label: 'Add New Task',
          labelStyle: const TextStyle(fontSize: 16.0, color: Colors.white),
          labelBackgroundColor: Colors.blue,
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