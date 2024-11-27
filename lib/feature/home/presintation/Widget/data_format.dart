import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DataFormat extends StatelessWidget {
  const DataFormat({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    List<DateTime> weekDays = List.generate(
      7,
          (index) => currentDate.add(Duration(days: index - currentDate.weekday + 1)),
    );

    return Scaffold(
      body: Column(
        children: [
          // Custom header with month name, menu, and profile icons
          Container(
            color: Colors.grey,
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    // Add menu icon functionality here
                  },
                ),

                IconButton(
                  icon: const Icon(Icons.account_circle, color: Colors.white),
                  onPressed: () {
                    // Add profile icon functionality here
                  },
                ),
              ],
            ),
          ),

          // Days of the week section
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadiusDirectional.only(
                  bottomEnd: Radius.circular(50),
                  bottomStart: Radius.circular(50),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          DateFormat('MMMM').format(currentDate), // Display the month name (e.g., November)
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Icon(CupertinoIcons.arrow_down_right,color: Colors.white, size: 20,),
                        )
                      ],
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: weekDays.map((date) {
                            bool isToday = date.day == currentDate.day &&
                                date.month == currentDate.month &&
                                date.year == currentDate.year;

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  DateFormat('EEE').format(date), // Display day (e.g., Sun, Mon)
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isToday ? Colors.white : Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: isToday ? Colors.white : Colors.grey[200],
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    DateFormat('d').format(date), // Display day of the month (e.g., 07)
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isToday ? Colors.grey : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Additional content section
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.white,
              child: const Center(
                child: Text(
                  'Content goes here',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
