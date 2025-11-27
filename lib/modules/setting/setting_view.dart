import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../base/widgets/base_app_bar.dart' show BaseAppBar;
import 'setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(
        postFixtitleText: " - Setting",
        centerTitle: false,
      ),
      body: GetBuilder(
        init: controller,
        builder: (controller) {
          return Column(
            children: [
              Card(
                child: ListTile(
                  trailing: const Icon(Icons.download, color: Colors.purple),
                  title: const Text("Export CSV"),
                  onTap: controller.exportToCSV,
                ),
              ),
              Card(
                child: ListTile(
                  trailing: const Icon(Icons.upload, color: Colors.purple),
                  title: const Text("Import CSV"),
                  onTap: controller.importFromCSV,
                ),
              ),
              Card(
                child: ListTile(
                  trailing: const Icon(Icons.refresh, color: Colors.purple),
                  title: const Text("Reset Data"),
                  onTap: controller.resetData,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
