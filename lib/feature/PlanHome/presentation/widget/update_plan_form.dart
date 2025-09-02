import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_spaces.dart';
import '../../../../core/util/widgets/custom_text_field.dart';
import '../../../../core/util/widgets/date_and_time/date_filed.dart';
import '../../../../core/util/widgets/loading_elevate_icon_button.dart';
import '../../../taskHome/presintation/Widget/category_selector.dart';
import '../../../taskHome/presintation/Widget/priority_selector.dart';
import '../../../taskHome/domain/entity/task_enum.dart'; // Import for TaskPriority
import '../../domain/entities/plan_entity.dart';
import '../bloc/bloc.dart';
import '../bloc/event.dart';

class UpdatePlanForm extends StatefulWidget {
  final PlanDetails plan;

  const UpdatePlanForm({super.key, required this.plan});

  @override
  _UpdatePlanFormState createState() => _UpdatePlanFormState();
}

class _UpdatePlanFormState extends State<UpdatePlanForm>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final TextEditingController _planTitleController;
  late final TextEditingController _planDescriptionController;

  DateTime? _planStartDate;
  DateTime? _planEndDate;
  String? _selectedCategory;
  late TaskPriority _selectedPriority;
  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    _planTitleController = TextEditingController(text: widget.plan.title);
    _planDescriptionController =
        TextEditingController(text: widget.plan.description);
    _planStartDate = DateFormat('dd/MM/yyyy').parse(widget.plan.startDate);
    _planEndDate = widget.plan.endDate != 'N/A'
        ? DateFormat('dd/MM/yyyy').parse(widget.plan.endDate)
        : null;
    _selectedCategory = widget.plan.category;
    _selectedPriority = TaskPriorityExtension.fromString(widget.plan.priority);
  }

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
              labelText: 'Update your plan title',
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
              labelText: 'Update your plan description',
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
            _pickedImage == null && widget.plan.image != null
                ? Column(
              children: [
                Image.file(
                  File(widget.plan.image!),
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Change Plan Image'),
                ),
              ],
            )
                : _pickedImage == null
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
              onPressed: _handleUpdate,
              buttonText: 'Update Plan',
              icon: const Icon(Icons.update),
              showLoading: true,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final formattedStartDate = DateFormat('dd/MM/yyyy').format(_planStartDate!);
    final formattedEndDate = _planEndDate != null
        ? DateFormat('dd/MM/yyyy').format(_planEndDate!)
        : 'N/A';

    final updatedPlan = widget.plan.copyWith(
      status: 'Not Completed',
      title: _planTitleController.text.trim(),
      description: _planDescriptionController.text.trim(),
      startDate: formattedStartDate,
      endDate: formattedEndDate,
      priority: _selectedPriority.toTaskPriorityString(),
      category: _selectedCategory ?? 'General',
      image: _pickedImage?.path ?? widget.plan.image,
    );

    context.read<PlanBloc>().add(UpdatePlanEvent(updatedPlan));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Plan updated successfully!')),
    );

    Navigator.of(context).pop();
  }

  final _formKey = GlobalKey<FormState>();
}
