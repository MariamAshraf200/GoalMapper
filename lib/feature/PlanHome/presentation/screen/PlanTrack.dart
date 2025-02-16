import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/plan_entity.dart';
import '../bloc/bloc.dart';
import '../bloc/event.dart';
import '../bloc/state.dart';

class PlanTrackerScreen extends StatefulWidget {
  const PlanTrackerScreen({super.key});

  @override
  State<PlanTrackerScreen> createState() => _PlanTrackerScreenState();
}

class _PlanTrackerScreenState extends State<PlanTrackerScreen> {
  String selectedStatus = "All";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 35.0, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Plans',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.filter_list,
                    color: Colors.deepPurple,
                  ),
                  onPressed: () {
                    _showCategoryFilterDialog(context);
                  },
                ),
              ],
            ),
          ),

          // Status Summary
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatusContainer("Completed", selectedStatus == "Completed"),
                _buildStatusContainer("All", selectedStatus == "All"),
                _buildStatusContainer("Not Completed", selectedStatus == "Not Completed"),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Plan List
          Expanded(
            child: BlocBuilder<PlanBloc, PlanState>(
              builder: (context, state) {
                if (state is PlanLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PlanLoaded) {
                  return _buildPlanList(state.plans);
                } else if (state is PlanError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text("No plans available."));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add Plan Screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatusContainer(String title, bool selected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedStatus = title;
          // Trigger a Bloc event based on the selected status
          if (title == "All") {
            context.read<PlanBloc>().add(GetAllPlansEvent());
          } else if (title == "Completed") {
            context.read<PlanBloc>().add(GetPlansByStatusEvent('completed'));
          } else if (title == "Not Completed") {
            context.read<PlanBloc>().add(GetPlansByStatusEvent('notCompleted'));
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: selected ? Colors.deepPurple : Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: selected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String? selectedCategory;
        return AlertDialog(
          title: const Text('Select Category'),
          content: DropdownButton<String>(
            isExpanded: true,
            hint: const Text('Choose a category'),
            value: selectedCategory,
            items: ['Work', 'Personal', 'Fitness', 'Study']
                .map((category) => DropdownMenuItem(
              value: category,
              child: Text(category),
            ))
                .toList(),
            onChanged: (category) {
              setState(() {
                selectedCategory = category;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedCategory != null) {
                  context
                      .read<PlanBloc>()
                      .add(GetPlansByCategoryEvent(selectedCategory!));
                }
                Navigator.pop(context);
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPlanList(List<PlanDetails> plans) {
    return ListView.builder(
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];
        return Card(
          child: ListTile(
            title: Text(plan.title),
            subtitle: Text(plan.category),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                context.read<PlanBloc>().add(DeletePlanEvent(plan.id));
              },
            ),
            onTap: () {
              // Navigate to Edit Plan Screen
            },
          ),
        );
      },
    );
  }
}