import 'package:flutter/material.dart';
import 'package:flutter_expense_app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';

import '../../expense_calendar/views/expense_calendar_view.dart';
import '../../expense_list/views/expense_list_view.dart';
import '../../expense_table/views/expense_table_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          // Obx(
          //   () {
          // Get.lazyPut(() => ExpenseListController());
          // Get.lazyPut(() => ExpenseCalendarController());
          // Get.lazyPut(() => ExpenseTableController());
          // return
          PageView(
        controller: controller.pageController,
        onPageChanged: controller.onChange,
        // index: controller.currentIndex.value,
        children: const [
          ExpenseListView(), ExpenseCalendarView(), ExpenseTableView(),
          // GetBuilder<ExpenseListController>(
          //   init: ExpenseListController(),
          //   builder: (controller) => const ExpenseListView(),
          // ),
          // GetBuilder<ExpenseCalendarController>(
          //   init: ExpenseCalendarController(),
          //   builder: (controller) => const ExpenseCalendarView(),
          // ),
          // GetBuilder<ExpenseTableController>(
          //   init: ExpenseTableController(),
          //   builder: (controller) => const ExpenseTableView(),
          // ),
        ],
        // builder: (context) {
        //   return Obx(
        //     () {
        //       switch (controller.currentIndex.value) {
        //         case 0:
        //           Get.lazyPut(() => ExpenseListController());
        //           return const ExpenseListView();
        //         case 1:
        //           Get.lazyPut(() => ExpenseCalendarController());
        //           return const ExpenseCalendarView();
        //         case 2:
        //           Get.lazyPut(() => ExpenseTableController());
        //           return const ExpenseTableView();
        //       }
        //       return const SizedBox();
        //     },
        //   );
        // },
        //   );
        // },
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: controller.currentIndex.value,
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.black,
          onTap: controller.onChange,
          items: const [
            BottomNavigationBarItem(
              label: "List",
              icon: Icon(Icons.list_alt),
            ),
            BottomNavigationBarItem(
              label: "Calendar",
              icon: Icon(Icons.calendar_month),
            ),
            BottomNavigationBarItem(
              label: "Table",
              icon: Icon(Icons.table_view_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
