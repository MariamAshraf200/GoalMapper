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
    final colorScheme = Theme.of(context).colorScheme;
    Color titleColor;
    Color descColor;
    Color timeColor;
    TextDecoration decoration;
    Color borderColor;

    switch (status.trim().toLowerCase()) {
      case "done":
        borderColor = colorScheme.primaryContainer;
        titleColor = colorScheme.primary;
        descColor = colorScheme.primary;
        timeColor = colorScheme.primary;
        decoration = TextDecoration.lineThrough;
        break;
      case "pending":
        borderColor = colorScheme.secondaryContainer;
        titleColor = colorScheme.secondary;
        descColor = colorScheme.secondary;
        timeColor = colorScheme.secondary;
        decoration = TextDecoration.none;
        break;
      case "missed":
        borderColor = colorScheme.errorContainer;
        titleColor = colorScheme.error;
        descColor = colorScheme.error;
        timeColor = colorScheme.error;
        decoration = TextDecoration.none;
        break;
      default:
        borderColor = colorScheme.outline.withAlpha(50);
        titleColor = colorScheme.onSurface;
        descColor = colorScheme.onSurface;
        timeColor = colorScheme.outline;
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
                    color: colorScheme.shadow.withAlpha(20),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(
                  color: borderColor,
                  width: 10,
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
                              ? colorScheme.errorContainer
                              : priority == "Medium"
                              ? colorScheme.secondaryContainer
                              : colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          priority,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: priority == "High"
                                ? colorScheme.error
                                : priority == "Medium"
                                ? colorScheme.secondary
                                : colorScheme.primary,
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