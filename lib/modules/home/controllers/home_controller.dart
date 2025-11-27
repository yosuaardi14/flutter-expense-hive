import 'package:flutter/material.dart';
import 'package:flutter_expense_app/modules/expense_calendar/controllers/expense_calendar_controller.dart';
import 'package:flutter_expense_app/modules/expense_list/controllers/expense_list_controller.dart';
import 'package:flutter_expense_app/modules/expense_table/controllers/expense_table_controller.dart';
import 'package:flutter_expense_app/modules/setting/setting_controller.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final PageController pageController = PageController();
  final currentIndex = 0.obs;

  @override
  void onInit() {
    Get.lazyPut(() => ExpenseListController());
    Get.lazyPut(() => ExpenseCalendarController());
    Get.lazyPut(() => ExpenseTableController());
    Get.lazyPut(() => SettingController());
    super.onInit();
  }

  void onChange(int value) {
    currentIndex(value);
    pageController.jumpToPage(value);
  }
}
