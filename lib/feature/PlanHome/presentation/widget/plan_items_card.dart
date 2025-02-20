import 'package:flutter/material.dart';
import 'package:mapperapp/feature/PlanHome/domain/entities/plan_entity.dart';
import 'package:mapperapp/feature/PlanHome/presentation/widget/plan_details.dart';



class PlanItemCard extends StatelessWidget {
  final PlanDetails plan;

  const PlanItemCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlanDetailsScreen(plan: plan),
          ),
        );
      },
      child: Card(
        elevation: 6,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom Header with Clipper
            ClipPath(
              clipper: WavyClipper(),
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                  color: plan.completed ? Colors.green : Colors.orange,
                ),
                child: Center(
                  child: Text(
                    plan.completed ? "COMPLETED" : "NOT COMPLETED",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            // Main Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    plan.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Date and Priority
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 16, color: Colors.grey[700]),
                      const SizedBox(width: 8),
                      Text(
                        "${plan.startDate} - ${plan.endDate}",
                        style:
                        Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.priority_high,
                        size: 16,
                        color: plan.priority == "High"
                            ? Colors.red
                            : Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        plan.priority,
                        style:
                        Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: plan.priority == "High"
                              ? Colors.red
                              : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class WavyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(
      size.width / 4, size.height,
      size.width / 2, size.height - 20,
    );
    path.quadraticBezierTo(
      size.width * 3 / 4, size.height - 40,
      size.width, size.height - 20,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
