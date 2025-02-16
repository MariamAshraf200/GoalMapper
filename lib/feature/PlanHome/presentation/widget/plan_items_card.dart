import 'package:flutter/material.dart';
import '../../domain/entities/plan_entity.dart';

class PlanItemCard extends StatelessWidget {
  final PlanDetails plan;

  const PlanItemCard({
    super.key,
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: PlanClipper(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(16.0),
              color: plan.completed ? Colors.green : Colors.blue,
              child: Text(
                plan.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Image Section (if available)
            if (plan.image != null)
              Image.network(
                plan.image!,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            // Details Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        "Start: ${plan.startDate}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "End: ${plan.endDate}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Priority: ${plan.priority}",
                    style: TextStyle(
                      fontSize: 14,
                      color: plan.priority == "High"
                          ? Colors.red
                          : Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Category: ${plan.category}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        "Status: ${plan.status}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      if (plan.completed)
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 18,
                        )
                      else
                        const Icon(
                          Icons.circle_outlined,
                          color: Colors.red,
                          size: 18,
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

class PlanClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width / 2, size.height - 20, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
