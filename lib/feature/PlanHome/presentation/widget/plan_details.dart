
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapperapp/feature/PlanHome/domain/entities/plan_entity.dart';

import '../../../taskHome/presintation/bloc/taskBloc/bloc.dart';
import '../../../taskHome/presintation/bloc/taskBloc/event.dart';
import 'media.dart';
import 'notes.dart';
import 'overView.dart';

class PlanDetailsScreen extends StatefulWidget {
  final PlanDetails plan;

  const PlanDetailsScreen({super.key, required this.plan});

  @override
  _PlanDetailsScreenState createState() => _PlanDetailsScreenState();
}

class _PlanDetailsScreenState extends State<PlanDetailsScreen> {
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(GetTasksByPlanIdEvent(widget.plan.id));
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
            onPressed: () {},
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

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return OverviewContent(plan: widget.plan);
      case 1:
        return const MediaContent();
      case 2:
        return NotesContent(planId: widget.plan.id);
      default:
        return const SizedBox.shrink();
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
}
