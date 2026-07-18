import 'package:flutter_expense_app/modules/expense_detail/views/expense_detail_view.dart';
import 'package:get/get.dart';

import '../../../models/expense.dart';
import '../../../utils/constant.dart';
import '../../base/controllers/expense_base_controller.dart';

class ExpenseCalendarController extends ExpenseBaseController {
  final daysInMonth = 28.obs;
  final type = Constant.dropdownType[0].obs;
  final payment = Constant.dropdownPayment[0].obs;
  final startWeekDay = 0.obs;
  final sisaWeekDay = 0.obs;
  final mode = "Outcome".obs;
  final month = "0".obs;
  final year = "2025".obs;
  final listYear = <String>[].obs;
  final selectedPayment = [...Constant.dropdownPayment].obs;
  final totalSpendMap = <String, double>{
    "Bulan ini": 0.0,
    "Bulan lalu": 0.0,
    "Tahun ini": 0.0,
  }.obs;

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
    listYear.value = listYear.reversed.toList();
  }

  @override
  void onReady() {
    update();
  }

  void listData() async {
    showLoading();

    listExpense.value = await expenseService.fetchListFilterData(
      mode.value == "Outcome",
      type.value != "Semua" && mode.value == "Outcome" ? type.value : null,
      selectedPayment,
      DateTime(int.parse(year.value), int.parse(month.value), 1),
      DateTime(int.parse(year.value), int.parse(month.value) + 1, 1),
    );

    final now = DateTime.now();
    totalSpendMap.value = {
      "Bulan ini": await expenseService.sumRange(
        mode.value == "Outcome",
      DateTime(int.parse(year.value), int.parse(month.value), 1),
      DateTime(int.parse(year.value), int.parse(month.value) + 1, 1),
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
    };

    calculateDayInMonth();
    groupByDate(listExpense, expenseData);
    hideLoading();
  }

  void calculateDayInMonth() {
    int monthParam = int.parse(month.value);
    int yearParam = int.parse(year.value);
    final firstDayOfNextMonth = DateTime(yearParam, monthParam + 1, 1);
    final lastDayOfThisMonth = firstDayOfNextMonth.subtract(
      const Duration(days: 1),
    );
    daysInMonth.value = lastDayOfThisMonth.day;
    startWeekDay.value = DateTime(yearParam, monthParam, 1).weekday - 1;
    sisaWeekDay.value = (startWeekDay.value + daysInMonth.value) % 7;
  }

  double totalSpendByDay(int day) {
    String dayStr = day.toString().padLeft(2, '0');
    List<Expense>? data =
        expenseData["$dayStr-${month.value.padLeft(2, '0')}-${year.value}"];
    return calcTotalSpending(data);
  }

  void showDetail(int day) {
    String dayStr = day.toString().padLeft(2, '0');
    List<Expense>? data =
        expenseData["$dayStr-${month.value.padLeft(2, '0')}-${year.value}"];
    Get.bottomSheet(ExpenseDetailView(data: data));
  }
}
