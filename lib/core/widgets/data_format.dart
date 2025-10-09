import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';
import '../customColor.dart';

/// A reusable horizontal date picker that shows a range of days and
/// allows selecting one. This is a core, UI-only widget and does not
/// depend on any feature-specific models or blocs.
class DataFormat extends StatefulWidget {
  final String selectedDate; // expected in 'dd/MM/yyyy' format
  final ValueChanged<DateTime> onDateSelected;

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
  final CustomColor color = CustomColor();

  @override
  void initState() {
    super.initState();
    currentDate = DateTime.now();
    // Build a simple forward range of 30 days starting from today
    weekDays = List.generate(
      30,
      (index) => DateTime(currentDate.year, currentDate.month, currentDate.day).add(Duration(days: index),),
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
    if (!_scrollController.hasClients) return;

    final formattedList = weekDays.map((d) => DateFormat('dd/MM/yyyy').format(d)).toList();
    final selectedIndex = formattedList.indexOf(widget.selectedDate);
    if (selectedIndex != -1) {
      final screenWidth = MediaQuery.of(context).size.width;
      const itemWidth = 100.0; // approximate width of each item
      final scrollOffset = (selectedIndex * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

      _scrollController.animateTo(
        scrollOffset.clamp(
          _scrollController.position.minScrollExtent,
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
            final isSelected = widget.selectedDate == DateFormat('dd/MM/yyyy').format(date);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: GestureDetector(
                onTap: () => widget.onDateSelected(date),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.secondaryColor : AppColors.secondBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat('EEE').format(date),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('d MMM').format(date),
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : Colors.black,
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

