// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_expense_app/modules/base/controllers/base_controller.dart';
import "package:collection/collection.dart";
import 'package:intl/intl.dart';

import '../../../models/expense.dart';
import '../../../services/hive_service.dart';
// import '../../../services/db_service.dart';
import '../../../utils/global_functions.dart';
import '../views/expense_list_view.dart';

class ExpenseListState extends BaseController<ExpenseList> {
  @override
  Widget build(BuildContext context) => ExpenseListView(this);

  HiveService dbService = HiveService.instance;
  // DBService dbService = DBService.instance;
  ValueNotifier<bool> showChart = ValueNotifier(true);
  ValueNotifier<bool> showList = ValueNotifier(true);
  ValueNotifier<bool> isFilter = ValueNotifier(false);
  ValueNotifier<int> pageIndex = ValueNotifier(0);
  ValueNotifier<Map<String, String>> filterValue = ValueNotifier({
    "type": "Semua",
    "payment": "Semua",
    "month": "0",
    "year": "Semua",
  });
  ValueNotifier<List<Expense>> listExpense = ValueNotifier(<Expense>[]);
  ValueNotifier<List<Expense>> listExpenseFilter = ValueNotifier(<Expense>[]);
  ValueNotifier<Map<String, dynamic>> expenseData = ValueNotifier({});
  ValueNotifier<bool> isExpense = ValueNotifier(true);
  ValueNotifier<List<String>> listYear = ValueNotifier(["Semua"]);

  @override
  void initState() {
    super.initState();
    listYear.value.addAll(List.generate(
      DateTime.now().year - 2020 + 1,
      (index) => (2020 + index).toString(),
    ));
    listData();
  }

  void switchList() {
    isExpense.value = !isExpense.value;
    listData();
  }

  void listData() async {
    isLoading.value = true;
    listExpense.value = await dbService.fetchListData();

    listExpense.value = listExpense.value
        .where((e) =>
            isExpense.value ? e.type != "Pemasukan" : e.type == "Pemasukan")
        .toList();
    if (isFilter.value) {
      _groupByDate(listExpenseFilter, expenseData);
    } else {
      _groupByDate(listExpense, expenseData);
    }
    isLoading.value = false;
  }

  void filterData(Map<String, String> data) {
    setState(() {
      filterValue.value = data;
    });

    if (data["type"] == "Semua" &&
        data["payment"] == "Semua" &&
        data["year"] == "Semua" &&
        data["month"] == "0") {
      isFilter.value = false;
      listData();
      return;
    }
    List<Expense> temp = listExpense.value;
    if (data["month"] != "0") {
      temp = temp
          .where((element) =>
              element.date.month == int.parse(data["month"].toString()))
          .toList();
    }
    if (data["year"] != "Semua") {
      temp = temp
          .where((element) =>
              element.date.year == int.parse(data["year"].toString()))
          .toList();
    }
    if (data["type"] != "Semua") {
      temp = temp.where((element) => element.type == data["type"]).toList();
    }
    if (data["payment"] != "Semua") {
      temp =
          temp.where((element) => element.payment == data["payment"]).toList();
    }
    isFilter.value = true;
    listExpenseFilter.value = temp;
    listData();
  }

  void deleteData(String id) async {
    await dbService.deleteData(id);
    listData();
  }

  List<Expense> get _weekExpenses {
    DateTime now = DateUtils.dateOnly(DateTime.now());
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
    return listExpense.value.where((tx) {
      return tx.date.isAfter(startOfWeek) &&
          tx.date.isBefore(endOfWeek) &&
          tx.date.month == now.month;
    }).toList();
  }

  Map<String, dynamic> totalSpending() {
    final DateTime now = DateTime.now();
    List<Expense> yearExpense = listExpense.value
        .where((element) => element.date.year == now.year)
        .toList();

    List<Expense> lastMonthExpense = listExpense.value
        .where((element) =>
            element.date.month == now.month - 1 &&
            element.date.year == now.year)
        .toList();

    List<Expense> monthExpense = listExpense.value
        .where((element) =>
            element.date.month == now.month && element.date.year == now.year)
        .toList();

    List<Expense> todayExpense = listExpense.value
        .where((element) =>
            element.date.day == now.day &&
            element.date.month == now.month &&
            element.date.year == now.year)
        .toList();

    return {
      "Hari ini": totalSpend(todayExpense),
      "Minggu ini": totalSpend(_weekExpenses),
      "Bulan ini": totalSpend(monthExpense),
      "Bulan lalu": totalSpend(lastMonthExpense),
      "Tahun ini": totalSpend(yearExpense)
    };
  }

  double totalSpend(List<Expense> data) {
    return data.fold(0.0, (sum, item) => sum + item.amount);
  }

  void _groupByDate(ValueNotifier<List<Expense>> list,
      ValueNotifier<Map<String, dynamic>> data) {
    Map<String, dynamic> newMap = groupBy(list.value,
        (Expense obj) => DateFormat("dd-MM-yyyy").format(obj.date)).map((k, v) {
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
}
