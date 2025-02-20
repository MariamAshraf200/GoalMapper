import 'package:flutter/material.dart';
import 'package:mapperapp/feature/PlanHome/presentation/widget/plan_items_card.dart';

import '../../domain/entities/plan_entity.dart';

class PlanItems extends StatefulWidget {
  const PlanItems({super.key});

  @override
  State<PlanItems> createState() => _PlanItemsState();
}

class _PlanItemsState extends State<PlanItems> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  List<PlanDetails> plans = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _fetchPlans();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      // Load more data if needed
    }
  }

  Future<void> _fetchPlans() async {
    // Simulate a delay to mimic API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      plans = [
        PlanDetails(
          id: '1',
          title: 'Plan A',
          description: 'Description of Plan A',
          startDate: '2025-02-15',
          endDate: '2025-02-20',
          priority: 'High',
          category: 'Work',
          status: 'Not Completed',
          completed: false,
        ),
        PlanDetails(
          id: '2',
          title: 'Plan B',
          description: 'Description of Plan B',
          startDate: '2025-02-10',
          endDate: '2025-02-12',
          priority: 'Low',
          category: 'Personal',
          status: 'Completed',
          completed: true,
        ),
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : plans.isEmpty
        ? const Center(child: Text('No plans available.'))
        : ListView.builder(
      padding: const EdgeInsets.all(16.0),
      controller: _scrollController,
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: PlanItemCard(plan: plan),
        );
      },
    );
  }
}
