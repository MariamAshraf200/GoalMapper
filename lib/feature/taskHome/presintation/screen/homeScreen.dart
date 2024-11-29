import 'package:flutter/material.dart';
import 'package:mapper_app/feature/taskHome/presintation/screen/doneScreen.dart';
import 'package:mapper_app/feature/taskHome/presintation/screen/todoScreen.dart';
import '../Widget/customContainerHome.dart';
import '../Widget/data_format.dart';
import 'AddNewTaskScreen.dart';
import 'inProgressScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  // Placeholder content for each section
  final List<Widget> content = [
    TaskListScreen(),
    InProgressScreen(),
    ReviewScreen(),
    ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top section
          const DataFormat(),
          // Container row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: CustomContainer(
                  label: 'To Do',
                  number: 3,
                  isSelected: selectedIndex == 0,
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                ),
              ),
              Expanded(
                child: CustomContainer(
                  label: 'In Progress',
                  number: 5,
                  isSelected: selectedIndex == 1,
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                ),
              ),
              Expanded(
                child: CustomContainer(
                  label: 'Done',
                  number: 8,
                  isSelected: selectedIndex == 2,
                  onTap: () {
                    setState(() {
                      selectedIndex = 2;
                    });
                  },
                ),
              ),
            ],
          ),
          Expanded(child: content[selectedIndex]),
          const SizedBox(height: 20),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
                bottomRight: Radius.elliptical(50, 50))),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>  AddTaskScreen(),
            ),
          );
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
