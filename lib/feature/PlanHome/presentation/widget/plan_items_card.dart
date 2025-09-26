import 'package:flutter/material.dart';
import '../../domain/entities/plan_entity.dart';
import '../screen/plan_details.dart'; // 👈 استورد شاشة التفاصيل

class PlanItemCard extends StatelessWidget {
  final PlanDetails plan;
  final VoidCallback? onTap;

  const PlanItemCard({super.key, required this.plan, this.onTap});

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case "work":
        return Colors.purple.shade200;
      case "personal":
        return Colors.blue.shade200;
      case "study":
        return Colors.amber.shade200;
      case "health":
        return Colors.pink.shade200;
      default:
        return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        if (onTap != null) {
          onTap!();
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PlanDetailsScreen(plan: plan), // 👈 ابعت plan
          ),
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
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  if (plan.category != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(plan.category!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        plan.category!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 8),

              // 🔹 Description
              if (plan.description != null && plan.description!.isNotEmpty)
                Text(
                  plan.description!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

              const SizedBox(height: 12),

              // 🔹 Bottom row (date + status)
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.deepPurple),
                  const SizedBox(width: 6),
                  Text(
                    plan.endDate ?? "",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    plan.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: plan.isCompleted ? Colors.green : Colors.orange,
                    size: 18,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
