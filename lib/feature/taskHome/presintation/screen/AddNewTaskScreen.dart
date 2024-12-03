import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Widget/customContainerAddnewTask.dart';
import '../Widget/customTextFeild.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String selectedPriority = '';

  void togglePriority(String priority) {
    setState(() {
      selectedPriority = priority;
    });
  }

  // Validation function
  String? _validateTextField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  void _saveTask() {
    if (_formKey.currentState?.validate() ?? false) {
      print('Title: ${titleController.text}');
      print('Description: ${descriptionController.text}');
      print('Date: ${dateController.text}');
      print('Time: ${timeController.text}');
      print('Priority: $selectedPriority');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Center(
          child: Text(
            'Create New Task',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      backgroundColor: Colors.deepPurple,
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusDirectional.only(
            topEnd: Radius.circular(50),
            topStart: Radius.circular(50),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.03,
            vertical: screenHeight * 0.01,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: titleController,
                    hintText: 'Add title of task',
                    title: 'Task Title',
                    validator: _validateTextField, // Adding validator
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  CustomTextField(
                    controller: descriptionController,
                    hintText: 'Description',
                    description: true,
                    title: 'Description',
                    validator: _validateTextField,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  CustomTextField(
                    controller: dateController,
                    hintText: 'dd/mm/yyyy',
                    title: 'Date',
                    suffixIcon: const Icon(Icons.date_range),
                    onTap: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );

                      if (selectedDate != null) {
                        dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
                      }
                    },
                    validator: _validateTextField,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  CustomTextField(
                    controller: timeController,
                    hintText: 'hh:mm AM/PM',
                    title: 'Time',
                    suffixIcon: const Icon(Icons.access_time),
                    onTap: () async {
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
                    },
                    validator: _validateTextField,
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomContainer(
                        text: 'Low',
                        backgroundColor: selectedPriority == 'Low' ? Colors.green.shade800 : Colors.green,
                        borderRadius: 25,
                        textStyle: TextStyle(
                          color: selectedPriority == 'Low' ? Colors.black : Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        onTap: () => togglePriority('Low'),
                      ),
                      CustomContainer(
                        text: 'Medium',
                        backgroundColor: selectedPriority == 'Medium' ? Colors.orange.shade800 : Colors.orange,
                        borderRadius: 25,
                        textStyle: TextStyle(
                          color: selectedPriority == 'Medium' ? Colors.black : Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        onTap: () => togglePriority('Medium'),
                      ),
                      CustomContainer(
                        text: 'High',
                        backgroundColor: selectedPriority == 'High' ? Colors.red.shade800 : Colors.red,
                        borderRadius: 25,
                        textStyle: TextStyle(
                          color: selectedPriority == 'High' ? Colors.black : Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        onTap: () => togglePriority('High'),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  ElevatedButton(
                    onPressed: _saveTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white38,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Save Task',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
