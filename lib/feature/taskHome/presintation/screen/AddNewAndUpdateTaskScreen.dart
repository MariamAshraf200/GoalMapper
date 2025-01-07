import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/customColor.dart';
import '../../data/model/categoryModel.dart';
import '../../domain/entity/taskEntity.dart';
import '../Widget/bottomSheet.dart';
import '../Widget/customTextFeild.dart';
import '../bloc/catogeryBloc/CatogeryBloc.dart';
import '../bloc/catogeryBloc/Catogeryevent.dart';
import '../bloc/catogeryBloc/Catogerystate.dart';
import '../bloc/taskBloc/bloc.dart';
import '../bloc/taskBloc/event.dart';
import '../bloc/taskBloc/state.dart';

class AddTaskAndUpdateScreen extends StatefulWidget {
  final TaskDetails? existingTask;

  const AddTaskAndUpdateScreen({super.key, this.existingTask});

  @override
  _AddTaskAndUpdateScreenState createState() => _AddTaskAndUpdateScreenState();
}

class _AddTaskAndUpdateScreenState extends State<AddTaskAndUpdateScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String selectedPriority = '';
  String selectedCategory = '';
  late String uniqueTaskId;
  CustomColor color = CustomColor();
  bool allowNotifications = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingTask != null) {
      titleController.text = widget.existingTask!.title;
      descriptionController.text = widget.existingTask!.description;
      dateController.text = widget.existingTask!.date;
      timeController.text = widget.existingTask!.time;
      selectedPriority = widget.existingTask!.priority;
      uniqueTaskId = widget.existingTask!.id;
      categoryController.text = widget.existingTask!.category;
    } else {
      uniqueTaskId = const Uuid().v4();
    }
    context.read<CategoryBloc>().add(LoadCategoriesEvent());
  }

  String? _validateTextField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  void togglePriority(String priority) {
    setState(() {
      selectedPriority = priority;
    });
  }

  Color _getPriorityColor(String priority) {
    return selectedPriority == priority ? Colors.deepPurple : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add New Task')),
        leading:  IconButton(
          tooltip: "go back",
          icon: const Icon(
            Icons.arrow_back_outlined,
            size: 35,
          ),
          onPressed: () {
              Navigator.of(context).pop();
          },
        ),
      ),
      body: BlocListener<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskAddSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Task saved successfully!')),
            );
            Navigator.pop(context, state.task);
          } else if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          } else if (state is TaskActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Task updated successfully!')),
            );
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, categoryState) {
            if (categoryState is CategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (categoryState is CategoryLoaded) {
              return _buildBody(categoryState.categories);
            } else if (categoryState is CategoryError) {
              return Center(child: Text('Error: ${categoryState.message}'));
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildBody(List<CategoryModel> categories) {
    return Form(
        key: _formKey,
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                  // Title TextField
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: "Add task title",
                      enabledBorder:
                          OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),

                  // DateFiled(
                  //   onDateSelected: (String value) {
                  //     selectedPriority = value;
                  //   },
                  //   controller: descriptionController,
                  //   labelText: 'Description',
                  //   validator: _validateTextField,
                  //   readOnly: false,
                  // ),

                  // DateFiled(
                  //   controller: categoryController,
                  //   labelText: 'Select or Enter Category',
                  //   suffixIcon: const Icon(Icons.category),
                  //   onTap: () => showCategoryBottomSheet(
                  //       context, categoryController, categories),
                  //   readOnly: false,
                  //   validator: _validateTextField,
                  // ),

                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: DateFiled(
                  //         controller: dateController,
                  //         labelText: 'dd/mm/yyyy',
                  //         suffixIcon: const Icon(Icons.date_range),
                  //         onTap: () async {
                  //           DateTime? selectedDate = await showDatePicker(
                  //             context: context,
                  //             initialDate: DateTime.now(),
                  //             firstDate: DateTime(2000),
                  //             lastDate: DateTime(2100),
                  //           );
                  //           if (selectedDate != null) {
                  //             dateController.text =
                  //                 DateFormat('dd/MM/yyyy').format(selectedDate);
                  //           }
                  //         },
                  //         validator: _validateTextField,
                  //         readOnly: false,
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: DateFiled(
                  //         controller: timeController,
                  //         labelText: 'hh:mm AM/PM',
                  //         suffixIcon: const Icon(Icons.access_time),
                  //         onTap: () async {
                  //           TimeOfDay? selectedTime = await showTimePicker(
                  //             context: context,
                  //             initialTime: TimeOfDay.now(),
                  //           );
                  //           if (selectedTime != null) {
                  //             final now = DateTime.now();
                  //             final selectedDateTime = DateTime(
                  //               now.year,
                  //               now.month,
                  //               now.day,
                  //               selectedTime.hour,
                  //               selectedTime.minute,
                  //             );
                  //             timeController.text = DateFormat('hh:mm a')
                  //                 .format(selectedDateTime);
                  //           }
                  //         },
                  //         validator: _validateTextField,
                  //         readOnly: false,
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  SwitchListTile(
                    title: const Text("Enable Notifications"),
                    value: allowNotifications,
                    onChanged: (bool value) {
                      setState(() {
                        allowNotifications = value;
                      });
                    },
                  ),

                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {

                        if (_formKey.currentState!.validate()) {
                          final task = TaskDetails(

                            title: titleController.text,
                            description: descriptionController.text,
                            date: dateController.text,
                            time: timeController.text,
                            priority: selectedPriority,
                            category: categoryController.text,
                            id: uniqueTaskId,
                            status: 'to do',
                          );

                          if (widget.existingTask != null) {
                            context.read<TaskBloc>().add(UpdateTaskEvent(task));
                          } else {
                            context.read<TaskBloc>().add(AddTaskEvent(task));
                            context.read<CategoryBloc>().add(AddCategoryEvent(categoryName:categoryController.text ));

                          }
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const TaskListScreen(),
                          //   ),
                          // );
                        }
                      } },
                      child: Text(widget.existingTask != null
                          ? 'Update Task'
                          : 'Add Task'),

                    ),
                  )
                ]))));
  }
}
