// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:collection/collection.dart";
import 'package:intl/intl.dart';

import '../../../models/expense.dart';
import '../../../services/hive_service.dart';
// import '../../../services/db_service.dart';
import '../../../utils/global_functions.dart';

class ExpenseListController extends GetxController {
  HiveService dbService = HiveService.instance;
  // DBService dbService = DBService.instance;
  bool showChart = true;
  bool showList = true;
  bool isLoading = false;
  bool isFilter = false;
  final pageIndex = 0.obs;
  final filterValue = {
    "type": "Semua",
    "payment": "Semua",
    "month": "0",
    "year": "Semua",
  }.obs;
  final listExpense = <Expense>[].obs;
  final listExpenseFilter = <Expense>[].obs;
  final expenseData = <String, dynamic>{}.obs;
  final isExpense = true.obs;
  final listYear = <String>["Semua"].obs;

  @override
  void onInit() {
    super.onInit();
    listYear.addAll(List.generate(
      DateTime.now().year - 2020 + 1,
      (index) => (2020 + index).toString(),
    ));
  }

  void changePage(int value) {
    pageIndex(value);
  }

  void switchList() {
    isExpense.toggle();
    update();
    listData();
  }

  void listData() async {
    isLoading = true;
    update();
    listExpense.value = await dbService.fetchListData();
    listExpense.value = listExpense
        .where((e) =>
            isExpense.value ? e.type != "Pemasukan" : e.type == "Pemasukan")
        .toList();
    if (isFilter) {
      _groupByDate(listExpenseFilter, expenseData);
    } else {
      _groupByDate(listExpense, expenseData);
    }
    isLoading = false;
    update();
  }

  void filterData(Map<String, String> data) {
    filterValue(data);
    if (data["type"] == "Semua" &&
        data["payment"] == "Semua" &&
        data["year"] == "Semua" &&
        data["month"] == "0") {
      isFilter = false;
      listData();
      return;
    }
    List<Expense> temp = listExpense;
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
    isFilter = true;
    listExpenseFilter.value = temp;
    listData();
  }

  void deleteData(String id) async {
    await dbService.deleteData(id);
    listData();
    update();
  }

  List<Expense> get _weekExpenses {
    DateTime now = DateUtils.dateOnly(DateTime.now());
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
    return listExpense.where((tx) {
      // String date = DateTime.now().toString();
      // String firstDay = '${date.substring(0, 8)}01${date.substring(10)}';

      // int weekDay = DateTime.parse(firstDay).weekday;

      // int selisih = (7 - weekDay) + 1;

      // DateTime todayDate = DateTime.now();

      // weekDay--;
      // int weekOfMonth = ((todayDate.day + weekDay) / 7).ceil();
      // int firstMondayWeek =
      //     (weekOfMonth - 1) * (selisih + 1) + (weekOfMonth - 2);
      // return tx.date.isAfter(
      //       DateTime.now().subtract(
      //         Duration(days: todayDate.day - firstMondayWeek + 1),
      //       ),
      //     ) &&
      //     tx.date.month == DateTime.now().month;
      return tx.date.isAfter(startOfWeek) &&
          tx.date.isBefore(endOfWeek) &&
          tx.date.month == now.month;
    }).toList();
  }

  Map<String, dynamic> totalSpending() {
    final DateTime now = DateTime.now();
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

    List<Expense> todayExpense = listExpense
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
}
