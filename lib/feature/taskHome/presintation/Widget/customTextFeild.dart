import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? suffixIcon;
  final bool description;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.suffixIcon,
    this.description = false,
    this.onTap,
    this.validator, required bool readOnly,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTap,
            child: AbsorbPointer(
              absorbing: onTap != null,
              child: TextFormField(
                controller: controller,
                maxLines: description ? 5 : 1,
                minLines: description ? 3 : 1,
                validator: validator,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300],
                  hintText: hintText,
                  hintStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
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
