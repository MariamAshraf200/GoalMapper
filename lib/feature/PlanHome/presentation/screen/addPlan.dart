import 'package:flutter/material.dart';
import '../widget/plan_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc.dart';
import '../bloc/event.dart';

class AddPlanScreen extends StatelessWidget {
  const AddPlanScreen({super.key});

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
              'Create New Plan',
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
        isUpdate: false,
        onSubmit: (plan) {
          context.read<PlanBloc>().add(AddPlanEvent(plan));

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Plan added successfully!')),
          );

          // ✅ مش محتاج تبعت true
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
