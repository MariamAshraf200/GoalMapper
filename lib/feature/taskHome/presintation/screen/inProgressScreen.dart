
import 'package:flutter/material.dart';

class InProgressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("In Progress Tasks"),
        backgroundColor: Colors.deepPurple,
      ),
      body: const Center(
        child: Text(
          "No tasks in progress yet.",
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}
