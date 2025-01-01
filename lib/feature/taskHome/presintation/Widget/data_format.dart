import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/customColor.dart';

class DataFormat extends StatefulWidget {
  final String selectedDate;
  final Function(DateTime) onDateSelected;

  const DataFormat({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  State<DataFormat> createState() => _DataFormatState();
}

class _DataFormatState extends State<DataFormat> {
  late DateTime currentDate;
  late List<DateTime> weekDays;
  CustomColor color = CustomColor();

  @override
  void initState() {
    super.initState();
    currentDate = DateTime.now();
    weekDays = List.generate(
      7,
          (index) => currentDate.add(Duration(days: index - currentDate.weekday + 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat('MMMM').format(currentDate),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color.secondaryColor,
                ),
              ),
              // Weekday and Date Row
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: weekDays.map((date) {
                      bool isToday = date.day == currentDate.day &&
                          date.month == currentDate.month &&
                          date.year == currentDate.year;

                      bool isSelected = widget.selectedDate ==
                          DateFormat('yyyy-MM-dd').format(date);

                      return GestureDetector(
                        onTap: () {
                          widget.onDateSelected(date);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              DateFormat('EEE').format(date), // Weekday (e.g., Mon, Tue)
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? color.basicColor
                                    : isToday
                                    ? color.secondaryColor
                                    : color.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? color.secondaryColor
                                    : isToday
                                    ? color.secondaryColor
                                    : color.additionalColor,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                DateFormat('d').format(date),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? color.basicColor
                                      : isToday
                                      ? color.basicColor
                                      : color.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
