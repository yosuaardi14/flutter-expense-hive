import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/budget.dart';
import '../../base/controllers/expense_base_controller.dart';
import '../../budget_add/views/budget_add_view.dart';

class BudgetListController extends ExpenseBaseController {
  final currentListBudget = <Budget>[].obs;

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
    listYear.value = listYear.reversed.toList();
  }

  @override
  void onReady() {
    listData();
  }

  void listData() async {
    currentListBudget.value = await budgetService.fetchListFilterDataBudget(
      null,
      null,
      int.tryParse(month.value),
      int.tryParse(year.value),
    );
  }

  void addBudget({String? category}) {
    Get.bottomSheet(
      const BudgetAddView(),
      settings: RouteSettings(
        arguments: {
          "category": category,
          "year": year.value,
          "month": month.value,
        },
      ),
    ).whenComplete(() {
      listData();
    });
  }

  void editBudget(Budget budget) {
    Get.bottomSheet(
      const BudgetAddView(),
      settings: RouteSettings(arguments: budget.parentid ?? budget.id),
    ).whenComplete(() {
      listData();
    });
  }

  void deleteBudget(Budget budget) async {
    if (budget.parentid == null) {
      List<Budget> children = await budgetService.fetchListDataBudgetByParentId(
        budget.id,
      );
      for (Budget child in children) {
        await budgetService.deleteDataBudget(child.id);
      }
    }
    await budgetService.deleteDataBudget(budget.id);
    listData();
  }
}
