import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_spaces.dart';
import '../../../../core/util/widgets/custom_text_field.dart';
import '../../../../core/util/widgets/date_and_time/date_filed.dart';
import '../../../../core/util/widgets/loading_elevate_icon_button.dart';
import '../../../taskHome/presintation/Widget/category_selector.dart';
import '../../../taskHome/presintation/Widget/priority_selector.dart';
import '../../../taskHome/domain/entity/task_enum.dart';
import '../../domain/entities/plan_entity.dart';
import '../bloc/bloc.dart';
import '../bloc/event.dart';

class PlanForm extends StatefulWidget {
  final PlanDetails? initialPlan;
  final bool isUpdate;
  final void Function(PlanDetails plan) onSubmit;

  const PlanForm({
    super.key,
    this.initialPlan,
    required this.isUpdate,
    required this.onSubmit,
  });

  @override
  State<PlanForm> createState() => _PlanFormState();
}

class _PlanFormState extends State<PlanForm> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _formKey = GlobalKey<FormState>();
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
    if (widget.isUpdate && widget.initialPlan != null) {
      _planTitleController = TextEditingController(text: widget.initialPlan!.title);
      _planDescriptionController = TextEditingController(text: widget.initialPlan!.description);
      _planStartDate = DateFormat('dd/MM/yyyy').parse(widget.initialPlan!.startDate);
      _planEndDate = widget.initialPlan!.endDate != 'N/A'
          ? DateFormat('dd/MM/yyyy').parse(widget.initialPlan!.endDate)
          : null;
      _selectedCategory = widget.initialPlan!.category;
      _selectedPriority = TaskPriorityExtension.fromString(widget.initialPlan!.priority);
    } else {
      _planTitleController = TextEditingController();
      _planDescriptionController = TextEditingController();
      _planStartDate = null;
      _planEndDate = null;
      _selectedCategory = null;
      _selectedPriority = TaskPriority.medium;
    }
  }

  @override
  void dispose() {
    _planTitleController.dispose();
    _planDescriptionController.dispose();
    super.dispose();
  }

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
              labelText: widget.isUpdate ? 'Update your plan title' : 'Add your plan title',
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
              labelText: widget.isUpdate ? 'Update your plan description' : 'Add your plan description',
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
            if (widget.isUpdate && _pickedImage == null && widget.initialPlan?.image != null)
              Column(
                children: [
                  Image.file(
                    File(widget.initialPlan!.image!),
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
            else if (_pickedImage == null)
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick Plan Image'),
              )
            else
              Image.file(
                File(_pickedImage!.path),
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            // Save/Update Button
            LoadingElevatedButton(
              onPressed: _handleSubmit,
              buttonText: widget.isUpdate ? 'Update Plan' : 'Add Plan',
              icon: widget.isUpdate ? const Icon(Icons.update) : const Icon(Icons.add),
              showLoading: true,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final formattedStartDate = DateFormat('dd/MM/yyyy').format(_planStartDate!);
    final formattedEndDate = _planEndDate != null
        ? DateFormat('dd/MM/yyyy').format(_planEndDate!)
        : 'N/A';
    PlanDetails plan;
    if (widget.isUpdate && widget.initialPlan != null) {
      plan = widget.initialPlan!.copyWith(
        status: 'Not Completed',
        title: _planTitleController.text.trim(),
        description: _planDescriptionController.text.trim(),
        startDate: formattedStartDate,
        endDate: formattedEndDate,
        priority: _selectedPriority.toTaskPriorityString(),
        category: _selectedCategory ?? 'General',
        image: _pickedImage?.path ?? widget.initialPlan!.image,
      );
    } else {
      plan = PlanDetails(
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
    }
    widget.onSubmit(plan);
  }
}

