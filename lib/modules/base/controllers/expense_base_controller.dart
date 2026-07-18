// ignore_for_file: depend_on_referenced_packages

import "package:collection/collection.dart";
import 'package:flutter_expense_app/utils/global_functions.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/interfaces/crud_service.dart';
import '../../../models/budget.dart';
import '../../../models/expense.dart';
// import '../../../services/hive_service.dart';
// import '../../../services/db_service.dart';
import 'base_controller.dart';

abstract class ExpenseBaseController extends BaseController {
  // HiveService dbService = HiveService.instance;
  // DBService dbService = DBService.instance;
  final listExpense = <Expense>[].obs;
  final listBudget = <Budget>[].obs;
  final expenseData = <String, dynamic>{}.obs;

  final expenseService = Get.find<ExpenseCrudService>();
  final budgetService = Get.find<BudgetCrudService>();

  void groupByDate(
    RxList<Expense> list,
    RxMap<String, dynamic> data, {
    bool ascending = false,
  }) {
    final grouped = groupBy(
      list,
      (e) => DateFormat('dd-MM-yyyy').format(e.date),
    );

    final sorted = Map.fromEntries(
      grouped.entries.toList()..sort(
        (a, b) => ascending
            ? GF.stringToDateTime(a.key).compareTo(GF.stringToDateTime(b.key))
            : GF.stringToDateTime(b.key).compareTo(GF.stringToDateTime(a.key)),
      ),
    );

    data.value = sorted;
  }

  double calcTotalSpending(List<Expense>? data) {
    if (data == null) return 0;
    return data.fold(0.0, (sum, item) => sum + item.amount);
  }
}
