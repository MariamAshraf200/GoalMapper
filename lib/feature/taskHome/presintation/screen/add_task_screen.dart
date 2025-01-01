import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Widget/add_task_form.dart';
import '../bloc/catogeryBloc/CatogeryBloc.dart';
import '../bloc/catogeryBloc/Catogerystate.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, 
        title: Row(
          children: [
            IconButton(
              tooltip: "Close",
              icon: Icon(
                Icons.close,
                color: Colors.red[400],
                size: 35,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const Spacer(), // Push the text to the center
            Text(
              'Create New Task',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const Spacer(), // Balances the spacing on the right
          ],
        ),
      ),

      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryError) {
            return Center(
              child: Text('Error: ${state.message}'),
            );
          } else if (state is CategoryLoaded) {
            // Ensure at least one category exists
            if (state.categories.isEmpty) {
              return const Center(child: Text('No categories available.'));
            }
            return const AddTaskForm();

          } else {
            return const Center(child: Text('Loading categories...'));
          }
        },
      ),

    );
  }
}


