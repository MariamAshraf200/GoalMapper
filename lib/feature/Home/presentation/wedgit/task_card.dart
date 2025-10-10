import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final String priority;
  final String status;
  final VoidCallback? onEnter;

  const TaskCard({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    required this.priority,
    required this.status,
    this.onEnter,
  });

  @override
  Widget build(BuildContext context) {
    Color titleColor;
    Color descColor;
    Color timeColor;
    TextDecoration decoration;
    Color borderColor;

    switch (status.trim().toLowerCase()) {
      case "done":
        borderColor = Colors.green.shade300;
        titleColor = Colors.green;
        descColor = Colors.green;
        timeColor = Colors.green;
        decoration = TextDecoration.lineThrough;
        break;
      case "pending":
        borderColor = Colors.orange.shade300;
        titleColor = Colors.orange;
        descColor = Colors.orange;
        timeColor = Colors.orange;
        decoration = TextDecoration.none;
        break;
      case "missed":
        borderColor = Colors.red.shade300;
        titleColor = Colors.red;
        descColor = Colors.red;
        timeColor = Colors.red;
        decoration = TextDecoration.none;
        break;
      default:
        borderColor = Colors.grey.withAlpha(30);
        titleColor = Colors.black;
        descColor = Colors.black;
        timeColor = Colors.grey;
        decoration = TextDecoration.none;
    }

    return Stack(
      children: [
        Focus(
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
              if (onEnter != null) {
                onEnter!();
              }
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: onEnter,
            child: Container(
              width: 220,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha( 10),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(
                  color: borderColor,
                  width: 1.2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: titleColor,
                            decoration: decoration,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: priority == "High"
                              ? Colors.red.withAlpha(30)
                              : priority == "Medium"
                              ? Colors.orange.withAlpha(30)
                              : Colors.green.withAlpha(30),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          priority,
                          style: TextStyle(
                            fontSize: 13,
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
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 15,
                      color: descColor,
                      decoration: decoration,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: timeColor),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          time.isNotEmpty ? time : "No time",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: timeColor,
                            decoration: decoration,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}