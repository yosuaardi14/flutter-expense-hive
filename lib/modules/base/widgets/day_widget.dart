import 'package:flutter/material.dart';
import 'package:flutter_expense_app/utils/constant.dart';

class DayWidget extends StatelessWidget {
  final int weekIndex;
  final DateTime selectedDate;
  const DayWidget({super.key, required this.selectedDate, required this.weekIndex});

  ({int start, int end}) weekRangeOfMonth({
    required int year,
    required int month,
    required int weekIndex,
  }) {
    final firstDay = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final firstWeekday = firstDay.weekday; // Mon=1..Sun=7

    int startDay = 1 + (weekIndex - 1) * 7 - (firstWeekday - 1);
    int endDay = startDay + 6;

    startDay = startDay < 1 ? 1 : startDay;
    endDay = endDay > daysInMonth ? daysInMonth : endDay;

    return (start: startDay, end: endDay);
  }

  @override
  Widget build(BuildContext context) {
    final data = weekRangeOfMonth(year: selectedDate.year, month: selectedDate.month, weekIndex: weekIndex);
    return ListTile(
      leading: IconButton(
        onPressed: () {
          // controller.navigateMonth(false);
        },
        icon: Icon(Icons.navigate_before, color: Colors.purple),
      ),
      trailing: IconButton(
        onPressed: () {
          // controller.navigateMonth(true);
        },
        icon: Icon(Icons.navigate_next, color: Colors.purple),
      ),

                      shape: BorderDirectional(
                        bottom: BorderSide(color: Colors.grey),
                      ),
                      // contentPadding: EdgeInsets.symmetric(horizontal: 5),
                      // dense: true,
      title: Row(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...List.generate(data.end - data.start + 1, (index) {
            final day = DateTime(
              selectedDate.year,
              selectedDate.month,
              data.start + index,
            );
            return InkWell(
              onTap: () {
                
              },
              child: Column(
                children: [
                  Text(Constant.hari[day.weekday - 1].substring(0, 3)),
                  Text(day.day.toString()),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
