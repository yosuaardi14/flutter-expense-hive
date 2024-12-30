import 'package:flutter/material.dart';
import 'package:flutter_expense_app/routes/app_pages.dart';
import 'package:get/get.dart';

class BaseDrawer extends StatelessWidget {
  const BaseDrawer({super.key});

  static const Map<String, dynamic> drawerItem = {
    "Expense List": Routes.EXPENSE_LIST,
    "Expense Calendar": Routes.EXPENSE_CALENDAR,
    "Expense Table": Routes.EXPENSE_TABLE,
  };

  Icon getIcon(String menu) {
    switch (menu) {
      case "Expense List":
        return const Icon(Icons.list);
      case "Expense Calendar":
        return const Icon(Icons.calendar_month);
      case "Expense Table":
        return const Icon(Icons.table_view_outlined);
    }
    return const Icon(Icons.menu);
  }

  @override
  Widget build(BuildContext context) {
    String? currentRoute = ModalRoute.of(context)?.settings.name;
    return SafeArea(
      child: Drawer(
        child: ListView(
          children: [
            Container(
              color: Colors.purple,
              child: const FlutterLogo(
                size: 250,
                style: FlutterLogoStyle.stacked,
                textColor: Colors.white,
              ),
            ),
            ...drawerItem.entries.map(
              (e) {
                return ListTile(
                  leading: getIcon(e.key),
                  title: Text(e.key),
                  selected: currentRoute == e.value,
                  onTap: currentRoute != e.value
                      ? () => Get.offNamed(e.value)
                      : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
