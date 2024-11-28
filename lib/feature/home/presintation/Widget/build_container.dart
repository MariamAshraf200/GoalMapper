import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final String label;
  final int number;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomContainer({
    Key? key,
    required this.label,
    required this.number,
    this.isSelected = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.grey,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 50,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 18,
                    color: isSelected?  Colors.black :Colors.white ,
                  ),
                ),
                Text(
                  '$number',
                  style: TextStyle(
                    fontSize: 24,
                    color: isSelected?  Colors.black :Colors.white ,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
