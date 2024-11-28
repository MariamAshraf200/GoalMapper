import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? suffixIcon;
  final bool description; // New variable to control size
  final String title;
  final VoidCallback? onTap; // New onTap parameter

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.title,
    this.suffixIcon,
    this.description = false,
    this.onTap, // Initialize onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 20),
            ),
          ),
          GestureDetector(
            onTap: onTap, // Trigger the onTap callback if provided
            child: AbsorbPointer( // Prevents the TextField from handling taps if onTap is used
              absorbing: onTap != null,
              child: TextField(
                controller: controller,
                maxLines: description ? 5 : 1,
                minLines: description ? 3 : 1,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300],
                  hintText: hintText,
                  hintStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.deepPurple),
                  ),
                  suffixIcon: suffixIcon,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
