import 'package:flutter/material.dart';


class DoneScreen extends StatelessWidget {

  DoneScreen({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("In Progress Tasks"),
      ),
      body: Text('progress'),
    );
  }
}
