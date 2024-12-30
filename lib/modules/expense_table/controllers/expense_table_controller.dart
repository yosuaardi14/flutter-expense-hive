import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import "package:collection/collection.dart";

import 'package:intl/intl.dart';
import '../../../models/expense.dart';
import '../../../services/hive_service.dart';
// import '../../../services/db_service.dart';
import '../../../utils/constant.dart';
import '../../../utils/global_functions.dart';

class ExpenseTableController extends GetxController {
  HiveService dbService = HiveService.instance;
  // DBService dbService = DBService.instance;
  bool isLoading = false;
  final listExpense = <Expense>[].obs;
  final expenseData = <String, dynamic>{}.obs;
  final daysInMonth = 28.obs;
  final type = Constant.dropdownType[1].obs;
  final payment = Constant.dropdownPayment[0].obs;
  final tableItem = <Map<String, dynamic>>[].obs;
  final month = "0".obs;
  final year = "2024".obs;
  final listYear = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    month.value = DateTime.now().month.toString();
    year.value = DateTime.now().year.toString();
    listYear.value = List.generate(
      DateTime.now().year - 2020 + 1,
      (index) => (2020 + index).toString(),
    );
  }

  @override
  void onReady() {
    update();
  }

  void listData() async {
    isLoading = true;
    update();
    listExpense.value = await dbService.fetchListData();
    calculateDayInMonth();

    isLoading = false;
    update();
  }

  void calculateDayInMonth() {
    int monthParam = int.parse(month.value);
    int yearParam = int.parse(year.value);
    final firstDayOfNextMonth = DateTime(yearParam, monthParam + 1, 1);
    final lastDayOfThisMonth =
        firstDayOfNextMonth.subtract(const Duration(days: 1));
    daysInMonth.value = lastDayOfThisMonth.day;
    _groupByDate(listExpense, expenseData);
  }

  double totalSpend(int day) {
    List<Expense>? data = expenseData["$day-${month.value}-${year.value}"];
    if (data == null) return 0.0;
    return data.fold(0.0, (sum, item) => sum + item.amount);
  }

  void _groupByDate(RxList<Expense> list, RxMap<String, dynamic> data) {
    Map<String, dynamic> newMap = groupBy(
            list, (Expense obj) => DateFormat("dd-MM-yyyy").format(obj.date))
        .map((k, v) {
      return MapEntry(
        k,
        v.map(
          (item) {
            return item;
          },
        ).toList(),
      );
    });
    Map<String, dynamic> sortedByKeyMap = Map.fromEntries(newMap.entries
        .toList()
      ..sort((e1, e2) =>
          GF.stringToDateTime(e1.key).compareTo(GF.stringToDateTime(e2.key))));
    data.value = sortedByKeyMap;

    //
    double totalIncome = 0.0;
    double totalOutcome = 0.0;
    double totalSisa = 0.0;
    tableItem.clear();
    for (var item in data.entries) {
      double totalIncomePerDay = 0.0;
      double totalOutcomePerDay = 0.0;
      double totalSisaPerDay = 0.0;

      var splitDate = item.key.split("-");
      if (splitDate[1] != month.value || splitDate[2] != year.value) {
        continue;
      }
      List<Expense> listExpense = item.value;
      for (var i = 0; i < listExpense.length; i++) {
        Expense expense = item.value[i];
        if (expense.type == "Pemasukan") {
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
          "income": expense.type == "Pemasukan" ? expense.amount : 0.0,
          "outcome": expense.type != "Pemasukan" ? expense.amount : 0.0,
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
