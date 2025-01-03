// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:collection/collection.dart";
import 'package:intl/intl.dart';

import '../../../models/expense.dart';
import '../../../utils/global_functions.dart';
import '../../base/controllers/expense_base_controller.dart';

class ExpenseListController extends ExpenseBaseController {
  bool showChart = true;
  bool showList = true;
  bool isLoading = false;
  bool isFilter = false;
  final pageIndex = 0.obs;
  final filterValue = {
    "type": "Semua",
    "payment": "Semua",
    "month": DateTime.now().month.toString(),
    "year": DateTime.now().year.toString(),
  }.obs;
  final listExpenseMaster = <Expense>[].obs;
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
    isFilter = false;
    filterValue({
      "type": "Semua",
      "payment": "Semua",
      "month": DateTime.now().month.toString(),
      "year": DateTime.now().year.toString(),
    });
    listData();
  }

  void listData() async {
    print("listData");
    isLoading = true;
    update();
    listExpense.value = await dbService.fetchListData();
    listExpenseMaster.value = List<Expense>.from(listExpense);
    listExpense.value = listExpense
        .where((e) =>
            isExpense.value ? e.type != "Pemasukan" : e.type == "Pemasukan")
        .toList();
    // if (isFilter) {
    //   _groupByDate(listExpenseMaster, expenseData);
    // } else {
    //   _groupByDate(listExpense, expenseData);
    // }
    if (filterValue["month"] != "0") {
      listExpense.value = listExpense
          .where((element) =>
              element.date.month == int.parse(filterValue["month"].toString()))
          .toList();
    }
    if (filterValue["year"] != "Semua") {
      listExpense.value = listExpense
          .where((element) =>
              element.date.year == int.parse(filterValue["year"].toString()))
          .toList();
    }
    if (filterValue["type"] != "Semua") {
      listExpense.value = listExpense
          .where((element) => element.type == filterValue["type"])
          .toList();
    }
    if (filterValue["payment"] != "Semua") {
      listExpense.value = listExpense
          .where((element) => element.payment == filterValue["payment"])
          .toList();
    }
    _groupByDate(listExpense, expenseData);
    isLoading = false;
    update();
  }

  void filterData(Map<String, String> data) {
    if (!isExpense.value) {
      data["type"] = "Semua";
      data["payment"] = "Semua";
    }
    filterValue(data);
    listData();
    // if (data["type"] == "Semua" &&
    //     data["payment"] == "Semua" &&
    //     data["year"] == "Semua" &&
    //     data["month"] == "0") {
    //   isFilter = false;
    //   listData();
    //   return;
    // }
    // List<Expense> temp = listExpense;
    // if (data["month"] != "0") {
    //   temp = temp
    //       .where((element) =>
    //           element.date.month == int.parse(data["month"].toString()))
    //       .toList();
    // }
    // if (data["year"] != "Semua") {
    //   temp = temp
    //       .where((element) =>
    //           element.date.year == int.parse(data["year"].toString()))
    //       .toList();
    // }
    // if (data["type"] != "Semua") {
    //   temp = temp.where((element) => element.type == data["type"]).toList();
    // }
    // if (data["payment"] != "Semua") {
    //   temp =
    //       temp.where((element) => element.payment == data["payment"]).toList();
    // }
    // isFilter = true;
    // listExpenseMaster.value = temp;
    // listData();
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
    return listExpenseMaster.where((tx) {
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
    List<Expense> yearExpense = listExpenseMaster
        .where((element) => element.date.year == now.year)
        .toList();

    List<Expense> lastMonthExpense = listExpenseMaster
        .where((element) =>
            element.date.month == now.month - 1 &&
            element.date.year == now.year)
        .toList();

    List<Expense> monthExpense = listExpenseMaster
        .where((element) =>
            element.date.month == now.month && element.date.year == now.year)
        .toList();

    List<Expense> todayExpense = listExpenseMaster
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
      "Tahun ini": totalSpend(yearExpense),
      "List": totalSpend(listExpense)
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
