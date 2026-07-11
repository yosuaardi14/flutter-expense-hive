import 'package:flutter/material.dart';
import 'package:flutter_expense_app/modules/budget_dashboard/controllers/budget_dashboard_controller.dart';
import 'package:flutter_expense_app/modules/budget_list/controllers/budget_list_controller.dart';
import 'package:get/get.dart';

class BudgetHomeController extends GetxController {
  final PageController pageController = PageController();
  final currentIndex = 0.obs;

  @override
  void onInit() {
    Get.lazyPut(() => BudgetDashboardController());
    Get.lazyPut(() => BudgetListController());
    super.onInit();
  }

  void onChange(int value) {
    currentIndex(value);
    pageController.jumpToPage(value);
  }
}
