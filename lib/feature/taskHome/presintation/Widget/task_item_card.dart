import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mapperapp/feature/taskHome/presintation/Widget/task_time_column.dart';
import 'package:mapperapp/feature/taskHome/presintation/screen/upadte_task_form.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/widgets/custom_card.dart';
import '../../../../core/util/widgets/custom_dilog.dart';
import '../../domain/entity/taskEntity.dart';
import '../../domain/entity/task_enum.dart';
import '../bloc/taskBloc/bloc.dart';
import '../bloc/taskBloc/event.dart';

class TaskItemCard extends StatelessWidget {
  final TaskDetails task;

  const TaskItemCard({super.key, required this.task});

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

  void _markTaskAsMissed(BuildContext context) {
    final now = DateTime.now();

    try {
      final taskEndDateTime = DateFormat('dd/MM/yyyy hh:mm a').parse('${task.date} ${task.endTime}');

      if (taskEndDateTime.isBefore(now) &&
          task.status != TaskStatus.completed.toTaskStatusString() &&
          task.status != TaskStatus.inProgress.toTaskStatusString()) {
        // Mark task as missed
        context.read<TaskBloc>().add(
          UpdateTaskStatusEvent(
            task.id,
            TaskStatus.inProgress,
            updatedTime: DateFormat('hh:mm a').format(now),
          ),
        );
      }
    } catch (e) {
      print('Error parsing task date or time: ${task.date} ${task.endTime}');
      print('Exception: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    _markTaskAsMissed(context);

    final isCompleted = task.status == 'Done';
    final isPending = task.status == 'Pending';
    final isMissed = task.status == 'Missed';

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.horizontal,
      background: Container(
        color: Colors.blue,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          _showUpdateDialog(context, task);
        } else if (direction == DismissDirection.endToStart) {
          _showDeleteDialog(context, task);
        }
        return false; // Prevents auto-dismiss after swipe
      },
      child: GestureDetector(
        onLongPress: () {
          if (task.status == 'Done' || task.status == 'Missed') {
            _showErrorDialog(context);
          } else {
            _toggleTaskStatus(context);
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TaskTimeColumn(task: task),
            const SizedBox(width: 8),
            Expanded(
              child: CustomCard(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(12),
                borderRadius: BorderRadius.circular(15),
                elevation: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color: getPriorityColor(task.priority),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              task.priority,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            task.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            task.description,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                              scale: animation, child: child);
                        },
                        child: isCompleted
                            ? SvgPicture.asset(
                                AppAssets.rightCheckBox,
                                width: 30.0,
                                height: 30.0,
                                key: const ValueKey('completed'),
                              )
                            : isMissed
                                ? Image.asset(
                                    'assets/images/missid.png',
                                    width: 30.0,
                                    height: 30.0,
                                    key: const ValueKey('missed'),
                                  )
                                : isPending
                                    ? Image.asset(
                                        'assets/images/pending-clock-icon.webp',
                                        width: 30.0,
                                        height: 30.0,
                                        key: const ValueKey('pending'),
                                      )
                                    : Container(
                                        key: const ValueKey('notCompleted'),
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                      ),
                      onTap: () async {
                        final newStatus = isCompleted ? TaskStatus.pending : TaskStatus.completed;

                        await Future.delayed(const Duration(milliseconds: 500));

                        context.read<TaskBloc>().add(UpdateTaskStatusEvent(
                            task.id, newStatus,
                            updatedTime:
                                DateFormat('hh:mm a').format(DateTime.now())));

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Task marked as ${newStatus.toTaskStatusString()}'),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 1),
                            backgroundColor:
                                isCompleted ? Colors.grey : Colors.green,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Task Not Editable'),
          content: const Text(
              'This task is already completed or missed and cannot be pended.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateDialog(BuildContext context, TaskDetails task) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: 'Update Task',
          description: 'Are you sure you want to update this task?',
          icon: Icons.update,
          operation: 'Update',
          color: Colors.blue,
          onConfirmed: () {
            Navigator.of(context).pop(); // Close the dialog first
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UpdateTaskScreen(task: task),
              ),
            ).then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Task updated successfully'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            });
          },
          onCanceled: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, TaskDetails task) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: 'Delete Task',
          description: 'Are you sure you want to delete this task?',
          icon: Icons.delete_forever,
          operation: 'Delete',
          color: Colors.red,
          onConfirmed: () {
            context.read<TaskBloc>().add(DeleteTaskEvent(task.id));
            Navigator.of(context).pop(); // Close the dialog
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Task deleted successfully'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          onCanceled: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        );
      },
    );
  }

  void _toggleTaskStatus(BuildContext context) {
    final newStatus = task.status == TaskStatus.pending.toTaskStatusString() ? TaskStatus.pending : TaskStatus.completed;

    context.read<TaskBloc>().add(
          UpdateTaskStatusEvent(task.id, newStatus,
              updatedTime: DateFormat('hh:mm a').format(DateTime.now())),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task status updated to ${newStatus.toTaskStatusString()}'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        backgroundColor: newStatus == TaskStatus.pending ? Colors.orange : Colors.grey,
      ),
    );
  }
}
