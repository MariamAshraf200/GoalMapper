
import 'package:flutter/material.dart';

class CustomContainerNewTask extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final Alignment alignment;
  final Color backgroundColor;
  final double borderRadius;
  final Function()? onTap;

  const CustomContainerNewTask({
    Key? key,
    required this.text,
    this.textStyle,
    this.alignment = Alignment.center,
    this.backgroundColor = Colors.grey,
    this.borderRadius = 20.0,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: alignment,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5.0,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: textStyle ??
              const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}