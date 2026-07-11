import 'package:flutter/material.dart';
import 'package:flutter_expense_app/models/budget.dart';
import 'package:flutter_expense_app/models/expense.dart';
import 'package:flutter_expense_app/modules/base/controllers/expense_base_controller.dart';
import 'package:flutter_expense_app/utils/constant.dart';
import 'package:flutter_expense_app/utils/global_functions.dart';
import 'package:get/get.dart';

class BudgetDashboardController extends ExpenseBaseController {
  final currentListBudget = <Budget>[].obs;

  final weekday = "1".obs;
  final day = "1".obs;
  final week = "1".obs;
  final month = "0".obs;
  final year = "2024".obs;
  final listYear = <String>[].obs;
  final periodIndex = <int>{0}.obs;
  final totalBudget = 0.0.obs;
  final totalExpense = 0.0.obs;
  final percentageBudget = 0.0.obs;
  final remainderBudget = 0.0.obs;

  final tabIndex = 0.obs;
  final selectedWeek = "1".obs;
  final selectedDay = "1".obs;
  final listWeek = <String>[].obs;
  final listDay = <String>[].obs;
  final dateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  ).obs;

  final TextEditingController dayController = TextEditingController();
  final TextEditingController dateRangeController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    DateTime now = DateTime.now();
    weekday.value = now.weekday.toString();
    month.value = now.month.toString();
    year.value = now.year.toString();
    day.value = now.day.toString();
    listYear.value = List.generate(
      DateTime.now().year - 2020 + 1,
      (index) => (2020 + index).toString(),
    );
    listYear.value = listYear.reversed.toList();
    dateRange.value = DateTimeRange(
      start: DateTime(now.year, now.month, 1),
      end: now,
    );
    listData();
  }

  void listData() async {
    listBudget.value = await dbService.fetchListDataBudget();
    listExpense.value = await dbService.fetchListData();

    dayController.text =
        "${selectedDay.value} ${Constant.dropdownMonthOnly[month.value]} ${year.value}";
    if (tabIndex.value == 0) {
      calculateTotalBudget(selectedDate: DateUtils.dateOnly(DateTime.now()));
      getCurrentPeriodListBudgetExpense(
        selectedDate: DateUtils.dateOnly(DateTime.now()),
      );
    } else {
      onChangeTab(1);
    }
  }

  void onChangeTab(int value) {
    tabIndex(value);
    update();
    DateTime? selectedDate;
    int currentWeek = 1;
    if (tabIndex.value == 1) {
      int day = 1;
      if (Constant.dropdownBudgetPeriod[periodIndex.first] == "Per Hari") {
        day = int.parse(selectedDay.value);
      }
      selectedDate = DateTime.tryParse(
        "${year.value}-${month.value.padLeft(2, '0')}-${day.toString().padLeft(2, '0')}",
      );

      if (selectedDate != null) {
        DateTime? firstDay = DateTime.tryParse(
          "${year.value}-${month.value.padLeft(2, '0')}-01",
        );
        weekday.value = selectedDate.weekday.toString();
        listDay.value = List.generate(
          totalDaysInMonth(selectedDate),
          (i) => "${Constant.hari[(firstDay!.weekday - 1 + i) % 7]} - ${i + 1}",
        );
        listWeek.value = List.generate(
          totalWeeksInMonth(date: selectedDate),
          (i) => (i + 1).toString(),
        );
        currentWeek = int.tryParse(selectedWeek.value) ?? 1;
        if (Constant.dropdownBudgetPeriod[periodIndex.first] == "Per Minggu" &&
            currentWeek > 1) {
          selectedDate = selectedDate.add(
            Duration(days: (currentWeek - 1) * 7 - (selectedDate.weekday - 1)),
          );
        }
        update();
      }
    } else {
      DateTime now = DateTime.now();
      selectedDate = DateUtils.dateOnly(now);
      currentWeek = getCurrentWeek();
      week.value = currentWeek.toString();
      day.value = now.day.toString();
      weekday.value = now.weekday.toString();
      month.value = now.month.toString();
      year.value = now.year.toString();
    }
    dayController.text =
        "${selectedDay.value} ${Constant.dropdownMonthOnly[month.value]} ${year.value}";
    calculateTotalBudget(selectedDate: selectedDate);
    getCurrentPeriodListBudgetExpense(
      selectedDate: selectedDate,
      currentWeek: currentWeek,
    );
  }

  void calculateTotalBudget({DateTime? selectedDate}) {
    totalExpense.value = totalSpend(getMonthExpenses(selected: selectedDate));
    List<Budget> monthBudget = listBudget
        .where(
          (element) =>
              element.parentid == null &&
              element.month.toString() == month.value &&
              element.year.toString() == year.value,
        )
        .toList();

    List<Budget> currentMonthBudget = [
      ...convertDailyAsMonthBudget(monthBudget, selectedDate),
      ...convertWeekAsMonthBudget(monthBudget),
      ...monthBudget.where(
        (e) => e.parentid == null && e.period == "Per Bulan",
      ),
    ];

    totalBudget.value = totalSpend(currentMonthBudget);
    remainderBudget.value = totalBudget.value - totalExpense.value;
    if (totalBudget.value < 1.0) {
      percentageBudget.value = totalExpense.value > 0.0 ? 100.0 : 0.0;
    } else {
      percentageBudget.value = totalExpense.value / totalBudget.value;
    }
    update();
  }

  List<Budget> convertDailyAsMonthBudget(
    List<Budget> source,
    DateTime? selectedDate,
  ) {
    List<Budget> result = source
        .where(
          (element) => element.parentid == null && element.period == "Per Hari",
        )
        .map((e) {
          List<Budget> children = listBudget
              .where((child) => child.parentid == e.id)
              .toList();
          Budget budget = Budget(
            id: e.id,
            month: e.month,
            year: e.year,
            type: e.type,
            period: e.period,
            amount: e.amount,
            param: e.param,
            children: children,
            totalExpense: 0,
            percentage: 0,
          );
          // budget.amount = calculateDailyToWeekly(budget);
          // budget.children = [];
          // budget.amount = calculateWeeklyToMonthly(budget);
          budget.amount = calculateDailyToMonthly(
            budget,
            selectedDate: selectedDate,
          );
          return budget;
        })
        .toList();
    return result;
  }

  List<Budget> convertWeekAsMonthBudget(List<Budget> source) {
    List<Budget> result = source
        .where(
          (element) =>
              element.parentid == null && element.period == "Per Minggu",
        )
        .map((e) {
          List<Budget> children = listBudget
              .where((child) => child.parentid == e.id)
              .toList();
          Budget budget = Budget(
            id: e.id,
            month: e.month,
            year: e.year,
            type: e.type,
            period: e.period,
            amount: e.amount,
            param: e.param,
            children: children,
            totalExpense: 0,
            percentage: 0,
          );
          budget.amount = calculateWeeklyToMonthly(budget);
          return budget;
        })
        .toList();
    return result;
  }

  Future<void> getCurrentPeriodListBudgetExpense({
    DateTime? selectedDate,
    int? currentWeek,
  }) async {
    currentListBudget.value = listBudget
        .where(
          (element) =>
              element.parentid == null &&
              Constant.dropdownBudgetPeriod.reversed
                  .toList()
                  .sublist(2 - periodIndex.first)
                  .contains(element.period) &&
              element.month.toString() == month.value &&
              element.year.toString() == year.value,
        )
        .map((e) {
          List<Budget> children = listBudget
              .where((child) => child.parentid == e.id)
              .toList();
          Budget budget = Budget(
            id: e.id,
            month: e.month,
            year: e.year,
            type: e.type,
            period: e.period,
            amount: e.amount,
            param: e.param,
            children: children,
            totalExpense: 0,
            percentage: 0,
          );
          if (Constant.dropdownBudgetPeriod[periodIndex.first] == "Per Bulan") {
            budget.totalExpense = totalSpend(
              getMonthExpenses(type: e.type, selected: selectedDate),
            );
            if (e.period == "Per Minggu") {
              budget.amount = calculateWeeklyToMonthly(budget);
            } else if (e.period == "Per Hari") {
              // budget.amount = calculateDailyToWeekly(budget);
              // budget.children = [];
              // budget.amount = calculateWeeklyToMonthly(budget);
              budget.amount = calculateDailyToMonthly(
                budget,
                selectedDate: selectedDate,
              );
            }
            budget.remainder = budget.amount - (budget.totalExpense ?? 0);
            budget.percentage = calculatePercentage(budget);
          }
          if (Constant.dropdownBudgetPeriod[periodIndex.first] ==
              "Per Minggu") {
            budget.totalExpense = totalSpend(
              getWeekExpenses(type: e.type, selected: selectedDate),
            );
            if (e.period == "Per Hari") {
              budget.amount = calculateDailyToWeekly(
                budget,
                selectedDate: selectedDate,
              );
            } else {
              budget.amount =
                  children
                      .firstWhereOrNull(
                        (e) => e.param == (currentWeek ?? getCurrentWeek()),
                      )
                      ?.amount ??
                  budget.amount;
            }
            budget.remainder = budget.amount - (budget.totalExpense ?? 0);
            budget.percentage = calculatePercentage(budget);
          }
          if (Constant.dropdownBudgetPeriod[periodIndex.first] == "Per Hari") {
            budget.amount =
                children
                    .firstWhereOrNull(
                      (e) => e.param.toString() == weekday.value,
                    )
                    ?.amount ??
                budget.amount;
            budget.totalExpense = totalSpend(
              getDayExpenses(type: e.type, selected: selectedDate),
            );
            budget.remainder = budget.amount - (budget.totalExpense ?? 0);
            budget.percentage = calculatePercentage(budget);
          }
          return budget;
        })
        .toList();
    update();
  }

  double calculatePercentage(Budget budget) {
    if (budget.amount < 1.0) {
      return 0.0;
    }
    return (budget.totalExpense ?? 0) / budget.amount;
  }

  double totalSpend(List data) {
    return data.fold(0.0, (sum, item) => sum + item.amount);
  }

  double calculateDailyToWeekly(Budget budget, {DateTime? selectedDate}) {
    double sum = 0.0;
    int children = budget.children.length;
    if (selectedDate != null) {
      //
      DateTime startOfWeek = selectedDate.subtract(
        Duration(days: selectedDate.weekday - 1),
      );
      DateTime endOfWeek = startOfWeek
          .add(const Duration(days: 7))
          .subtract(Duration(microseconds: 1));
      //
      DateTime firstDayOfMonth = DateTime(
        selectedDate.year,
        selectedDate.month,
        1,
      );
      DateTime lastDayOfMonth = DateTime(
        selectedDate.year,
        selectedDate.month + 1,
        1,
      ).subtract(Duration(microseconds: 1));
      if (startOfWeek.isBefore(firstDayOfMonth)) {
        startOfWeek = firstDayOfMonth;
      }
      if (endOfWeek.isAfter(lastDayOfMonth)) {
        endOfWeek = lastDayOfMonth;
      }
      for (var i = startOfWeek.weekday; i <= endOfWeek.weekday; i++) {
        sum +=
            budget.children.firstWhereOrNull((e) => e.param == i)?.amount ??
            budget.amount;
      }
    } else {
      for (var i = 0; i < 7; i++) {
        if (i < children) {
          sum += budget.children[i].amount;
        } else {
          sum += budget.amount;
        }
      }
    }

    return sum;
  }

  double calculateDailyToMonthly(Budget budget, {DateTime? selectedDate}) {
    double sum = 0.0;
    int children = budget.children.length;
    if (selectedDate != null) {
      DateTime lastDayOfMonth = DateTime(
        selectedDate.year,
        selectedDate.month + 1,
        1,
      ).subtract(Duration(microseconds: 1));
      for (var i = 1; i <= lastDayOfMonth.day; i++) {
        DateTime currentDate = DateTime(
          selectedDate.year,
          selectedDate.month,
          i,
        );
        sum +=
            budget.children
                .firstWhereOrNull((e) => e.param == currentDate.weekday)
                ?.amount ??
            budget.amount;
      }
    } else {
      for (var i = 0; i < 7; i++) {
        if (i < children) {
          sum += budget.children[i].amount;
        } else {
          sum += budget.amount;
        }
      }
    }

    return sum;
  }

  double calculateWeeklyToMonthly(Budget budget, {DateTime? selectedDate}) {
    int weeks = totalWeeksInMonth();
    double sum = 0.0;
    int children = budget.children.length;
    for (var i = 0; i < weeks; i++) {
      if (i < children) {
        sum += budget.children[i].amount;
      } else {
        sum += budget.amount;
      }
    }
    return sum;
  }

  int getCurrentWeek({DateTime? date}) {
    DateTime now = date ?? DateTime.now();
    int selectedMonth = int.tryParse(month.value) ?? now.month;
    int selectedYear = int.tryParse(year.value) ?? now.year;

    final firstDay = DateTime(selectedYear, selectedMonth, 1);
    final w = firstDay.weekday; // Mon=1..Sun=7
    return ((w + now.day - 1) / 7).ceil();
    // DateTime now = date ?? DateTime.now();
    // int selectedMonth = int.tryParse(month.value) ?? now.month;
    // int selectedYear = int.tryParse(year.value) ?? now.year;

    // DateTime selectedFirstDay = DateTime(selectedYear, selectedMonth, 1);
    // // DateTime selectedNextMonth = DateTime(selectedYear, selectedMonth + 1, 1);
    // // DateTime selectedLastDay = selectedNextMonth.subtract(Duration(days: 1));

    // int startWeekDay = selectedFirstDay.weekday - 1; // 3 - Januari'26
    // int nowWeekday = now.weekday - 1; // 6
    // int day = now.day; // 11
    // // 11 / 7 => 1
    // // 5 / 7 => 0 -> weekday = 0 < 3 -> 1
    // // 12 / 7 => 1 -> weekday = 0 < 3 -> 2
    // // 18 / 7 = 2 -> weekday = 6 > 3 -> 2
    // // 4 / 7 = 0 -> weekday = 6 > 3 -> 1
    // // 3 / 7 = 0 -> weekday = 6 > 3 -> 1
    // // 29 / 7 = 0 -> weekday = 3 > 3 -> 5

    // int currentWeek = nowWeekday >= startWeekDay
    //     ? (day / 7).ceil()
    //     : (day / 7).floor() + 1;
    // return currentWeek;
  }

  int totalWeeksInMonth({DateTime? date}) {
    DateTime now = date ?? DateTime.now();
    int selectedMonth = int.tryParse(month.value) ?? now.month;
    int selectedYear = int.tryParse(year.value) ?? now.year;

    DateTime selected = DateTime(selectedYear, selectedMonth, 1);
    DateTime after = DateTime(selectedYear, selectedMonth + 1, 1);
    DateTime selectedLastDay = after.subtract(Duration(days: 1));
    int totalDays = selectedLastDay.difference(selected).inDays + 1;
    int startWeekDay = selected.weekday - 1;
    int weeks = ((startWeekDay + totalDays) / 7).ceil();
    return weeks;
  }

  int totalDaysInMonth(DateTime now) {
    // int selectedMonth = int.tryParse(month.value) ?? now.month;
    // int selectedYear = int.tryParse(year.value) ?? now.year;

    // DateTime selected = DateTime(selectedYear, selectedMonth, 1);
    // DateTime after = DateTime(selectedYear, selectedMonth + 1, 1);
    // DateTime selectedLastDay = after.subtract(Duration(days: 1));
    // return selectedLastDay.difference(selected).inDays + 1;
    final selectedMonth = int.tryParse(month.value) ?? now.month;
    final selectedYear = int.tryParse(year.value) ?? now.year;
    return DateTime(selectedYear, selectedMonth + 1, 0).day;
  }

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

  List<Expense> getDayExpenses({String? type, DateTime? selected}) {
    DateTime now = DateUtils.dateOnly(selected ?? DateTime.now());
    return listExpense.where((tx) {
      return (type != null ? tx.type == type : true) &&
          tx.type != "Pemasukan" &&
          tx.date.day == now.day &&
          tx.date.month == now.month &&
          tx.date.year == now.year;
    }).toList();
  }

  List<Expense> getWeekExpenses({String? type, DateTime? selected}) {
    DateTime now = DateUtils.dateOnly(selected ?? DateTime.now());
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek
        .add(const Duration(days: 7))
        .subtract(Duration(microseconds: 1));
    return listExpense.where((tx) {
      return (type != null ? tx.type == type : true) &&
          tx.type != "Pemasukan" &&
          tx.date.isAfter(startOfWeek) &&
          tx.date.isBefore(endOfWeek) &&
          tx.date.month == now.month;
    }).toList();
  }

  List<Expense> getMonthExpenses({String? type, DateTime? selected}) {
    DateTime now = DateUtils.dateOnly(selected ?? DateTime.now());
    return listExpense.where((tx) {
      return (type != null ? tx.type == type : true) &&
          tx.type != "Pemasukan" &&
          tx.date.month == now.month &&
          tx.date.year == now.year;
    }).toList();
  }

  @override
  void onReady() {
    update();
  }

  void onChangePeriod(Set<int> val) {
    periodIndex(val);
    onChangeTab(tabIndex.value);
  }

  void navigateDay(bool isNext) {
    int index = listDay.indexWhere(
      (e) => e.split(" - ").last == selectedDay.value,
    );
    bool canNavigate = isNext ? index + 1 < listDay.length : index - 1 >= 0;
    if (canNavigate) {
      selectedDay.value = listDay[index + (isNext ? 1 : -1)].split(" - ").last;
      dayController.text =
          "${selectedDay.value} ${Constant.dropdownMonthOnly[month.value]} ${year.value}";
      onChangeTab(tabIndex.value);
      update();
    }
  }

  void navigateWeek(bool isNext) {
    int index = listWeek.indexWhere((e) => e == selectedWeek.value);
    bool canNavigate = isNext ? index + 1 < listWeek.length : index - 1 >= 0;
    if (canNavigate) {
      selectedWeek.value = listWeek[index + (isNext ? 1 : -1)];
      onChangeTab(tabIndex.value);
      update();
    }
  }

  void navigateMonth(bool isNext) {
    DateTime selectDate = GF.stringToDateTime(
      "01-${month.value.padLeft(2, '0')}-${year.value}",
    );
    DateTime constraint = isNext ? DateTime.now() : DateTime(2020);
    DateTime temp = DateTime(
      selectDate.year,
      selectDate.month + (isNext ? 1 : -1),
      1,
    );
    bool canNavigate = isNext
        ? (temp.isAfter(constraint) == false)
        : (temp.isBefore(constraint) == false);
    if (canNavigate) {
      month.value = temp.month.toString();
      year.value = temp.year.toString();
      onChangeTab(tabIndex.value);
      update();
    }
  }

  void navigateDateRange(bool isNext) {
    int index = listDay.indexWhere(
      (e) => e.split(" - ").last == dateRange.value.end.day.toString(),
    );
    bool canNavigate = isNext ? index + 1 < listDay.length : index - 1 >= 0;
    if (canNavigate) {
      dateRange.value = DateTimeRange(
        start: dateRange.value.start,
        end: DateTime(
          dateRange.value.end.year,
          dateRange.value.end.month,
          (dateRange.value.end.day + (isNext ? 1 : -1)),
        ),
      );
      dateRangeController.text =
          "${dateRange.value.start.day} - ${dateRange.value.end.day} ${Constant.dropdownMonthOnly[dateRange.value.end.month.toString()]} ${dateRange.value.end.year}";
      onChangeTab(tabIndex.value);
      update();
    }
  }
}
