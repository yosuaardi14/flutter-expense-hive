import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_expense_app/models/budget.dart';
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
    listExpense.value = await expenseService.fetchListData(reload: true);
    List<List<dynamic>> data = [...listExpense.map((e) => e.toList())];
    CsvUtil.export(data, type: "EXPENSE");
  }

  void exportBudgetToCSV() async {
    listBudget.value = await budgetService.fetchListDataBudget(reload: true);
    List<List<dynamic>> data = [...listBudget.map((e) => e.toList())];
    CsvUtil.export(data, type: "BUDGET");
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
    final result = await FilePicker.pickFiles(
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
    if (result == null || result.isEmpty) {
      return GF.showInformationDialog("Peringatan", "Data tidak ditemukan");
    }
    try {
      int counter = 0;
      // Insert data -> Import sebagai data baru
      if (importMode.value == "Insert") {
        for (var i = 0; i < result.length; i++) {
          if (result[i].length != Expense.props().length) {
            continue;
          }
          // Import semua data yang belum ada
          Expense expense = Expense.fromList(result[i]);
          // Expense? expenseData = await dbService.fetchData(expense.id);
          // if (expenseData == null) {
          //   await dbService.insertData(expense.toMap());
          // }
          // // Import semua data sebagai data baru
          expense.id = DateTime.now().toString();
          await expenseService.insertData(expense.toMap());
          counter++;
        }
      }
      // Merge data -> Menambahkan data yang belum ada
      else if (importMode.value == "Merge") {
        for (var i = 0; i < result.length; i++) {
          if (result[i].length != Expense.props().length) {
            continue;
          }
          // Import semua data yang belum ada
          Expense expense = Expense.fromList(result[i]);
          Expense? expenseData = await expenseService.fetchData(expense.id);
          if (expenseData == null) {
            await expenseService.insertData(expense.toMap());
            counter++;
          }
        }
      }
      // Replace data -> Hapus semua data lama, Menambahkan data baru
      else if (importMode.value == "Replace") {
        await expenseService.deleteAllData();
        for (var i = 0; i < result.length; i++) {
          if (result[i].length != Expense.props().length) {
            continue;
          }
          await expenseService.insertData(Expense.fromList(result[i]).toMap());
          counter++;
        }
      }
      // Update data -> Jika id sama maka update data
      else if (importMode.value == "Update") {
        for (var i = 0; i < result.length; i++) {
          if (result[i].length != Expense.props().length) {
            continue;
          }
          Expense expense = Expense.fromList(result[i]);
          Expense? expenseData = await expenseService.fetchData(expense.id);
          if (expenseData != null) {
            await expenseService.updateData(expense.id, expense.toMap());
          } else {
            await expenseService.insertData(expense.toMap());
          }
          counter++;
        }
      }
      if (counter > 0) {
        GF.showInformationDialog(
          "Berhasil",
          "Import data Expense Berhasil ($counter dari ${result.length})",
        );
      } else {
        GF.showInformationDialog("Gagal", "Tidak ada data yang diimport");
      }
    } catch (e) {
      GF.showInformationDialog("Gagal", "Import data Expense gagal");
    }
  }

  void importBudgetFromCSV() async {
    resetForm();
    final result = await Get.bottomSheet<List<List<dynamic>>?>(
      const ImportDialog(),
    );
    if (result == null || result.isEmpty) {
      return GF.showInformationDialog("Peringatan", "Data tidak ditemukan");
    }
    try {
      int counter = 0;
      // Insert data -> Import sebagai data baru
      if (importMode.value == "Insert") {
        for (var i = 0; i < result.length; i++) {
          if (result[i].length != Budget.props().length) {
            continue;
          }
          // Import semua data yang belum ada
          Budget budget = Budget.fromList(result[i]);
          // Expense? expenseData = await dbService.fetchData(expense.id);
          // if (expenseData == null) {
          //   await dbService.insertData(expense.toMap());
          // }
          // // Import semua data sebagai data baru
          budget.id = DateTime.now().toString();
          await budgetService.insertDataBudget(budget.toMap());
          counter++;
        }
      }
      // Merge data -> Menambahkan data yang belum ada
      else if (importMode.value == "Merge") {
        for (var i = 0; i < result.length; i++) {
          if (result[i].length != Budget.props().length) {
            continue;
          }
          // Import semua data yang belum ada
          Budget budget = Budget.fromList(result[i]);
          Budget? budgetData = await budgetService.fetchDataBudget(budget.id);
          if (budgetData == null) {
            await budgetService.insertDataBudget(budget.toMap());
            counter++;
          }
        }
      }
      // Replace data -> Hapus semua data lama, Menambahkan data baru
      else if (importMode.value == "Replace") {
        await budgetService.deleteAllDataBudget();
        for (var i = 0; i < result.length; i++) {
          if (result[i].length != Budget.props().length) {
            continue;
          }
          await budgetService.insertDataBudget(
            Expense.fromList(result[i]).toMap(),
          );
          counter++;
        }
      }
      // Update data -> Jika id sama maka update data
      else if (importMode.value == "Update") {
        for (var i = 0; i < result.length; i++) {
          if (result[i].length != Budget.props().length) {
            continue;
          }
          Budget budget = Budget.fromList(result[i]);
          Budget? budgetData = await budgetService.fetchDataBudget(budget.id);
          if (budgetData != null) {
            await budgetService.updateDataBudget(budget.id, budget.toMap());
          } else {
            await budgetService.insertDataBudget(budget.toMap());
          }
          counter++;
        }
      }
      if (counter > 0) {
        GF.showInformationDialog(
          "Berhasil",
          "Import data Expense Berhasil ($counter dari ${result.length})",
        );
      } else {
        GF.showInformationDialog("Gagal", "Tidak ada data yang diimport");
      }
    } catch (e) {
      GF.showInformationDialog("Gagal", "Import data Budget gagal");
    }
  }

  void resetData() async {
    final result = await GF.showConfirmationDeleteDialog(
      message: "Apakah Anda yakin ingin menghapus semua data Expense?",
    );
    if (result) {
      await expenseService.deleteAllData();
    }
  }

  void resetDataBudget() async {
    final result = await GF.showConfirmationDeleteDialog(
      message: "Apakah Anda yakin ingin menghapus semua data Budget?",
    );
    if (result) {
      await budgetService.deleteAllDataBudget();
    }
  }

  void resetForm() {
    file.value = null;
    fileController.text = "";
    importMode.value = "Merge";
    update();
  }
}
