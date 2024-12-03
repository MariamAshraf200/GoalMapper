import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di.dart';
import '../bloc/bloc.dart';
import '../bloc/event.dart';
import '../bloc/state.dart';

class AllTasksScreen extends StatelessWidget {
  const AllTasksScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Tasks'),
        backgroundColor: Colors.deepPurple,
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        bloc: sl<TaskBloc>()..add(const GetTasksEvent()),
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            return ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  trailing: Text(task.status),
                );
              },
            );
          } else if (state is TaskError) {
            print(state.message);
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Unknown Error'));
          }
        },
      ),
    );
  }
}
