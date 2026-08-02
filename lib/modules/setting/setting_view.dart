import 'package:flutter/material.dart';
import 'package:flutter_expense_app/modules/base/widgets/base_drawer.dart';
import 'package:get/get.dart';

import '../base/widgets/base_app_bar.dart' show BaseAppBar;
import 'setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(
        titleText: "Setting",
        // postFixtitleText: " - Setting",
        centerTitle: false,
      ),
      drawer: const BaseDrawer(),
      body: GetBuilder(
        init: controller,
        builder: (controller) {
          return Column(
            children: [
              Card(
                child: ListTile(
                  trailing: const Icon(Icons.download, color: Colors.purple),
                  title: const Text("Export Expense CSV"),
                  onTap: controller.exportToCSV,
                ),
              ),
              Card(
                child: ListTile(
                  trailing: const Icon(Icons.upload, color: Colors.purple),
                  title: const Text("Import Expense CSV"),
                  onTap: controller.importFromCSV,
                ),
              ),
              Card(
                child: ListTile(
                  trailing: const Icon(Icons.refresh, color: Colors.purple),
                  title: const Text("Reset Data Expense"),
                  onTap: controller.resetData,
                ),
              ),
              const Divider(),
              Card(
                child: ListTile(
                  trailing: const Icon(Icons.download, color: Colors.purple),
                  title: const Text("Export Budget CSV"),
                  onTap: controller.exportBudgetToCSV,
                ),
              ),
              Card(
                child: ListTile(
                  trailing: const Icon(Icons.upload, color: Colors.purple),
                  title: const Text("Import Budget CSV"),
                  onTap: controller.importBudgetFromCSV,
                ),
              ),
              Card(
                child: ListTile(
                  trailing: const Icon(Icons.refresh, color: Colors.purple),
                  title: const Text("Reset Data Budget"),
                  onTap: controller.resetDataBudget,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
