import 'package:flutter_expense_app/models/budget.dart';
import 'package:flutter_expense_app/models/expense.dart';
import 'package:flutter_expense_app/modules/base/controllers/expense_base_controller.dart';
import 'package:flutter_expense_app/routes/app_pages.dart';
import 'package:get/get.dart';

class HomeController extends ExpenseBaseController {
  final totalBudgets = 0.0.obs;
  final totalExpenses = 0.0.obs;
  final totalIncomes = 0.0.obs;

  final List<String> menuList = [Routes.EXPENSE, Routes.BUDGET, Routes.SETTING];
  final RxMap<String, double> total = {
    "Income": 0.0,
    "Expense": 0.0,
    "Budget": 0.0,
  }.obs;

  @override
  void onInit() {
    super.onInit();
    listData();
  }

  void listData() async {
    listExpense.value = await dbService.fetchListData();
    listBudget.value = await dbService.fetchListDataBudget();
    total["Income"] = totalExpensePerMonth(false);
    total["Expense"] = totalExpensePerMonth(true);
    total["Budget"] = totalBudgetPerMonth();
    update();
  }

  double totalExpensePerMonth(bool isExpense) {
    DateTime now = DateTime.now();
    List<Expense> monthExpense = listExpense
        .where(
          (element) =>
              (isExpense
                  ? element.type != "Pemasukan"
                  : element.type == "Pemasukan") &&
              element.date.month == now.month &&
              element.date.year == now.year,
        )
        .toList();
    return totalAmount(monthExpense);
  }

  double totalBudgetPerMonth() {
    DateTime now = DateTime.now();
    List<Budget> monthBudget = listBudget
        .where(
          (element) =>
              element.parentid == null &&
              element.month == now.month &&
              element.year == now.year,
        )
        .toList();

    List<Budget> currentMonthBudget = [
      ...convertDailyAsMonthBudget(monthBudget, now),
      ...convertWeekAsMonthBudget(monthBudget),
      ...monthBudget.where(
        (e) => e.parentid == null && e.period == "Per Bulan",
      ),
    ];
    return totalAmount(currentMonthBudget);
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

  int totalWeeksInMonth({DateTime? date}) {
    DateTime now = date ?? DateTime.now();
    int selectedMonth = now.month;
    int selectedYear = now.year;

    DateTime selected = DateTime(selectedYear, selectedMonth, 1);
    DateTime after = DateTime(selectedYear, selectedMonth + 1, 1);
    DateTime selectedLastDay = after.subtract(Duration(days: 1));
    int totalDays = selectedLastDay.difference(selected).inDays + 1;
    int startWeekDay = selected.weekday - 1;
    int weeks = ((startWeekDay + totalDays) / 7).ceil();
    return weeks;
  }

  double totalAmount(List data) {
    return data.fold(0.0, (sum, item) => sum + item.amount);
  }
}
