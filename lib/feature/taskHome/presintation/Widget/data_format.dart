import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mapper_app/core/constants/app_colors.dart';

import '../../../../core/customColor.dart';

// class DataFormat extends StatefulWidget {
//   final String selectedDate;
//   final Function(DateTime) onDateSelected;
//
//   const DataFormat({
//     super.key,
//     required this.selectedDate,
//     required this.onDateSelected,
//   });
//
//   @override
//   State<DataFormat> createState() => _DataFormatState();
// }
//
// class _DataFormatState extends State<DataFormat> {
//   late DateTime currentDate;
//   late List<DateTime> weekDays;
//   CustomColor color = CustomColor();
//
//   @override
//   void initState() {
//     super.initState();
//     currentDate = DateTime.now();
//     weekDays = List.generate(
//       7,
//           (index) => currentDate.add(Duration(days: index - currentDate.weekday + 1)),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 DateFormat('MMMM').format(currentDate),
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: color.secondaryColor,
//                 ),
//               ),
//               // Weekday and Date Row
//               Center(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 12.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: weekDays.map((date) {
//                       bool isToday = date.day == currentDate.day &&
//                           date.month == currentDate.month &&
//                           date.year == currentDate.year;
//
//                       bool isSelected = widget.selectedDate ==
//                           DateFormat('yyyy-MM-dd').format(date);
//
//                       return GestureDetector(
//                         onTap: () {
//                           widget.onDateSelected(date);
//                         },
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               DateFormat('EEE').format(date), // Weekday (e.g., Mon, Tue)
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                                 color: isSelected
//                                     ? color.basicColor
//                                     : isToday
//                                     ? color.secondaryColor
//                                     : color.primaryColor,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Container(
//                               decoration: BoxDecoration(
//                                 color: isSelected
//                                     ? color.secondaryColor
//                                     : isToday
//                                     ? color.secondaryColor
//                                     : color.additionalColor,
//                                 shape: BoxShape.circle,
//                               ),
//                               padding: const EdgeInsets.all(10),
//                               child: Text(
//                                 DateFormat('d').format(date),
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.bold,
//                                   color: isSelected
//                                       ? color.basicColor
//                                       : isToday
//                                       ? color.basicColor
//                                       : color.primaryColor,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
class DataFormat extends StatefulWidget {
  final String selectedDate;
  final Function(DateTime) onDateSelected;

  const DataFormat({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<DataFormat> createState() => _DataFormatState();
}

class _DataFormatState extends State<DataFormat> {
  late DateTime currentDate;
  late List<DateTime> weekDays;
  late ScrollController _scrollController;
  CustomColor color = CustomColor();

  @override
  void initState() {
    super.initState();
    currentDate = DateTime.now();
    weekDays = List.generate(
      7,
          (index) => currentDate.add(Duration(days: index - currentDate.weekday + 1)),
    );
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerSelectedDate();
    });
  }

  @override

  void didUpdateWidget(covariant DataFormat oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerSelectedDate();
    });
  }

  void _centerSelectedDate() {
    int selectedIndex = weekDays.indexWhere((date) =>
    widget.selectedDate == DateFormat('dd/MM/yyyy').format(date));
    if (selectedIndex != -1) {
      double screenWidth = MediaQuery.of(context).size.width;
      double itemWidth = 56.0; // Estimated width of each item including padding
      double scrollOffset = (selectedIndex * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

      _scrollController.animateTo(
        scrollOffset.clamp(
          _scrollController.position.minScrollExtent,
          _scrollController.position.minScrollExtent,
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerSelectedDate();
    });
  }

  @override

  void didUpdateWidget(covariant DataFormat oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerSelectedDate();
    });
  }

  void _centerSelectedDate() {
    int selectedIndex = weekDays.indexWhere((date) =>
    widget.selectedDate == DateFormat('dd/MM/yyyy').format(date));
    if (selectedIndex != -1) {
      double screenWidth = MediaQuery.of(context).size.width;
      double itemWidth = 56.0; // Estimated width of each item including padding
      double scrollOffset = (selectedIndex * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

      _scrollController.animateTo(
        scrollOffset.clamp(
          _scrollController.position.maxScrollExtent,
          _scrollController.position.maxScrollExtent,
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: weekDays.map((date) {
            bool isSelected = widget.selectedDate ==
                DateFormat('dd/MM/yyyy').format(date);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0), // Add spacing between items
              child: GestureDetector(
                onTap: () {
                  widget.onDateSelected(date);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.secondaryColor : AppColors.secondBackgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Text(
                        DateFormat('EEE').format(date), // Weekday
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (isSelected)
                        Text(
                          DateFormat(',d MMM').format(date), // Day and Month
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black ,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add spacing between items
              child: GestureDetector(
                onTap: () {
                  widget.onDateSelected(date);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.secondaryColor : AppColors.secondBackgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Text(
                        DateFormat('EEE').format(date), // Weekday
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (isSelected)
                        Text(
                          DateFormat(',d MMM').format(date), // Day and Month
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black ,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
