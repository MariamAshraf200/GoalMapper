import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapper_app/core/util/widgets/custom_card.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_spaces.dart';
import '../../domain/entity/taskEntity.dart';
import '../bloc/bloc.dart';
import '../bloc/event.dart';
import '../screen/AddNewAndUpdateTaskScreen.dart';

// class TaskCard extends StatelessWidget {
//   final String taskId;
//   final String title;
//   final String description;
//   final String date;
//   final String time;
//   final String priority;
//   final String status;
//   final Color? priorityColor;
//   final VoidCallback onViewClicked;
//
//   const TaskCard({
//     super.key,
//     required this.taskId,
//     required this.title,
//     required this.description,
//     required this.date,
//     required this.time,
//     required this.priority,
//     required this.status,
//     this.priorityColor,
//     required this.onViewClicked,
//   });
//
//   void _deleteTask(BuildContext context) {
//     context.read<TaskBloc>().add(DeleteTaskEvent(taskId));
//   }
//
//   Icon getIconForStatus(String status) {
//     switch (status.toLowerCase()) {
//       case 'to do':
//         return const Icon(CupertinoIcons.arrow_up_right, color: Colors.white);
//       case 'in progress':
//         return const Icon(Icons.hourglass_top, color: Colors.white);
//       case 'done':
//         return const Icon(Icons.check_circle, color: Colors.white);
//       default:
//         return const Icon(Icons.help_outline, color: Colors.white);
//     }
//   }
//
//   // Helper function to get priority color
//   Color _getPriorityColor(String priority) {
//     switch (priority) {
//       case 'High':
//         return Colors.red;
//       case 'Medium':
//         return Colors.orange;
//       case 'Low':
//         return Colors.green;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dismissible(
//       key: Key(taskId), // Unique key for each task
//       onDismissed: (direction) {
//         if (direction == DismissDirection.endToStart) {
//           _deleteTask(context); // Delete task on swipe to the right
//         }
//       },
//       background: Container(
//         color: Colors.red, // Background color when swiping right
//         alignment: Alignment.centerRight,
//         padding: const EdgeInsets.only(right: 20),
//         child: const Icon(
//           Icons.delete,
//           color: Colors.white,
//         ),
//       ),
//       child: GestureDetector(
//         onLongPress: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => AddTaskAndUpdateScreen(
//                 existingTask: TaskDetails(
//                   id: taskId,
//                   title: title,
//                   description: description,
//                   date: date,
//                   time: time,
//                   priority: priority,
//                   status: status,
//                 ),
//               ),
//             ),
//           );
//         },
//         child: Container(
//           margin: const EdgeInsets.symmetric(vertical: 8.0),
//           padding: const EdgeInsets.all(16.0),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16.0),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.3),
//                 blurRadius: 6.0,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       title,
//                       style: const TextStyle(
//                         fontSize: 18.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Container(
//                         decoration: const BoxDecoration(
//                           color: Colors.black,
//                           shape: BoxShape.circle,
//                         ),
//                         child: IconButton(
//                           onPressed: onViewClicked,
//                           icon: getIconForStatus(status),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8.0),
//               Text(
//                 description,
//                 style: const TextStyle(
//                   fontSize: 14.0,
//                   color: Colors.grey,
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               const SizedBox(height: 16.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.access_time,
//                         size: 16.0,
//                         color: Colors.grey,
//                       ),
//                       const SizedBox(width: 4.0),
//                       Text(
//                         time,
//                         style: const TextStyle(fontSize: 12.0, color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12.0,
//                       vertical: 6.0,
//                     ),
//                     decoration: BoxDecoration(
//                       color: _getPriorityColor(priority),
//                       borderRadius: BorderRadius.circular(12.0),
//                     ),
//                     child: Text(
//                       priority,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 12.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class TaskItemCard extends StatelessWidget {
//   const TaskItemCard({required this.task,super.key});
//   final TaskDetails task ;
//
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }





