import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_expense_app/models/expense.dart';
import 'package:flutter_expense_app/modules/base/controllers/expense_base_controller.dart';
import 'package:flutter_expense_app/utils/csv_util.dart';
import 'package:flutter_expense_app/utils/global_functions.dart';
import 'package:get/get.dart';

import 'import_dialog.dart';

class SettingController extends ExpenseBaseController {
  final file = Rx<PlatformFile?>(null);
  final fileController = TextEditingController();
  final importMode = "Merge".obs;

  void exportToCSV() async {
    listExpense.value = await dbService.fetchListData();
    List<List<dynamic>> data = [...listExpense.map((e) => e.toList())];
    CsvUtil.export(data);
  }

  void onClickImport() {
    if (file.value?.bytes != null) {
      Get.back(result: CsvUtil.import(file.value!.bytes!));
    } else {
      GF.showInformationDialog("Peringatan", "Anda belum memilih File");
    }
  }

  void onChangedImportMode(String? val) {
    importMode.value = val ?? "Merge";
    update();
  }

  void onChooseFile() async {
    final result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: ["csv"],
      allowMultiple: false,
    );
    file.value = result?.files.first;
    fileController.text = result?.files.first.name ?? "";
    update();
    // if (result != null) {
    //   file.value = result.files.first;
    //   fileController.text = result.files.first.name;
    // } else {
    //   file.value = null;
    //   fileController.text = "";
    // }
  }

  void importFromCSV() async {
    resetForm();
    final result = await Get.bottomSheet<List<List<dynamic>>?>(
      const ImportDialog(),
    );
    if (result == null) {
      return;
    }
    // Insert data -> Import sebagai data baru
    if (importMode.value == "Insert") {
      for (var i = 0; i < result.length; i++) {
        // Import semua data yang belum ada
        Expense expense = Expense.fromList(result[i]);
        // Expense? expenseData = await dbService.fetchData(expense.id);
        // if (expenseData == null) {
        //   await dbService.insertData(expense.toMap());
        // }
        // // Import semua data sebagai data baru
        expense.id = DateTime.now().toString();
        await dbService.insertData(expense.toMap());
      }
      GF.showInformationDialog("Berhasil", "Import data Berhasil");
    }
    // Merge data -> Menambahkan data yang belum ada
    else if (importMode.value == "Merge") {
      for (var i = 0; i < result.length; i++) {
        // Import semua data yang belum ada
        Expense expense = Expense.fromList(result[i]);
        Expense? expenseData = await dbService.fetchData(expense.id);
        if (expenseData == null) {
          await dbService.insertData(expense.toMap());
        }
      }
      GF.showInformationDialog("Berhasil", "Import data Berhasil");
    }
    // Replace data -> Hapus semua data lama, Menambahkan data baru
    else if (importMode.value == "Replace") {
      await dbService.deleteAllData();
      for (var i = 0; i < result.length; i++) {
        await dbService.insertData(Expense.fromList(result[i]).toMap());
      }
      GF.showInformationDialog("Berhasil", "Import data Berhasil");
    }
    // Update data -> Jika id sama maka update data
    else if (importMode.value == "Update") {
      for (var i = 0; i < result.length; i++) {
        Expense expense = Expense.fromList(result[i]);
        Expense? expenseData = await dbService.fetchData(expense.id);
        if (expenseData != null) {
          await dbService.updateData(expense.id, expense.toMap());
        } else {
          await dbService.insertData(expense.toMap());
        }
      }
      GF.showInformationDialog("Berhasil", "Import data Berhasil");
    }
  }

  void resetData() async {
    final result = await GF.showConfirmationDeleteDialog(
      message: "Apakah Anda yakin ingin menghapus semua data?",
    );
    if (result) {
      await dbService.deleteAllData();
    }
  }

  void resetForm() {
    file.value = null;
    fileController.text = "";
    importMode.value = "Merge";
    update();
  }
}
