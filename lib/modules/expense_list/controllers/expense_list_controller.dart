import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constant.dart';
import '../../base/controllers/expense_base_controller.dart';

class ExpenseListController extends ExpenseBaseController {
  final type = Constant.dropdownType[0].obs;
  final mode = "Outcome".obs;
  final month = "0".obs;
  final year = "2026".obs;
  final listYear = <String>[];
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
    month.value = DateTime.now().month.toString();
    year.value = DateTime.now().year.toString();
    listYear.addAll(
      List.generate(
        DateTime.now().year - 2020 + 1,
        (index) => (2020 + index).toString(),
      ).reversed,
    );
  }

  @override
  void onReady() {
    super.onReady();
    listData();
  }

  void listData() async {
    listExpense.value = await expenseService.fetchListFilterData(
      mode.value == "Outcome",
      type.value != "Semua" ? type.value : null,
      selectedPayment,
      DateTime(int.parse(year.value), int.parse(month.value), 1),
      DateTime(int.parse(year.value), int.parse(month.value) + 1, 1),
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
        mode.value == "Outcome",
        now,
        now.add(Duration(days: 1)),
      ),
      "Minggu ini": await expenseService.sumRange(
        mode.value == "Outcome",
        startOfWeek,
        endOfWeek,
      ),
      "Bulan ini": await expenseService.sumRange(
        mode.value == "Outcome",
        DateTime(now.year, now.month, 1),
        DateTime(now.year, now.month + 1),
      ),
      "Bulan lalu": await expenseService.sumRange(
        mode.value == "Outcome",
        DateTime(now.year, now.month - 1, 1),
        DateTime(now.year, now.month, 1),
      ),
      "Tahun ini": await expenseService.sumRange(
        mode.value == "Outcome",
        DateTime(now.year, 1, 1),
        DateTime(now.year + 1, 1, 1),
      ),
      "List": calcTotalSpending(listExpense),
    };
    groupByDate(listExpense, expenseData);
  }

  void deleteData(String id) async {
    await expenseService.deleteData(id);
    listData();
  }
}