//
//
// class TaskCard extends StatefulWidget {
//   final String title;
//   final String time;
//   final String endTime;
//   final String priority;
//   final String taskId;
//   final String description;
//   final String date;
//    String status;
//   final Color? priorityColor;
//   final VoidCallback onViewClicked;
//
//    TaskCard({
//     Key? key,
//     required this.title,
//     required this.time,
//     required this.endTime,
//     required this.priority,
//     required this.description,
//     required this.onViewClicked,
//     this.priorityColor,
//     required this.status,
//     required this.taskId,
//     required this.date,
//   }) : super(key: key);
//
//   @override
//   _TaskCardState createState() => _TaskCardState();
// }
//
// class _TaskCardState extends State<TaskCard> with SingleTickerProviderStateMixin {
//   bool isCompleted = false;
//   late AnimationController _controller;
//   late Animation<double> _rotationAnimation;
//   bool isAnimating = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
//     _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
//     );
//     _controller.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         setState(() {
//           widget.status = 'Done'; // Update the status to 'Done' after animation
//           isAnimating = false;
//         });
//       }
//     });
//   }
//
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void toggleCompletion() {
//     setState(() {
//       isCompleted = !isCompleted;
//     });
//     _controller.forward(from: 0);
//   }
//
//   Color getPriorityColor(String priority) {
//     switch (priority) {
//       case 'High':
//         return Colors.red;
//       case 'Medium':
//         return Colors.orange;
//       case 'Low':
//         return Colors.green;
//       default:
//         return Colors.white;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Column(
//           children: [
//             Text(
//               widget.time,
//               style: const TextStyle(color: Colors.white, fontSize: 12),
//             ),
//             Expanded(
//               child: Container(
//                 width: 1.5,
//                 margin: const EdgeInsets.symmetric(vertical: 4),
//                 color: Colors.grey, // Line color
//               ),
//             ),
//             Text(
//               widget.endTime,
//               style: const TextStyle(color: Colors.white, fontSize: 12),
//             ),
//           ],
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Card(
//             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//             elevation: 4,
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Priority Oval
//
//                   const SizedBox(width: 16),
//                   // Task Details
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//
//                         Container(
//                           width: 50,
//                           height: 30,
//                           decoration: BoxDecoration(
//                             color: getPriorityColor(widget.priority),
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           alignment: Alignment.center,
//                           child: Text(
//                             widget.priority,
//                             style:  const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 12),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           widget.title,
//                           style:  const TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           widget.description,
//                           style:  const TextStyle(
//                             fontSize: 12,
//                            color: Colors.grey
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         // Text(
//                         //   '${widget.time} - ${widget.endTime}',
//                         //   style: const TextStyle(fontSize: 14, color: Colors.grey),
//                         // ),
//                       ],
//                     ),
//                   ),
//                   // Checkbox with Circular Animation
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       GestureDetector(
//                         onTap: toggleCompletion,
//                         child: AnimatedBuilder(
//                           animation: _rotationAnimation,
//                           builder: (context, child) {
//                             return Transform.rotate(
//                               angle: _rotationAnimation.value * 2 * 3.14159,
//                               child: Container(
//                                 width: 30,
//                                 height: 30,
//                                 decoration: BoxDecoration(
//                                   color: isCompleted ? Colors.green : Colors.transparent,
//                                   shape: BoxShape.circle,
//                                   border: Border.all(
//                                     color: isCompleted ? Colors.green : Colors.grey,
//                                     width: 2,
//                                   ),
//                                 ),
//                                 child: isCompleted
//                                     ? const Icon(
//                                   Icons.check,
//                                   color: Colors.white,
//                                   size: 18,
//                                 )
//                                     : null,
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                      const SizedBox(height: 12),
//
//
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

class TaskItemCard extends StatefulWidget {


  const TaskItemCard({
    super.key,
    required this.task
  });

  final TaskDetails task ;
  @override
  _TaskItemCardState createState() => _TaskItemCardState();
}

class _TaskItemCardState extends State<TaskItemCard> with SingleTickerProviderStateMixin {
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

  void toggleCompletion() {
    setState(() {
      isCompleted = !isCompleted;
    });
    _controller.forward(from: 0);
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
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Time Column with Line
        Column(
          children: [
            Text(
              widget.task.time,
              style: const TextStyle(color: Colors.black, fontSize: 12),
            ),
            Container(
              width: 1.5,
              height: 100, // Fixed height for the line
              margin: const EdgeInsets.symmetric(vertical: 4),
              color: Colors.grey,
            ),
            Text(
              widget.task.time,
              style: const TextStyle(color: Colors.black, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(width: 8),
        // Task Card
        Expanded(
          child: CustomCard(
            margin: const EdgeInsets.symmetric(horizontal:0.0, vertical: 8),
            //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            padding: const EdgeInsets.all(10),
            borderRadius:BorderRadius.circular(15),
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
                          style: const TextStyle(color: Colors.white, fontSize: 12),
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
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
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
                          key: const ValueKey('CompletedIcon'), // Unique key for the SVG image
                        )
                            : Container(
                          key: const ValueKey('UncompletedIcon'), // Unique key for the initial state
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

class TaskItems extends StatefulWidget {
  const TaskItems({
    super.key,
    required this.tasks,
  });

  final List<TaskDetails> tasks;

  @override
  State<TaskItems> createState() => _TaskItemsState();
}

class _TaskItemsState extends State<TaskItems> {
  final _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
    }
  }



  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: AppSpaces.calculatePaddingFromScreenWidth(context),
      controller: _scrollController,
      itemCount: widget.tasks.length + 1,
      itemBuilder: (context, index) {
        if (index == widget.tasks.length) {
          return _isLoading
              ? const Center(child: CircularProgressIndicator())
              : const SizedBox();
        }
        return TaskItemCard(task: widget.tasks[index],);
      },
    );
  }
}

