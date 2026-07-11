import 'package:flutter/material.dart';
import 'package:flutter_expense_app/modules/expense_home/controllers/expense_home_controller.dart';
// import 'package:flutter_expense_app/modules/setting/setting_view.dart';
import 'package:get/get.dart';

import '../../expense_calendar/views/expense_calendar_view.dart';
import '../../expense_list/views/expense_list_view.dart';
import '../../expense_table/views/expense_table_view.dart';

class ExpenseHomeView extends GetView<ExpenseHomeController> {
  const ExpenseHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        onPageChanged: controller.onChange,
        children: const [
          ExpenseTableView(),
          ExpenseCalendarView(),
          ExpenseListView(),
          // SettingView(),
        ],
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
              label: "Table",
              icon: Icon(Icons.table_view_outlined),
            ),
            BottomNavigationBarItem(
              label: "Calendar",
              icon: Icon(Icons.calendar_month),
            ),
            BottomNavigationBarItem(label: "List", icon: Icon(Icons.list_alt)),
            // BottomNavigationBarItem(
            //   label: "Setting",
            //   icon: Icon(Icons.settings),
            // ),
          ],
        ),
      ),
    );
  }
}
