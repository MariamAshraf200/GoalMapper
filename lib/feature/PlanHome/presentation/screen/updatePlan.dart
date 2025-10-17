import 'package:flutter/material.dart';
import 'package:mapperapp/l10n/app_localizations.dart';
import '../../domain/entities/plan_entity.dart';
import '../widget/plan_form.dart';


class UpdatePlanScreen extends StatelessWidget {
  const UpdatePlanScreen({super.key, required this.plan});
  final PlanDetails plan;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              tooltip: l10n.close,
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
              l10n.updateTask,
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
      ),
    );
  }
}
