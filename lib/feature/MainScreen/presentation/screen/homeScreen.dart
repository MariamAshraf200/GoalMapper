import 'package:flutter/material.dart';
import '../../../../core/customColor.dart';
import '../../../taskHome/presintation/screen/taskTrack.dart';
import '../wedgit/taskCardMainScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CustomColor color = CustomColor();
  double taskCompletionPercentage = 0.75;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildSectionTitle("My Tasks", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TaskTrack()),
                    );
                  }),
                  const SizedBox(height: 6),
                  _buildTaskList(),
                  const SizedBox(height: 12),
                  _buildSectionTitle("My Plan", () {}),
                  const SizedBox(height: 6),
                  _buildPlanList(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showAddOptions(context),
      backgroundColor: Colors.deepPurple,
      child: const Icon(Icons.add),
    );
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.task, color: Colors.blue),
              title: const Text('Add New Task'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to Add New Task screen
                _addNewTask();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.event_note, color: Colors.green),
              title: const Text('Add New Plan'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to Add New Plan screen
                _addNewPlan();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addNewTask() {
    // Add logic to navigate to the "Add New Task" screen
    print("Navigate to Add New Task");
  }

  void _addNewPlan() {
    // Add logic to navigate to the "Add New Plan" screen
    print("Navigate to Add New Plan");
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SafeArea(
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Hi Mariam',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications, color: Colors.deepPurple),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.menu, color: Colors.deepPurple),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Today',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '2/10 tasks',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 85,
                        height: 85,
                        child: TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 800),
                          tween:
                          Tween<double>(begin: 0, end: taskCompletionPercentage),
                          builder: (context, value, child) {
                            return CircularProgressIndicator(
                              value: value,
                              strokeWidth: 6,
                              valueColor:
                              const AlwaysStoppedAnimation(Colors.white),
                              backgroundColor: Colors.white.withOpacity(0.2),
                            );
                          },
                        ),
                      ),
                      const CircleAvatar(
                        radius: 35,
                        backgroundImage: AssetImage('assets/images/1.jpg'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, VoidCallback onSeeAllPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: onSeeAllPressed,
          child: const Text(
            'See All',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanList() {
    return Column(
      children: [
        PlanCardCombined(
          title: "Flutter Module",
          daysLeft: 6,
          completeness: 0.1,
          totalDay: 7,
        ),
        const SizedBox(height: 10),
        PlanCardCombined(
          title: "Team Meeting",
          daysLeft: 2,
          completeness: 0.4,
          totalDay: 7,
        ),
      ],
    );
  }

  Widget _buildTaskList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            _buildEnhancedPlanCard(
              "School",
              "Complete homework",
              "8:00 AM",
              "High",
            ),
            const SizedBox(width: 12),
            _buildEnhancedPlanCard(
              "Work",
              "Finish project tasks and meetings.",
              "10:00 AM",
              "Medium",
            ),
            const SizedBox(width: 12),
            _buildEnhancedPlanCard(
              "Personal",
              "Go to the gym and relax.",
              "6:00 PM",
              "Low",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedPlanCard(
      String title, String description, String time, String priority) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: priority == "High"
                      ? Colors.red.withOpacity(0.1)
                      : priority == "Medium"
                      ? Colors.orange.withOpacity(0.1)
                      : Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  priority,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: priority == "High"
                        ? Colors.red
                        : priority == "Medium"
                        ? Colors.orange
                        : Colors.green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Time: $time",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
