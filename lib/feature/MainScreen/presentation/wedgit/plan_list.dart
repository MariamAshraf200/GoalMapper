import 'package:flutter/material.dart';
import '../wedgit/plan_card.dart';

class PlanList extends StatelessWidget {
  const PlanList({super.key});

  @override
  Widget build(BuildContext context) {
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
}