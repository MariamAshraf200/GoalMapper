import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapperapp/l10n/l10n_extension.dart';
import '../../../PlanHome/presentation/bloc/bloc.dart';
import '../../../PlanHome/presentation/bloc/state.dart';
import '../../../PlanHome/domain/entities/taskPlan.dart';
import 'plan_card.dart';

class PlanList extends StatelessWidget {
  const PlanList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlanBloc, PlanState>(
      builder: (context, state) {
        if (state is PlanLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is PlanLoaded || state is PlanAndTasksLoaded) {
          final plans = state is PlanLoaded ? state.plans : (state as PlanAndTasksLoaded).plans;

          if (plans.isEmpty) {
            return Center(
              child: Text(
                context.l10n.noPlansAvailable,
                style: const TextStyle(fontSize: 16),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: plans.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final plan = plans[index];

                // Pass raw end date and raw time to the card; the card will format using util functions
                final tasks = plan.tasks.cast<TaskPlan>();

                return PlanCardCombined(
                  id: plan.id,
                  title: plan.title,
                  tasks: tasks,
                  endDateRaw: plan.endDate,
                  updatedTimeRaw: plan.updatedTime,
                );
              },
            ),
          );
        } else if (state is PlanError) {
          return Center(
            child: Text(
              context.l10n.failedToLoadPlans,
              style: const TextStyle(fontSize: 16),
            ),
          );
        } else {
          return Center(
            child: Text(
              context.l10n.somethingWentWrong,
              style: const TextStyle(fontSize: 16),
            ),
          );
        }
      },
    );
  }
}
