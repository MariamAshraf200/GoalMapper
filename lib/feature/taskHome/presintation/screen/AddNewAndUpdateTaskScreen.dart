import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
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
  final TaskEntity? existingTask;
  const AddTaskAndUpdateScreen({super.key, this.existingTask});

  @override
  _AddTaskAndUpdateScreenState createState() =>
      _AddTaskAndUpdateScreenState();
}

class _AddTaskAndUpdateScreenState extends State<AddTaskAndUpdateScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String selectedPriority = '';
  late String uniqueTaskId;
  CustomColor color = CustomColor();
  bool allowNotifications = false;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _voiceInputText = '';

  @override
  void initState() {
    super.initState();
    if (widget.existingTask != null) {
      _initializeTaskFields();
    } else {
      uniqueTaskId = const Uuid().v4();
    }
    context.read<CategoryBloc>().add(LoadCategoriesEvent());
    _speech = stt.SpeechToText();
  }

  void _initializeTaskFields() {
    titleController.text = widget.existingTask!.title;
    descriptionController.text = widget.existingTask!.description;
    dateController.text = widget.existingTask!.date;
    timeController.text = widget.existingTask!.time;
    selectedPriority = widget.existingTask!.priority;
    uniqueTaskId = widget.existingTask!.id;
    categoryController.text = widget.existingTask!.category;
  }

  String? _validateTextField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => setState(() {
        _isListening = status == 'listening';
      }),
      onError: (error) => debugPrint('Speech recognition error: $error'),
    );

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (result) {
        setState(() {
          _voiceInputText = result.recognizedWords;
          descriptionController.text = _removeDuplicateWords(
              '${descriptionController.text} $_voiceInputText');
        });
      });
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  String _removeDuplicateWords(String text) {
    List<String> words = text.split(' ');
    Set<String> uniqueWords = <String>{};
    List<String> filteredWords = [];
    for (var word in words) {
      if (uniqueWords.add(word)) {
        filteredWords.add(word);
      }
    }
    return filteredWords.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<TaskBloc, TaskState>(
        listener: _taskBlocListener,
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, categoryState) {
            if (categoryState is CategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (categoryState is CategoryLoaded) {
              return _buildFormBody(categoryState.categories);
            } else if (categoryState is CategoryError) {
              return Center(child: Text('Error: ${categoryState.message}'));
            }
            return Container();
          },
        ),
      ),
    );
  }

  void _taskBlocListener(BuildContext context, TaskState state) {
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
  }

  Widget _buildFormBody(List<CategoryModel> categories) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Manage your Task',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25)),
              // Title TextField
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Add task title",
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
              CustomTextField(
                controller: descriptionController,
                hintText: 'Description',
                description: true,
                validator: _validateTextField,
                readOnly: false,
              ),
              _buildSpeechAndUserIcons(),
              CustomTextField(
                controller: categoryController,
                hintText: 'Select or Enter Category',
                suffixIcon: const Icon(Icons.category),
                onTap: () => showCategoryBottomSheet(
                    context, categoryController, categories),
                validator: _validateTextField,
                readOnly: false,
              ),
              _buildDateAndTimeFields(),
              SwitchListTile(
                title: const Text("Enable Notifications"),
                value: allowNotifications,
                onChanged: (bool value) {
                  setState(() {
                    allowNotifications = value;
                  });
                },
              ),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpeechAndUserIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(_isListening ? Icons.mic : Icons.mic_none,
              color: Colors.grey),
          onPressed: () {
            if (_isListening) {
              _stopListening();
            } else {
              _startListening();
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.person, color: Colors.grey),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildDateAndTimeFields() {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            controller: dateController,
            hintText: 'dd/mm/yyyy',
            suffixIcon: const Icon(Icons.date_range),
            onTap: _pickDate,
            validator: _validateTextField,
            readOnly: false,
          ),
        ),
        Expanded(
          child: CustomTextField(
            controller: timeController,
            hintText: 'hh:mm AM/PM',
            suffixIcon: const Icon(Icons.access_time),
            onTap: _pickTime,
            validator: _validateTextField,
            readOnly: false,
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      final now = DateTime.now();
      final selectedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      timeController.text = DateFormat('hh:mm a').format(selectedDateTime);
    }
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) {
            final task = TaskEntity(
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
              context.read<CategoryBloc>().add(
                AddCategoryEvent(categoryName: categoryController.text),
              );
            }
          }
        },
        child: Text(widget.existingTask == null ? 'Save Task' : 'Update Task'),
      ),
    );
  }
}
