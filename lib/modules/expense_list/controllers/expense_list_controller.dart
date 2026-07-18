// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_expense_app/utils/constant.dart';
import 'package:get/get.dart';

import '../../base/controllers/expense_base_controller.dart';

class ExpenseListController extends ExpenseBaseController {
  bool showChart = true;
  bool showList = true;
  bool isFilter = false;
  final pageIndex = 0.obs;
  final filterValue = {
    "type": "Semua",
    "payment": "Semua",
    "source": "Semua",
    "month": DateTime.now().month.toString(),
    "year": DateTime.now().year.toString(),
  }.obs;
  final isExpense = true.obs;
  final listYear = <String>[].obs;
  final selectedPayment = [...Constant.dropdownPayment].obs;
  final totalSpendMap = <String, double>{
    "Hari ini": 0.0,
    "Minggu ini": 0.0,
    "Bulan ini": 0.0,
    "Bulan lalu": 0.0,
    "Tahun ini": 0.0,
    "List": 0.0,
  }.obs;

  @override
  void onInit() {
    super.onInit();
    listYear.addAll(
      List.generate(
        DateTime.now().year - 2020 + 1,
        (index) => (2020 + index).toString(),
      ).reversed,
    );
  }

  void changePage(int value) {
    pageIndex(value);
  }

  void switchList() {
    isExpense.toggle();
    update();
    isFilter = false;
    filterValue["type"] = "Semua";
    filterValue.refresh();
    listData();
  }

  void listData() async {
    showLoading();

    listExpense.value = await expenseService.fetchListFilterData(
      isExpense.value,
      filterValue["type"] != "Semua" ? filterValue["type"] : null,
      selectedPayment,
      DateTime(
        int.parse(filterValue["year"].toString()),
        int.parse(filterValue["month"].toString()),
        1,
      ),
      DateTime(
        int.parse(filterValue["year"].toString()),
        int.parse(filterValue["month"].toString()) + 1,
        1,
      ),
    );

    final now = DateUtils.dateOnly(DateTime.now());
    // Minggu
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 7));
    // Bulan
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 1);
    // Irisan minggu ∩ bulan
    final startOfWeek = weekStart.isBefore(monthStart) ? monthStart : weekStart;
    final endOfWeek = weekEnd.isAfter(monthEnd) ? monthEnd : weekEnd;

    totalSpendMap.value = {
      "Hari ini": await expenseService.sumRange(
        isExpense.value,
        now,
        now.add(Duration(days: 1)),
      ),
      "Minggu ini": await expenseService.sumRange(
        isExpense.value,
        startOfWeek,
        endOfWeek,
      ),
      "Bulan ini": await expenseService.sumRange(
        isExpense.value,
        DateTime(now.year, now.month, 1),
        DateTime(now.year, now.month + 1),
      ),
      "Bulan lalu": await expenseService.sumRange(
        isExpense.value,
        DateTime(now.year, now.month - 1, 1),
        DateTime(now.year, now.month, 1),
      ),
      "Tahun ini": await expenseService.sumRange(
        isExpense.value,
        DateTime(now.year, 1, 1),
        DateTime(now.year + 1, 1, 1),
      ),
      "List": calcTotalSpending(listExpense),
    };
    groupByDate(listExpense, expenseData);
    hideLoading();
  }

  void filterData(Map<String, String> data) {
    data["type"] = "Semua";
    filterValue(data);
    listData();
  }

  void deleteData(String id) async {
    await expenseService.deleteData(id);
    listData();
    update();
  }
}
