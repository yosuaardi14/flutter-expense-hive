import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'setting_controller.dart';

class ImportDialog extends GetView<SettingController> {
  const ImportDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controller,
      builder: (controller) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  onTap: controller.onChooseFile,
                  decoration: const InputDecoration(labelText: 'File'),
                  readOnly: true,
                  controller: controller.fileController,
                ),
                const SizedBox(height: 10),
                Text("Mode"),
                RadioGroup(
                  groupValue: controller.importMode.value,
                  onChanged: controller.onChangedImportMode,
                  child: Column(
                    children: [
                      RadioListTile(
                        title: Text("Merge"),
                        subtitle: Text("Impor data yang belum ada"),
                        isThreeLine: true,
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        visualDensity: VisualDensity(
                          horizontal: -4,
                          vertical: -4,
                        ),
                        value: "Merge",
                      ),
                      RadioListTile(
                        title: Text("Replace"),
                        subtitle: Text("Menghapus semua data lama dan mengimpor semua data"),
                        isThreeLine: true,
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        visualDensity: VisualDensity(
                          horizontal: -4,
                          vertical: -4,
                        ),
                        value: "Replace",
                      ),
                      RadioListTile(
                        title: Text("Insert"),
                        subtitle: Text("Impor semua data sebagai data baru"),
                        isThreeLine: true,
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        visualDensity: VisualDensity(
                          horizontal: -4,
                          vertical: -4,
                        ),
                        value: "Insert",
                      ),
                      RadioListTile(
                        title: Text("Update"),
                        subtitle: Text("Mengubah data dan menambahkan data yang belum ada"),
                        isThreeLine: true,
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        visualDensity: VisualDensity(
                          horizontal: -4,
                          vertical: -4,
                        ),
                        value: "Update",
                      ),
                    ],
                  ),
                ),
                // Radio(value: false, groupValue: true, onChanged: (v) {}),
                // RadioMenuButton(
                //   value: false,
                //   groupValue: true,
                //   onChanged: (v) {},
                //   child: Text("data"),
                // ),
                ElevatedButton(
                  onPressed: controller.onClickImport,
                  child: Text("Import"),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
