import 'package:flutter/material.dart';

import '../../domain/entities/plan_entity.dart';
import '../widget/update_plan_form.dart';


class UpdatePlanScreen extends StatelessWidget {
  const UpdatePlanScreen({super.key, required this.plan});
  final PlanDetails plan;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              tooltip: "Close",
              icon: Icon(
                Icons.close,
                color: Colors.red[400],
                size: 35,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const Spacer(), // Push the text to the center
            Text(
              'Update Your Plan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const Spacer(), // Balances the spacing on the right
          ],
        ),
      ),

      body:  UpdatePlanForm(plan: plan,),

    );
  }
}


