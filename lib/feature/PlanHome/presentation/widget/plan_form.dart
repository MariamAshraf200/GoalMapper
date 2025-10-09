import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../injection_imports.dart';
import 'package:mapperapp/core/util/date_sort_util.dart';


class PlanForm extends StatefulWidget {
  final PlanDetails? initialPlan;
  final bool isUpdate;

  const PlanForm({
    super.key,
    this.initialPlan,
    required this.isUpdate,
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
      // Use DateSortUtil to flexibly parse different date formats and handle 'N/A'
      _planStartDate = DateSortUtil.parseFlexibleDate(widget.initialPlan!.startDate);
      _planEndDate = DateSortUtil.parseFlexibleDate(widget.initialPlan!.endDate);
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
                if (_planEndDate != null && _planStartDate != null && _planEndDate!.isBefore(_planStartDate!)) {
                  setState(() {
                    _planEndDate = null;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('End date cleared because it was before the newly selected start date')));
                }
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
              firstDate: _planStartDate,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return null;
                if (_planStartDate == null) return null;
                final parsed = DateSortUtil.parseFlexibleDate(value);
                if (parsed == null) return 'Invalid end date';
                if (parsed.isBefore(_planStartDate!)) return 'End date cannot be before start date';
                return null;
              },
            ),
            // Use core logic wrapper which handles category loading, add and delete via CategoryBloc
            CategorySelectorWithLogic(
              selectedCategory: _selectedCategory,
              onCategorySelected: (selectedCategory) {
                setState(() {
                  _selectedCategory = selectedCategory;
                });
              },
            ),
            const SizedBox(height: 16.0),
            // Use core logic wrapper which maps TaskPriority enum and provides the UI
            PrioritySelectorWithLogic(
              selectedPriority: _selectedPriority,
              onPrioritySelected: (p) {
                setState(() => _selectedPriority = p);
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
    // Dispatch form-level events; PlanBloc will build/merge PlanDetails and call usecases
    final imagePath = _pickedImage?.path;

    if (widget.isUpdate && widget.initialPlan != null) {
      final updatedPlan = widget.initialPlan!.copyWith(
        title: _planTitleController.text.trim(),
        description: _planDescriptionController.text.trim(),
        startDate: formattedStartDate,
        endDate: formattedEndDate,
        priority: _selectedPriority.toTaskPriorityString(),
        category: _selectedCategory ?? 'General',
        image: imagePath ?? widget.initialPlan!.image,
      );

      context.read<PlanBloc>().add(UpdatePlanEvent(updatedPlan));

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Plan updated successfully!')));
    } else {
      // Build a new PlanDetails and dispatch AddPlanEvent (mirror update behavior)
      final newPlan = PlanDetails(
        id: const Uuid().v4(),
        title: _planTitleController.text.trim(),
        description: _planDescriptionController.text.trim(),
        startDate: formattedStartDate,
        endDate: formattedEndDate,
        priority: _selectedPriority.toTaskPriorityString(),
        category: _selectedCategory ?? 'General',
        status: 'Not Completed',
        image: imagePath,
      );

      context.read<PlanBloc>().add(AddPlanEvent(newPlan));

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Plan added successfully!')));
    }

    // Close the form after dispatch
    Navigator.of(context).pop();
  }
}
