import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapperapp/l10n/app_localizations.dart';
import '../../../../core/util/custom_builders/navigate_to_screen.dart';
import '../../domain/entities/plan_entity.dart';
import '../bloc/bloc.dart';
import '../bloc/event.dart';
import '../screen/plan_details.dart';

class PlanItemCard extends StatefulWidget {
  final PlanDetails plan;
  final VoidCallback? onTap;

  const PlanItemCard({super.key, required this.plan, this.onTap});

  @override
  State<PlanItemCard> createState() => _PlanItemCardState();
}

class _PlanItemCardState extends State<PlanItemCard> {
  @override
  Widget build(BuildContext context) {
    final plan = widget.plan;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Dismissible(
      key: Key(plan.id),
      direction: DismissDirection.horizontal,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        color: Colors.red,
        child: Row(
          children: [
            Icon(Icons.delete, color: Colors.white),
            const SizedBox(width: 8),
            Text(l10n.deleteOperation,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.edit, color: Colors.white),
            const SizedBox(width: 8),
            Text(l10n.updateOperation,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // ✅ Delete
          final shouldDelete = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(l10n.deletePlan),
              content: Text(l10n.deletePlanDescription),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: Text(l10n.cancel)),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text(l10n.deleteOperation,
                      style: const TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
          if (shouldDelete == true) {
            BlocProvider.of<PlanBloc>(context).add(DeletePlanEvent(plan.id));
            return true;
          }
          return false;
        } else if (direction == DismissDirection.endToStart) {
          await navigateToScreenWithSlideTransition(
            context,
            PlanDetailsScreen(plan: plan),
          );
          return false;
        }
        return false;
      },
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap!();
            return;
          }
          navigateToScreenWithSlideTransition(
            context,
            PlanDetailsScreen(plan: plan),
          );
        },
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Title + Category Badge
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        plan.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorScheme.secondary.withAlpha((0.2 * 255).round()),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        plan.category,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // 🔹 Description
                if (plan.description.isNotEmpty)
                  Text(
                    plan.description,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                const SizedBox(height: 12),

                // 🔹 Bottom row (date + status)
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 16, color: colorScheme.secondary),
                    const SizedBox(width: 6),
                    Text(
                      plan.endDate,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          plan.completed
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: plan.completed ? Colors.green : Colors.orange,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          plan.completed ? l10n.planCompleted : l10n.planNotCompleted,
                          style: TextStyle(
                            fontSize: 12,
                            color: plan.completed ? Colors.green : Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
