import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/plan_entity.dart';
import '../widget/plan_form.dart';
import '../bloc/bloc.dart';
import '../bloc/event.dart';

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
            const Spacer(),
            Text(
              'Update Your Plan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      body: PlanForm(
        isUpdate: true,
        initialPlan: plan,
        onSubmit: (updatedPlan) {
          context.read<PlanBloc>().add(UpdatePlanEvent(updatedPlan));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Plan updated successfully!')),
          );

          // ✅ مش محتاج تبعت الـ plan
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
