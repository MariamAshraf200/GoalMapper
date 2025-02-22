import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../taskHome/presintation/bloc/catogeryBloc/CatogeryBloc.dart';
import '../../../taskHome/presintation/bloc/catogeryBloc/Catogeryevent.dart';
import '../../../taskHome/presintation/bloc/catogeryBloc/Catogerystate.dart';
import '../bloc/bloc.dart';
import '../bloc/event.dart';
import '../bloc/state.dart';
import '../widget/plan_items.dart';


class PlanTrackerScreen extends StatefulWidget {
  const PlanTrackerScreen({super.key});

  @override
  State<PlanTrackerScreen> createState() => _PlanTrackerScreenState();
}

class _PlanTrackerScreenState extends State<PlanTrackerScreen> {
  String selectedStatus = "All";
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(LoadCategoriesEvent());
  }

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
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryLoading) {
                      return const CircularProgressIndicator();
                    } else if (state is CategoryLoaded) {
                      final categories = state.categories;
                      return PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.filter_list,
                          color: Colors.deepPurple,
                        ),
                        onSelected: (category) {
                          setState(() {
                            selectedCategory = category;
                          });
                          if (category == "All") {
                            context.read<PlanBloc>().add(GetAllPlansEvent());
                          } else {
                            context.read<PlanBloc>().add(GetPlansByCategoryEvent(category));
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: "All",
                            child: Text("All Categories"),
                          ),
                          ...categories.map((category) {
                            return PopupMenuItem(
                              value: category.categoryName,
                              child: Text(category.categoryName),
                            );
                          }),
                        ],
                      );
                    } else if (state is CategoryError) {
                      return Text(state.message, style: const TextStyle(color: Colors.red));
                    } else {
                      return const Text("No categories available.");
                    }
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
                 return PlanItems();
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
          if (title == "All") {
            context.read<PlanBloc>().add(GetAllPlansEvent());
          } else if (title == "Completed") {
            context.read<PlanBloc>().add(GetPlansByStatusEvent('Completed'));
          } else if (title == "Not Completed") {
            context.read<PlanBloc>().add(GetPlansByStatusEvent('Not Completed'));
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
            ),
          ],
        ),
      ),
    );
  }
}
