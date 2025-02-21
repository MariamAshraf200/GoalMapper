import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapperapp/feature/PlanHome/domain/entities/plan_entity.dart';
import 'package:mapperapp/feature/PlanHome/presentation/widget/plan_details.dart';

import '../bloc/bloc.dart';
import '../bloc/event.dart';
class PlanItemCard extends StatelessWidget {
  final PlanDetails plan;

  const PlanItemCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlanDetailsScreen(plan: plan),
          ),
        );
      },
      child: Dismissible(
        key: Key(plan.id), // Ensure a unique key for each plan
        background: _buildSwipeBackground(
          color: Colors.blue,
          icon: Icons.edit,
          label: "Update",
          alignment: Alignment.centerLeft,
        ),
        secondaryBackground: _buildSwipeBackground(
          color: Colors.red,
          icon: Icons.delete,
          label: "Delete",
          alignment: Alignment.centerRight,
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            BlocProvider.of<PlanBloc>(context).add(UpdatePlanEvent(
              plan.copyWith(completed: true),
            ));
            _showSnackbar(context, "Plan marked as completed.");
            return false; // Prevent dismissal
          } else if (direction == DismissDirection.endToStart) {
            return await _confirmDelete(context);
          }
          return false;
        },
        child: Card(
          elevation: 6,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Header with Clipper
              ClipPath(
                clipper: WavyClipper(),
                child: Container(
                  height: 90,
                  decoration: BoxDecoration(
                    color: plan.completed ? Colors.green : Colors.orange,
                  ),
                  child: Center(
                    child: Text(
                      plan.completed ? "COMPLETED" : "NOT COMPLETED",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              // Main Content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      plan.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Date and Priority
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 16, color: Colors.grey[700]),
                        const SizedBox(width: 8),
                        Text(
                          "${plan.startDate} - ${plan.endDate}",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                            color: Colors.grey[700],
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.priority_high,
                          size: 16,
                          color: plan.priority == "High"
                              ? Colors.red
                              : Colors.orange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          plan.priority,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                            color: plan.priority == "High"
                                ? Colors.red
                                : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build swipe background for dismiss actions
  Widget _buildSwipeBackground({
    required Color color,
    required IconData icon,
    required String label,
    required Alignment alignment,
  }) {
    return Container(
      color: color,
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: alignment == Alignment.centerLeft
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Confirm delete dialog
  Future<bool> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this plan?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Delete"),
          ),
        ],
      ),
    ) ??
        false;

    if (shouldDelete) {
      BlocProvider.of<PlanBloc>(context).add(DeletePlanEvent(plan.id));
      _showSnackbar(context, "Plan deleted successfully.");
    }
    return shouldDelete;
  }

  // Show Snackbar
  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class WavyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(
      size.width / 4,
      size.height,
      size.width / 2,
      size.height - 20,
    );
    path.quadraticBezierTo(
      size.width * 3 / 4,
      size.height - 40,
      size.width,
      size.height - 20,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
