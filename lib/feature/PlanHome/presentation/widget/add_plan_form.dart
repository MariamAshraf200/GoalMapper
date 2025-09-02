import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapperapp/feature/taskHome/domain/entity/task_enum.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_spaces.dart';
import '../../../../core/util/widgets/custom_text_field.dart';
import '../../../../core/util/widgets/date_and_time/date_filed.dart';
import '../../../../core/util/widgets/loading_elevate_icon_button.dart';
import '../../../taskHome/presintation/Widget/category_selector.dart';
import '../../../taskHome/presintation/Widget/priority_selector.dart';
import '../../domain/entities/plan_entity.dart';
import '../bloc/bloc.dart';
import '../bloc/event.dart';

class AddPlanForm extends StatefulWidget {
  const AddPlanForm({super.key});

  @override
  _AddPlanFormState createState() => _AddPlanFormState();
}

class _AddPlanFormState extends State<AddPlanForm>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _planTitleController = TextEditingController();
  final TextEditingController _planDescriptionController = TextEditingController();

  DateTime? _planStartDate;
  DateTime? _planEndDate;
  String? _selectedCategory;
  TaskPriority _selectedPriority = TaskPriority.medium;
  XFile? _pickedImage;

  @override
  void dispose() {
    _planTitleController.dispose();
    _planDescriptionController.dispose();
    super.dispose();
  }

  // Function to pick an image
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: AppSpaces.calculatePaddingFromScreenWidth(context),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const SizedBox(height: 10.0),
            CustomTextField(
              isRequired: true,
              outSideTitle: 'Plan Title',
              borderRadius: 10,
              labelText: 'Add your plan title',
              controller: _planTitleController,
              maxLength: 42,
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'Plan title is required';
                }
                return null;
              },
            ),
            CustomTextField(
              outSideTitle: 'Description',
              labelText: 'Add your plan description',
              controller: _planDescriptionController,
              maxLines: 3,
              canBeNull: true,
            ),
            DateFiled(
              onDateSelected: (selectedDate) {
                setState(() {
                  _planStartDate = selectedDate;
                });
              },
              isRequired: true,
              outSideTitle: "Plan Start Date",
              labelText: 'dd/mm/yyyy',
              suffixIcon: const Icon(Icons.date_range),
              initialDate: _planStartDate,
            ),
            const SizedBox(height: 16.0),
            DateFiled(
              onDateSelected: (selectedDate) {
                setState(() {
                  _planEndDate = selectedDate;
                });
              },
              isRequired: false,
              outSideTitle: "Plan End Date",
              labelText: 'dd/mm/yyyy',
              suffixIcon: const Icon(Icons.date_range),
              initialDate: _planEndDate,
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

            // Image Picker for Plan Image
            _pickedImage == null
                ? ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Plan Image'),
            )
                : Image.file(
              File(_pickedImage!.path),
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),

            // Save Button
            LoadingElevatedButton(
              onPressed: _handleSave,
              buttonText: 'Add Plan',
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

    final formattedStartDate = DateFormat('dd/MM/yyyy').format(_planStartDate!);
    final formattedEndDate = _planEndDate != null
        ? DateFormat('dd/MM/yyyy').format(_planEndDate!)
        : 'N/A';

    final plan = PlanDetails(
      id: const Uuid().v4(),
      title: _planTitleController.text.trim(),
      description: _planDescriptionController.text.trim(),
      startDate: formattedStartDate,
      endDate: formattedEndDate,
      priority: _selectedPriority.toTaskPriorityString(),
      category: _selectedCategory ?? 'General',
      status: 'Not Completed',
      image: _pickedImage?.path, 
    );

    context.read<PlanBloc>().add(AddPlanEvent(plan));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Plan added successfully!')),
    );

    Navigator.of(context).pop();
  }
}
