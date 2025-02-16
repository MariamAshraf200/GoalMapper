import 'package:flutter/material.dart';
import 'package:mapperapp/feature/PlanHome/presentation/widget/plan_items_card.dart';

import '../../domain/entities/plan_entity.dart';


class PlanItems extends StatefulWidget {
  const PlanItems({
    super.key,
    required this.plans,
  });

  final List<PlanDetails> plans;

  @override
  State<PlanItems> createState() => _PlanItemsState();
}

class _PlanItemsState extends State<PlanItems> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      // Trigger pagination or load more plans
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      controller: _scrollController,
      itemCount: widget.plans.length,
      itemBuilder: (context, index) {
        final plan = widget.plans[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: PlanItemCard(plan: plan),
        );
      },
    );
  }
}
