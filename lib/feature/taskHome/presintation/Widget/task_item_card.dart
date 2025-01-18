import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapperapp/feature/taskHome/presintation/Widget/task_time_column.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/widgets/custom_card.dart';
import '../../domain/entity/taskEntity.dart';
import '../bloc/taskBloc/bloc.dart';
import '../bloc/taskBloc/event.dart';

class TaskItemCard extends StatefulWidget {
  final TaskDetails task;

  const TaskItemCard({super.key, required this.task});

  @override
  _TaskItemCardState createState() => _TaskItemCardState();
}

class _TaskItemCardState extends State<TaskItemCard>
    with SingleTickerProviderStateMixin {
  late bool isCompleted;

  @override
  void initState() {
    super.initState();
    isCompleted = widget.task.status == 'to do';

  }
  void toggleCompletion() {
    final newStatus = isCompleted ? 'to do' : 'Done';

    // Dispatch event to update the status
    context.read<TaskBloc>().add(UpdateTaskStatusEvent(widget.task.id, newStatus));

    // Update the UI state
    setState(() {
      isCompleted = !isCompleted;
    });

    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task marked as $newStatus'),
        duration: const Duration(seconds: 1),
      ),
    );
  }



  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return AppColors.defaultBackgroundColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TaskTimeColumn(
          task: widget.task, // Pass the task containing the time
        ),
        const SizedBox(width: 8),
        Expanded(
          child: CustomCard(
            margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8),
            padding: const EdgeInsets.all(10),
            borderRadius: BorderRadius.circular(15),
            elevation: 4,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 50,
                        height: 30,
                        decoration: BoxDecoration(
                          color: getPriorityColor(widget.task.priority),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.task.priority,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.task.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.task.description,
                        style:
                        const TextStyle(fontSize: 12, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: toggleCompletion,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 600),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: isCompleted
                            ? SvgPicture.asset(
                          AppAssets.rightCheckBox,
                          width: 30.0,
                          height: 30.0,
                          key: const ValueKey('completed'),
                        )
                            : Container(
                          key: const ValueKey('notCompleted'),
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
