import 'package:flutter/material.dart';
import '../Widget/customContainerTask.dart';

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            "You have 3 Tasks",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          TaskCard(
            title: "Buy Groceries",
            description: "Need to buy milk, bread, and eggs.",
            date: "29/11/2024",
            time: "10:00 AM",
            priority: "High",
            priorityColor: Colors.red,
            onClicked: () {
            },
          ),
          TaskCard(
            title: "Morning Jog",
            description: "Complete a 5km jog in the park.",
            date: "29/11/2024",
            time: "06:30 AM",
            priority: "Medium",
            priorityColor: Colors.orange,
            onClicked: () {

            },
          ),
        ],
      ),
    );
  }
}
