import 'package:flutter/material.dart';

import '../../../../core/customColor.dart';
import '../wedgit/planCard.dart';
import '../wedgit/taskCardMainScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CustomColor color = CustomColor();
  double taskCompletionPercentage = 0.6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: color.additionalColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 70,
                            height: 70,
                            child: CircularProgressIndicator(
                              value: taskCompletionPercentage,
                              strokeWidth: 4,
                              valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                              backgroundColor: color.additionalColor,
                            ),
                          ),
                          const CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage('assets/images/1.jpg'),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Hi Mariam',
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'HoneyPonds',
                          color: color.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'My Task',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'See All',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: ListView(
                            children: const [
                              TaskCardMainScreen(
                                time: "10:00 AM",
                                title: " Flutter ",
                                description: "Make sure to implement all features and test the app .",
                              ),
                              SizedBox(height: 16),
                              TaskCardMainScreen(
                                time: "12:00 PM",
                                title: "Lunch Break",
                                description: "Take a break and have some rest.",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'My Plan',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'See All',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'School',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    PlanItemWidget(planItem: PlanItem(title: "Go to school")),
                                    PlanItemWidget(planItem: PlanItem(title: "Write my homework")),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Plan 2
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Work',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    PlanItemWidget(planItem: PlanItem(title: "Attend meeting")),
                                    PlanItemWidget(planItem: PlanItem(title: "Prepare presentation")),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
