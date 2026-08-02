import 'package:flutter_expense_app/models/budget.dart';
import 'package:flutter_expense_app/modules/base/controllers/expense_base_controller.dart';
import 'package:flutter_expense_app/modules/budget_add/controllers/budget_add_controller.dart';
import 'package:flutter_expense_app/modules/budget_add/views/budget_add_view.dart';
import 'package:get/get.dart';

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
    listData();
  }

  @override
  void onReady() {
    update();
  }

  void listData() async {
    showLoading();

    currentListBudget.value = await budgetService.fetchListFilterDataBudget(
      null,
      null,
      int.tryParse(month.value),
      int.tryParse(year.value),
    );
    update();

    hideLoading();
  }

  void addBudget({String? category}) {
    Get.put(BudgetAddController()).checkArguments({
      "category": category,
      "year": year.value,
      "month": month.value,
    });
    Get.bottomSheet(const BudgetAddView()).whenComplete(() {
      listData();
      Get.delete<BudgetAddController>();
    });
  }

  void editBudget(Budget budget) {
    Get.put(BudgetAddController()).checkArguments(budget.parentid ?? budget.id);
    Get.bottomSheet(const BudgetAddView()).whenComplete(() {
      listData();
      Get.delete<BudgetAddController>();
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
