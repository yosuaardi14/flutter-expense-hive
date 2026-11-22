import 'package:get/get.dart';

import '../../../models/expense.dart';
import '../../../utils/constant.dart';
import '../../../utils/global_functions.dart';
import '../../base/controllers/expense_base_controller.dart';

class ExpenseTableController extends ExpenseBaseController {
  // final type = Constant.dropdownType[1].obs;
  // final payment = Constant.dropdownPayment[0].obs;
  final daysInMonth = 28.obs;
  final tableItem = <Map<String, dynamic>>[].obs;
  final month = "0".obs;
  final year = "2025".obs;
  final selectedPayment = [...Constant.dropdownPayment].obs;

  @override
  void onInit() {
    super.onInit();
    month.value = DateTime.now().month.toString();
    year.value = DateTime.now().year.toString();
    listYear.addAll(GF.listYear());
  }

  @override
  void onReady() {
    listData();
  }

  Future<void> listData() async {
    listExpense.value = await expenseService.fetchListFilterData(
      null,
      null,
      selectedPayment,
      DateTime(int.parse(year.value), int.parse(month.value), 1),
      DateTime(int.parse(year.value), int.parse(month.value) + 1, 1),
    );
    calculateDayInMonth();
  }

  void calculateDayInMonth() {
    int monthParam = int.parse(month.value);
    int yearParam = int.parse(year.value);
    final firstDayOfNextMonth = DateTime(yearParam, monthParam + 1, 1);
    final lastDayOfThisMonth = firstDayOfNextMonth.subtract(
      const Duration(days: 1),
    );
    daysInMonth.value = lastDayOfThisMonth.day;
    // _groupData(listExpense, expenseData);
    groupByDate(listExpense, expenseData, ascending: true);
    _createTableData(listExpense, expenseData);
  }

  double totalSpendByDay(int day) {
    List<Expense>? data =
        expenseData["${day.toString().padLeft(2, "0")}-${month.value}-${year.value}"];
    if (data == null) return 0.0;
    return data.fold(0.0, (sum, item) => sum + item.amount);
  }

  void _createTableData(RxList<Expense> list, RxMap<String, dynamic> data) {
    // groupByDate(list, data, ascending: true);
    double totalIncome = 0.0;
    double totalOutcome = 0.0;
    double totalSisa = 0.0;
    tableItem.clear();
    for (var item in data.entries) {
      double totalIncomePerDay = 0.0;
      double totalOutcomePerDay = 0.0;
      double totalSisaPerDay = 0.0;

      var splitDate = item.key.split("-");
      if (splitDate[1] != month.value.padLeft(2, '0') ||
          splitDate[2] != year.value) {
        continue;
      }
      List<Expense> listExpense = item.value;
      for (var i = 0; i < listExpense.length; i++) {
        Expense expense = item.value[i];
        if (expense.type == Constant.pemasukan) {
          totalIncome += expense.amount;
          totalIncomePerDay += expense.amount;
        } else {
          totalOutcome += expense.amount;
          totalOutcomePerDay += expense.amount;
        }
        totalSisaPerDay = totalIncomePerDay - totalOutcomePerDay;
        totalSisa = totalIncome - totalOutcome;
        tableItem.add({
          "day": i == 0 ? item.key.split("-")[0] : "",
          "isLast": i == listExpense.length - 1,
          "title": expense.title,
          "income": expense.type == Constant.pemasukan ? expense.amount : 0.0,
          "outcome": expense.type != Constant.pemasukan ? expense.amount : 0.0,
          "totalIncome": totalIncome,
          "totalOutcome": totalOutcome,
          "totalSisa": totalSisa,
          "totalIncomePerDay": totalIncomePerDay,
          "totalOutcomePerDay": totalOutcomePerDay,
          "totalSisaPerDay": totalSisaPerDay,
          "date": item.key,
          "expense": expense,
        });
      }
    }
  }
}
