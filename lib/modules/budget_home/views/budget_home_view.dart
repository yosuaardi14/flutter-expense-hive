import 'package:flutter/material.dart';
import 'package:flutter_expense_app/modules/budget_dashboard/views/budget_dashboard_view.dart';
import 'package:flutter_expense_app/modules/budget_list/views/budget_list_view.dart';
import 'package:get/get.dart';

import '../controllers/budget_home_controller.dart';

class BudgetHomeView extends GetView<BudgetHomeController> {
  const BudgetHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        onPageChanged: controller.onChange,
        children: const [
          BudgetDashboardView(),
          // ExpenseCalendarView(),
          BudgetListView(),
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
              label: "Dashboard",
              icon: Icon(Icons.dashboard),
            ),
            // BottomNavigationBarItem(
            //   label: "Calendar",
            //   icon: Icon(Icons.calendar_month),
            // ),
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
