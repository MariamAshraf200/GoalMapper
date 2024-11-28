import 'package:flutter/material.dart';
import '../Widget/build_container.dart';
import '../Widget/data_format.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  // Placeholder content for each section
  final List<String> content = [
    'This is the To Do screen',
    'This is the In Progress screen',
    'This is the Done screen',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          DataFormat(),
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
          const SizedBox(height: 20),
          // Dynamic content based on selectedIndex
          Expanded(
            child: Center(
              child: Text(
                content[selectedIndex],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
