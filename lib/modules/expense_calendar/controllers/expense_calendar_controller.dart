import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import "package:collection/collection.dart";
import 'package:intl/intl.dart';

import '../../../models/expense.dart';
import '../../../services/hive_service.dart';
// import '../../../services/db_service.dart';
import '../../../utils/constant.dart';
import '../../../utils/global_functions.dart';

class ExpenseCalendarController extends GetxController {
  HiveService dbService = HiveService.instance;
  // DBService dbService = DBService.instance;
  bool isLoading = false;
  final listExpense = <Expense>[].obs;
  final expenseData = <String, dynamic>{}.obs;
  final daysInMonth = 28.obs;
  final type = Constant.dropdownType[1].obs;
  final payment = Constant.dropdownPayment[0].obs;
  final startWeekDay = 0.obs;
  final sisaWeekDay = 0.obs;
  final mode = "Outcome".obs;
  final month = "0".obs;
  final year = "2024".obs;
  final listYear = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    month.value = DateTime.now().month.toString();
    year.value = DateTime.now().year.toString();
    startWeekDay.value = DateTime.now().weekday;
    listYear.value = List.generate(
      DateTime.now().year - 2020 + 1,
      (index) => (2020 + index).toString(),
    );
  }

  @override
  void onReady() {
    update();
  }

  String rupiahFormat(double amount) {
    String postfix = "";
    bool isInt = false;
    if (amount > 999999999999) {
      // formatted = (amount / 1000000000).toStringAsFixed(1)+"m";
      postfix = "t";
      isInt = amount % 1000000000000 == 0;
      amount /= 1000000000000;
    } else if (amount > 999999999) {
      // formatted = (amount / 1000000000).toStringAsFixed(1)+"m";
      postfix = "m";
      isInt = amount % 1000000000 == 0;
      amount /= 1000000000;
    } else if (amount > 999999) {
      // formatted = (amount / 1000000).toStringAsFixed(1)+"jt";
      postfix = "jt";
      isInt = amount % 1000000 == 0;
      amount /= 1000000;
    } else if (amount > 999) {
      // formatted = (amount / 1000).toStringAsFixed(1)+"rb";
      postfix = "rb";
      isInt = amount % 1000 == 0;
      amount /= 1000;
    }
    String formatted = NumberFormat.currency(
      locale: "id",
      decimalDigits: isInt ? 0 : 1,
      symbol: "",
    ).format(amount);
    if (amount == 0) {
      return "-";
    }
    return formatted + postfix;
  }

  void listData() async {
    isLoading = true;
    update();
    listExpense.value = await dbService.fetchListData();
    if (mode.value == "Income") {
      listExpense.value =
          listExpense.where((e) => e.type == "Pemasukan").toList();
    } else {
      listExpense.value =
          listExpense.where((e) => e.type != "Pemasukan").toList();
    }
    calculateDayInMonth();
    _groupByDate(listExpense, expenseData);
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
    startWeekDay.value = DateTime(yearParam, monthParam, 1).weekday - 1;
    sisaWeekDay.value = (startWeekDay.value + daysInMonth.value) % 7;
  }

  double totalSpend(int day) {
    String dayStr = day < 10 ? "0$day" : "$day";
    List<Expense>? data = expenseData["$dayStr-${month.value}-${year.value}"];
    return calcTotalSpending(data);
    // if (data == null) return 0;
    // return data.fold(0.0, (sum, item) => sum + item.amount);
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
          GF.stringToDateTime(e2.key).compareTo(GF.stringToDateTime(e1.key))));
    data.value = sortedByKeyMap;
  }

  Map<String, dynamic> totalSpending() {
    final DateTime now =
        DateTime(int.parse(year.value), int.parse(month.value));
    List<Expense> yearExpense =
        listExpense.where((element) => element.date.year == now.year).toList();

    List<Expense> lastMonthExpense = listExpense
        .where((element) =>
            element.date.month == now.month - 1 &&
            element.date.year == now.year)
        .toList();

    List<Expense> monthExpense = listExpense
        .where((element) =>
            element.date.month == now.month && element.date.year == now.year)
        .toList();

    return {
      "Bulan ini": calcTotalSpending(monthExpense),
      "Bulan lalu": calcTotalSpending(lastMonthExpense),
      "Tahun ini": calcTotalSpending(yearExpense)
    };
  }

  double calcTotalSpending(List<Expense>? data) {
    if (data == null) return 0;
    return data.fold(0.0, (sum, item) => sum + item.amount);
  }
}
