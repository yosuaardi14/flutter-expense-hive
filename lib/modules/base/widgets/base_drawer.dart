import 'package:flutter/material.dart';
import 'package:flutter_expense_app/routes/app_pages.dart';
import 'package:get/get.dart';

class BaseDrawer extends StatelessWidget {
  const BaseDrawer({super.key});

  static const Map<String, dynamic> drawerItem = {
    // "Home": Routes.HOME,
    "Expense": Routes.EXPENSE,
    "Budget": Routes.BUDGET,
    "Setting": Routes.SETTING,
  };

  Icon getIcon(String menu) {
    switch (menu) {
      case "Home":
        return const Icon(Icons.home);
      case "Expense":
        return const Icon(Icons.attach_money);
      case "Budget":
        return const Icon(Icons.account_balance_wallet);
      case "Setting":
        return const Icon(Icons.settings);
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
              child: Column(
                spacing: 10,
                children: [
                  const FlutterLogo(
                    size: 200,
                    style: FlutterLogoStyle.markOnly,
                    textColor: Colors.white,
                  ),
                  Text("Expense App", style: TextStyle(color: Colors.white, fontSize: 36)),
                ],
              ),
            ),
            ...drawerItem.entries.map((e) {
              return ListTile(
                leading: getIcon(e.key),
                title: Text(e.key),
                selected: currentRoute == e.value,
                onTap: currentRoute != e.value
                    ? () => Get.offNamed(e.value)
                    : null,
              );
            }),
          ],
        ),
      ),
    );
  }
}
