import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mapperapp/feature/MainScreen/presentation/wedgit/plan_card.dart';
import '../../../PlanHome/presentation/bloc/bloc.dart';
import '../../../PlanHome/presentation/bloc/state.dart';

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
        } else if (state is PlanLoaded) {
          final plans = state.plans;

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

                // Parse start and end dates with error handling
                DateTime? startDate, endDate;
                try {
                  startDate = DateFormat('dd/MM/yyyy').parse(plan.startDate);
                  endDate = DateFormat('dd/MM/yyyy').parse(plan.endDate);
                } catch (e) {
                  debugPrint("Invalid date format for plan: ${plan.title}");
                }

                // Calculate daysLeft and totalDays
                final daysLeft = endDate?.difference(DateTime.now()).inDays ?? 0;
                final totalDays = (startDate != null && endDate != null)
                    ? endDate.difference(startDate).inDays
                    : 0;

                // Calculate completeness
                final totalTasks = plan.tasks.length;
                final completedTasks = plan.tasks
                    .where((task) => task.status == "done")
                    .length;
                final completeness =
                totalTasks > 0 ? (completedTasks / totalTasks) : 0.0;

                // Render fallback card for invalid data
                if (startDate == null || endDate == null || totalDays <= 0) {
                  return PlanCardCombined(
                    title: plan.title,
                    daysLeft: 0,
                    totalDay: 0,
                    completeness: 0.0,
                  );
                }

                // Valid plan card rendering
                return PlanCardCombined(
                  title: plan.title,
                  daysLeft: daysLeft < 0 ? 0 : daysLeft, // Avoid negatives
                  totalDay: totalDays,
                  completeness: completeness,
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
