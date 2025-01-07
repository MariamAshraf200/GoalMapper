import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapper_app/core/constants/app_colors.dart';
import 'package:mapper_app/core/util/widgets/custom_card.dart';
import 'package:mapper_app/feature/taskHome/presintation/Widget/task_time_column.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_spaces.dart';
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
  bool isCompleted = false;
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          widget.task.status = 'Done';
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // void toggleCompletion() {
  //   setState(() {
  //     isCompleted = !isCompleted;
  //   });
  //   _controller.forward(from: 0);
  // }
  void toggleCompletion() {
    setState(() {
      isCompleted = !isCompleted;
    });

    final newStatus = isCompleted ? 'Done' : 'Pending';

    context.read<TaskBloc>().add(
      UpdateTaskStatusEvent(widget.task.id, newStatus),
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
        // Column(
        //   children: [
        //     Text(
        //       widget.task.time,
        //       style: const TextStyle(color: Colors.black, fontSize: 12),
        //     ),
        //     Container(
        //       width: 1.5,
        //       height: 100, // Fixed height for the line
        //       margin: const EdgeInsets.symmetric(vertical: 4),
        //       color: Colors.grey,
        //     ),
        //     Text(
        //       widget.task.time,
        //       style: const TextStyle(color: Colors.black, fontSize: 12),
        //     ),
        //   ],
        // ),
        const SizedBox(width: 8),
        // Task Card
        Expanded(
          child: CustomCard(
            margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8),
            //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
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
                                key: const ValueKey(
                                    'CompletedIcon'), // Unique key for the SVG image
                              )
                            : Container(
                                key: const ValueKey('UncompletedIcon'),
                                // Unique key for the initial state
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

                    // GestureDetector(
                    //   onTap: toggleCompletion,
                    //   child: AnimatedBuilder(
                    //     animation: _rotationAnimation,
                    //     builder: (context, child) {
                    //       return Transform.rotate(
                    //         angle: _rotationAnimation.value * 2 * 3.14159,
                    //         child: Container(
                    //           width: 30,
                    //           height: 30,
                    //           decoration: BoxDecoration(
                    //             color: isCompleted ? Colors.green : Colors.transparent,
                    //             shape: BoxShape.circle,
                    //             border: Border.all(
                    //               color: isCompleted ? Colors.green : Colors.grey,
                    //               width: 2,
                    //             ),
                    //           ),
                    //           child: isCompleted
                    //               ? const Icon(
                    //             Icons.check,
                    //             color: Colors.white,
                    //             size: 18,
                    //           )
                    //               : null,
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
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
