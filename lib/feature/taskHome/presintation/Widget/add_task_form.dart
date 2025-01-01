import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mapperapp/feature/taskHome/presintation/Widget/priority_selector.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_spaces.dart';
import '../../../../core/util/widgets/date_and_time/date_filed.dart';
import '../../../../core/util/widgets/date_and_time/time_field.dart';
import '../../../../core/util/widgets/loading_elevate_icon_button.dart';
import '../../../../core/util/widgets/custom_text_field.dart';
import '../../domain/entity/taskEntity.dart';

import '../bloc/taskBloc/bloc.dart';
import '../bloc/taskBloc/event.dart';
import 'category_selector.dart';

class AddTaskForm extends StatefulWidget {
  const AddTaskForm({super.key});

  @override
  _AddTaskFormState createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _formKey = GlobalKey<FormState>();
  String? _taskTitle;
  String? _taskDescription;
  DateTime ? _taskDate;
  TimeOfDay? _taskStartTime;
  TimeOfDay? _taskEndTime;
  String? _selectedCategory;
  String _selectedPriority = 'Medium';
  bool _allowNotifications = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: AppSpaces.calculatePaddingFromScreenWidth(context),
      //padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const SizedBox(height: 10.0),
            CustomTextField(
              isRequired: true,
              outSideTitle:'Task Title' ,
              borderRadius: 10,
              labelText: 'Add your task title',
              onSaved: (value) => _taskTitle = value,
              maxLength: 42,
            ),
            CustomTextField(
              outSideTitle: 'Description',
              labelText: 'Add your task description',
              onSaved: (value) => _taskDescription = value,
              maxLines: 3,
              canBeNull: true,
            ),
            DateFiled(
              onDateSelected: (selectedDate) {
                setState(() {
                  _taskDate = selectedDate;
                });
              },
              isRequired: true,
              outSideTitle: "Task Date",
              labelText: 'dd/mm/yyyy',
              suffixIcon: const Icon(Icons.date_range),
             // readOnly: false,
              initialDate: _taskDate,
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                 Expanded(
                child: TimeField(
                labelText: "hh:mm AM/PM",
                outSideTitle: "Task Start Time",
                onTimeSelected: (selectedTime) {
                  setState(() {
                    _taskStartTime = selectedTime;
                  });
                },
                isRequired: true,

                ),
              ),
                const SizedBox(width: 14.0),
                Expanded(
                  child: TimeField(
                    labelText: "hh:mm AM/PM",
                    outSideTitle: "Task End Time",
                    onTimeSelected: (selectedTime) {
                      setState(() {
                        _taskEndTime = selectedTime;
                      });
                    },
                    isRequired: false,
                    canBeNull: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            CategorySelector(
              onCategorySelected: (selectedCategory) {
                setState(() {
                  _selectedCategory = selectedCategory;
                });
              },
            ),
            const SizedBox(height: 16.0),
            PrioritySelector(
              selectedPriority: _selectedPriority,
              onPrioritySelected: (priority) {
                setState(() {
                  _selectedPriority = priority;
                });
              },
            ),

            // Notifications Switch
            SwitchListTile(
              title: const Text('Enable Notifications'),
              value: _allowNotifications,
              onChanged: (value) {
                setState(() {
                  _allowNotifications = value;
                });
              },
            ),

            // Save Button
            LoadingElevatedButton(
              //backgroundColor: Colors.purple,
              onPressed: _handleSave,
              buttonText: 'Add Task',
              icon: const Icon(Icons.add),
              showLoading: true,
            ),
          ],
        ),
      ),
    );

  }


  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    final formattedDate = DateFormat('dd/MM/yyyy').format(_taskDate!);
    final formattedStartTime = _taskStartTime!.format(context);

    final task = TaskDetails(
      id: const Uuid().v4(),
      title: _taskTitle!,
      description: _taskDescription ?? '',
      date: formattedDate,
      time: formattedStartTime,
      priority: _selectedPriority,
      category: _selectedCategory ?? 'General',
      status: 'to do',
    );
    //print("category :${task.category}");

    context.read<TaskBloc>().add(AddTaskEvent(task));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task added successfully!')),
    );

    Navigator.of(context).pop();
  }

}



