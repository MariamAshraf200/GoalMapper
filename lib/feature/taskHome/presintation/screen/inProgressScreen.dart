import 'package:flutter/material.dart';
class InProgressScreen extends StatelessWidget {

  const InProgressScreen({Key? key,}) : super(key: key);

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