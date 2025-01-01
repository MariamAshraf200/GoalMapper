
import 'dart:ui';

import 'package:flutter/material.dart';

class PlanItem {
  final String title;
  bool isChecked;

  PlanItem({required this.title, this.isChecked = false});
}

class PlanItemWidget extends StatefulWidget {
  final PlanItem planItem;

  const PlanItemWidget({
    required this.planItem,
  });

  @override
  _PlanItemWidgetState createState() => _PlanItemWidgetState();
}

class _PlanItemWidgetState extends State<PlanItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.planItem.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Checkbox(
              value: widget.planItem.isChecked,
              onChanged: (bool? value) {
                setState(() {
                  widget.planItem.isChecked = value ?? false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
