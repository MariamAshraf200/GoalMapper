import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final String priority;
  final String status;

  const TaskCard({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    required this.priority,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      decoration: status == "Done" ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: priority == "High"
                          ? Colors.red.withOpacity(0.1)
                          : priority == "Medium"
                          ? Colors.orange.withOpacity(0.1)
                          : Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      priority,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: priority == "High"
                            ? Colors.red
                            : priority == "Medium"
                            ? Colors.orange
                            : Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 18,
                  decoration: status == "Done" ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Time: $time",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  decoration: status == "Done" ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
    if (status == "Done")
    Positioned(
    right: 10,
    bottom: 20,
    child: SvgPicture.asset(
    'assets/icons/svgVectors/rightCheckBox.svg', // Path to your SVG file
    width: 24, // Adjust the size as needed
    height: 24,
    ),
            ),
              ],
    );
  }
}