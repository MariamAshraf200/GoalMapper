import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mapperapp/feature/PlanHome/domain/entities/plan_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../taskHome/presintation/bloc/taskBloc/bloc.dart';
import '../../../taskHome/presintation/bloc/taskBloc/event.dart';
import '../../../taskHome/presintation/bloc/taskBloc/state.dart';
import '../../../taskHome/presintation/screen/add_task_screen.dart';

class PlanDetailsScreen extends StatefulWidget {
  final PlanDetails plan;

  const PlanDetailsScreen({Key? key, required this.plan}) : super(key: key);

  @override
  _PlanDetailsScreenState createState() => _PlanDetailsScreenState();
}

class _PlanDetailsScreenState extends State<PlanDetailsScreen> {
  int _selectedTabIndex = 0;
  List<String> _notes = [];

  @override
  void initState() {
    super.initState();
    // Dispatch the event to fetch tasks for the current plan
    context.read<TaskBloc>().add(GetTasksByPlanIdEvent(widget.plan.id));
    _loadNotes(); // Load notes from SharedPreferences
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notes = prefs.getStringList('notes_${widget.plan.id}') ?? [];
    });
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('notes_${widget.plan.id}', _notes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Colored dot
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getStatusColor(widget.plan.status),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              widget.plan.status,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Filter functionality to be implemented here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.plan.title,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoCard(
                  icon: Icons.event_available,
                  label: "End Date",
                  value: widget.plan.endDate,
                  iconColor: Colors.blue,
                ),
                const SizedBox(width: 16),
                _buildInfoCard(
                  icon: Icons.flag,
                  label: "Priority",
                  value: widget.plan.priority,
                  iconColor: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTabButton("Overview", 0),
                _buildTabButton("Media", 1),
                _buildTabButton("Notes", 2),
              ],
            ),
            const SizedBox(height: 16),
            _buildTabContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesContent() {
    return Column(
      children: [
        // Add Note Button
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: const Icon(Icons.add, color: Colors.deepPurple),
            onPressed: () {
              _showAddNoteDialog(context); // Open dialog to add a note
            },
          ),
        ),
        // List of Notes
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _notes.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                title: Text(_notes[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _notes.removeAt(index); // Remove note from the list
                      _saveNotes(); // Save updated notes
                    });
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    final TextEditingController _noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add a Note"),
          content: TextFormField(
            controller: _noteController,
            decoration: const InputDecoration(
              hintText: "Write your note here...",
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_noteController.text.isNotEmpty) {
                  setState(() {
                    _notes.add(_noteController.text); // Add note to the list
                    _saveNotes(); // Save updated notes
                  });
                  Navigator.pop(context); // Close the dialog
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Not Completed":
        return Colors.orange;
      case "Completed":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildTabButton(String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: _selectedTabIndex == index ? Colors.deepPurple.shade100 : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: _selectedTabIndex == index ? Colors.deepPurple : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildOverviewContent();
      case 1:
        return _buildMediaContent();
      case 2:
        return _buildNotesContent();
      default:
        return const SizedBox.shrink();
    }
  }
  Widget _buildOverviewContent() {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TaskLoaded) {
          final tasks = state.tasks;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Description and Category Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Description",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.plan.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Category",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.plan.category,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Tasks Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tasks",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddTaskScreen(planId: widget.plan.id),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: tasks.map((task) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: task.status == 'Done',
                                    onChanged: (value) {
                                      context.read<TaskBloc>().add(
                                        UpdateTaskStatusEvent(
                                          task.id,
                                          value! ? 'Done' : 'to do',
                                          updatedTime: '',
                                        ),
                                      );
                                    },
                                  ),
                                  Text(
                                    task.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                      decoration: task.status == 'Done'
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  context.read<TaskBloc>().add(
                                    DeleteTaskEvent(task.id),
                                  );
                                },
                                icon: const Icon(Icons.close, color: Colors.red),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else if (state is TaskError) {
          return Center(
            child: Text("Failed to load tasks: ${state.message}"),
          );
        } else {
          return const Center(child: Text("No tasks available"));
        }
      },
    );
  }



  Widget _buildMediaContent() {
    return const Center(child: Text("Media files will be displayed here."));
  }

}
