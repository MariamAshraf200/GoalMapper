/*import 'package:flutter/material.dart';
import 'package:mapper_app/feature/taskHome/presintation/screen/todoScreen.dart';
import '../Widget/customContainerHome.dart';
import '../Widget/data_format.dart';
import 'allTaskScreen.dart';
import 'inProgressScreen.dart';
import 'doneScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<Widget> _screens = [
    const TaskListScreen(),
    const InProgressScreen(),
    const DoneScreen(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const DataFormat(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AllTasksScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
              child: const Text(
                'See All Tasks',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          // Container row with task status selection
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: CustomContainerHome(
                  label: 'To Do',
                  isSelected: selectedIndex == 0,
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                ),
              ),
              Expanded(
                child: CustomContainerHome(
                  label: 'In Progress',
                  isSelected: selectedIndex == 1,
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                ),
              ),
              Expanded(
                child: CustomContainerHome(
                  label: 'Done',
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
          // Display the selected screen based on selectedIndex
          Expanded(
            child: _screens[selectedIndex],
          ),
        ],
      ),
    );
  }
}
*/
