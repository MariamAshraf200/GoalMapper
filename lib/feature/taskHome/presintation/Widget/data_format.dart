import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DataFormat extends StatelessWidget {
  const DataFormat({super.key});

  @override
  Widget build(BuildContext context) {
    final DateTime currentDate = DateTime.now();
    final List<DateTime> weekDays = List.generate(
      7,
          (index) => currentDate.add(Duration(days: index - currentDate.weekday + 1)),
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat('MMMM').format(currentDate),  // Month display
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[400],
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

                      return GestureDetector(
                        onTap: () {
                          // Handle date selection (could be passed to the parent widget)
                          print('Selected Date: ${DateFormat('yyyy-MM-dd').format(date)}');
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              DateFormat('EEE').format(date),  // Weekday (e.g., Mon, Tue)
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isToday ? Colors.teal[400] : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              decoration: BoxDecoration(
                                color: isToday ? Colors.teal[200] : Colors.grey[200],
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                DateFormat('d').format(date),  // Day of the month (e.g., 1, 2, 3)
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isToday ? Colors.white : Colors.black,
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
  }}