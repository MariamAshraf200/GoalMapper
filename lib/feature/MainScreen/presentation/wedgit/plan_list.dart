import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapperapp/feature/MainScreen/presentation/wedgit/plan_card.dart';
import '../../../PlanHome/presentation/bloc/bloc.dart';
import '../../../PlanHome/presentation/bloc/state.dart';
import '../../../PlanHome/domain/entities/taskPlan.dart'; // 👈 عشان TaskPlan

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
            return const Center(
              child: Text(
                "No plans available.",
                style: TextStyle(fontSize: 16),
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
                  title: plan.title,
                  tasks: tasks,
                  endDateRaw: plan.endDate,
                  updatedTimeRaw: plan.updatedTime,
                );
              },
            ),
          );
        } else if (state is PlanError) {
          return const Center(
            child: Text(
              "Failed to load plans. Please try again later.",
              style: TextStyle(fontSize: 16),
            ),
          );
        } else {
          return const Center(
            child: Text(
              "Something went wrong.",
              style: TextStyle(fontSize: 16),
            ),
          );
        }
      },
    );
  }
}
