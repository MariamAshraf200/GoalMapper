import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapper_app/feature/taskHome/presintation/Widget/task_item_card.dart';
// import '../bloc/bloc.dart';
// import '../bloc/event.dart';
// import '../bloc/state.dart';

// class AllTasksScreen extends StatelessWidget {
//   const AllTasksScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     context.read<TaskBloc>().add(GetAllTasksEvent());
//
//     Future<void> onRefresh() async {
//       context.read<TaskBloc>().add(GetAllTasksEvent());
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.deepPurple,
//         title: const Text(
//           'All Tasks',
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: BlocBuilder<TaskBloc, TaskState>(
//         builder: (context, state) {
//           if (state is TaskLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is TaskLoaded) {
//             return RefreshIndicator(
//               onRefresh: onRefresh,
//               child: ListView.builder(
//                 itemCount: state.tasks.length,
//                 itemBuilder: (context, index) {
//                   final task = state.tasks[index];
//                   return Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: TaskItemCard(
//                       title: task.title,
//                       description: task.description,
//                       date: task.date,
//                       time: task.time,
//                       priority: task.priority,
//                       onViewClicked: () {},
//                       taskId: task.id,
//                       status: task.status,
//                       endTime:task.time ,
//
//
//                     ),
//                   );
//                 },
//               ),
//             );
//           } else if (state is TaskError) {
//             print(state.message);
//             return Center(child: Text('Error: ${state.message}'));
//           }
//           return const Center(child: Text('No tasks available'));
//         },
//       ),
//     );
//   }
// }
