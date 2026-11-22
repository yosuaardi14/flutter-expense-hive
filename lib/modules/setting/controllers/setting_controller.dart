import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/budget.dart';
import '../../../models/expense.dart';
import '../../../utils/constant.dart';
import '../../../utils/csv_util.dart';
import '../../../utils/global_functions.dart';
import '../../base/controllers/expense_base_controller.dart';
import '../local_widgets/import_dialog.dart';

class SettingController extends ExpenseBaseController {
  final file = Rx<PlatformFile?>(null);
  final fileController = TextEditingController();
  final importMode = Constant.importModeMerge.obs;

  Future<void> exportToCSV() async {
    listExpense.value = await expenseService.fetchListData(reload: true);
    List<List<dynamic>> data = [...listExpense.map((e) => e.toList())];
    await CsvUtil.export(data, type: Constant.expense);
  }

  Future<void> exportBudgetToCSV() async {
    listBudget.value = await budgetService.fetchListDataBudget(reload: true);
    List<List<dynamic>> data = [...listBudget.map((e) => e.toList())];
    await CsvUtil.export(data, type: Constant.budget);
  }

  Future<void> onClickImport() async {
    final bytes = await file.value?.readAsBytes();
    if (bytes != null) {
      Get.back(result: CsvUtil.import(bytes));
    } else {
      GF.showInformationDialog("Peringatan", "Anda belum memilih File");
    }
  }

  void onChangedImportMode(String? val) {
    importMode.value = val ?? Constant.importModeMerge;
  }

  Future<void> onChooseFile() async {
    final result = await FilePicker.pickFile(
      androidOptions: AndroidOptions(),
      webOptions: WebOptions(),
      // withData: true,
      type: FileType.custom,
      allowedExtensions: ["csv"],
      // allowMultiple: false,
    );
    if (result != null && result.extension != "csv") {
      GF.showInformationDialog("Peringatan", "Ekstensi File harus CSV");
      return;
    }
    file.value = result;
    fileController.text = result?.name ?? "";
    // if (result != null) {
    //   file.value = result.files.first;
    //   fileController.text = result.files.first.name;
    // } else {
    //   file.value = null;
    //   fileController.text = "";
    // }
  }

  Future<void> _importCsv<T>({
    required String label,
    required List<List<dynamic>>? rows,
    required int expectedLength,
    required T Function(List<dynamic> row) fromList,
    required Map<String, dynamic> Function(T item) toMap,
    required String Function(T item) getId,
    required void Function(T item, String id) setId,
    required Future<T?> Function(String id) fetch,
    required Future<void> Function(Map<String, dynamic> data) insert,
    required Future<void> Function(String id, Map<String, dynamic> data) update,
    required Future<void> Function() deleteAll,
  }) async {
    if (rows == null) {
      return;
    }
    if (rows.isEmpty) {
      GF.showInformationDialog("Peringatan", "Data tidak ditemukan");
      return;
    }

    try {
      int counter = 0;
      final mode = importMode.value;

      if (mode == Constant.importModeReplace) {
        await deleteAll();
      }

      for (final row in rows) {
        if (row.length != expectedLength) continue; // skip baris invalid

        final item = fromList(row);
        final id = getId(item);

        switch (mode) {
          case Constant.importModeInsert:
            setId(
              item,
              DateTime.now().toString(),
            ); // id baru -> sebagai data baru
            await insert(toMap(item));
            counter++;
            break;

          case Constant.importModeMerge:
            if (await fetch(id) == null) {
              await insert(toMap(item));
              counter++;
            }
            break;

          case Constant.importModeReplace:
            await insert(toMap(item));
            counter++;
            break;

          case Constant.importModeUpdate:
            if (await fetch(id) != null) {
              await update(id, toMap(item));
            } else {
              await insert(toMap(item));
            }
            counter++;
            break;
        }
      }

      GF.showInformationDialog(
        counter > 0 ? "Berhasil" : "Gagal",
        counter > 0
            ? "Import data $label Berhasil ($counter dari ${rows.length})"
            : "Tidak ada data yang diimport",
      );
    } catch (_) {
      GF.showInformationDialog("Gagal", "Import data $label gagal");
    }
  }

  Future<void> importFromCSV() async {
    resetForm();
    final rows = await Get.bottomSheet<List<List<dynamic>>?>(
      const ImportDialog(),
    );
    await _importCsv<Expense>(
      label: Constant.expense,
      rows: rows,
      expectedLength: Expense.props().length,
      fromList: Expense.fromList,
      toMap: (e) => e.toMap(),
      getId: (e) => e.id,
      setId: (e, id) => e.id = id,
      fetch: expenseService.fetchData,
      insert: expenseService.insertData,
      update: expenseService.updateData,
      deleteAll: () => expenseService.deleteAllData(),
    );
  }

  Future<void> importBudgetFromCSV() async {
    resetForm();
    final rows = await Get.bottomSheet<List<List<dynamic>>?>(
      const ImportDialog(),
    );
    await _importCsv<Budget>(
      label: Constant.budget,
      rows: rows,
      expectedLength: Budget.props().length,
      fromList: Budget.fromList,
      toMap: (b) => b.toMap(),
      getId: (b) => b.id,
      setId: (b, id) => b.id = id,
      fetch: (id) => budgetService.fetchDataBudget(id),
      insert: budgetService.insertDataBudget,
      update: budgetService.updateDataBudget,
      deleteAll: () => budgetService.deleteAllDataBudget(),
    );
  }

  Future<void> resetData() async {
    final result = await GF.showConfirmationDeleteDialog(
      message: "Apakah Anda yakin ingin menghapus semua data Expense?",
    );
    if (result) {
      try {
        await expenseService.deleteAllData();
        GF.showInformationDialog(
          "Berhasil",
          "Semua data Expense berhasil dihapus",
        );
      } catch (e) {
        GF.showInformationDialog("Gagal", "Data Expense gagal dihapus");
      }
    }
  }

  Future<void> resetDataBudget() async {
    final result = await GF.showConfirmationDeleteDialog(
      message: "Apakah Anda yakin ingin menghapus semua data Budget?",
    );
    if (result) {
      try {
        await budgetService.deleteAllDataBudget();
        GF.showInformationDialog(
          "Berhasil",
          "Semua data Budget berhasil dihapus",
        );
      } catch (e) {
        GF.showInformationDialog("Gagal", "Data Budget gagal dihapus");
      }
    }
  }

  Future<void> resetDataRange() async {
    final dateRange = await showDateRangePicker(
      context: Get.context!,
      firstDate: DateTime(1800),
      lastDate: DateTime.now(),
    );
    if (dateRange != null) {
      final result = await GF.showConfirmationDeleteDialog(
        message:
            "Apakah Anda yakin ingin menghapus semua data Expense dari ${GF.dateFormatString(dateRange.start)} sampai ${GF.dateFormatString(dateRange.end)}?",
      );
      if (result) {
        try {
          final total = await expenseService.deleteRangeData(
            dateRange.start,
            dateRange.end,
          );
          GF.showInformationDialog(
            "Berhasil",
            "$total data Expense berhasil dihapus",
          );
        } catch (e) {
          GF.showInformationDialog(
            "Gagal",
            "Data Expense dari ${GF.dateFormatString(dateRange.start)} sampai ${GF.dateFormatString(dateRange.end)} gagal dihapus",
          );
        }
      }
    }
  }

  void resetForm() {
    file.value = null;
    fileController.clear();
    importMode.value = Constant.importModeMerge;
  }

  @override
  void onClose() {
    fileController.dispose();
    super.onClose();
  }
}
