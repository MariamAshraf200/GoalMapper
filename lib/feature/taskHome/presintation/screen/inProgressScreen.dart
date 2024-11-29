
import 'package:flutter/material.dart';

class InProgressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(

      body: Center(
        child: Text(
          "No tasks in progress yet.",
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}
