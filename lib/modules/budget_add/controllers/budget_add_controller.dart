import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/budget.dart';
import '../../../utils/constant.dart';
import '../../../utils/global_functions.dart';
import '../../base/controllers/expense_base_controller.dart';

class BudgetAddController extends ExpenseBaseController {
  TextEditingController amountController = TextEditingController();
  Rx<String> typeValue = "Makan".obs;
  final id = "".obs;

  final month = "0".obs;
  final year = "2024".obs;
  final period = Constant.perBulan.obs;

  final weekList = <int>[].obs;

  final dayAmounts = <int, String?>{}.obs;
  final weekAmounts = <int, String?>{}.obs;
  final List<TextEditingController> amountsChildrenController = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  final optionalIndex = 0.obs;
  final childrenBudget = <Budget>[].obs;

  @override
  void onInit() {
    super.onInit();
    month.value = DateTime.now().month.toString();
    year.value = DateTime.now().year.toString();
    listYear.addAll(GF.listYear());
    generateWeekList();
    period.value = Constant.dropdownBudgetPeriod.last;
  }

  void generateWeekList() {
    DateTime now = DateTime.now();
    int selectedMonth = int.tryParse(month.value) ?? now.month;
    int selectedYear = int.tryParse(year.value) ?? now.year;

    DateTime selected = DateTime(selectedYear, selectedMonth, 1);
    DateTime after = DateTime(selectedYear, selectedMonth + 1, 1);
    DateTime selectedLastDay = after.subtract(Duration(days: 1));
    int totalDays = selectedLastDay.difference(selected).inDays + 1;
    int startWeekDay = selected.weekday - 1;
    int weeks = ((startWeekDay + totalDays) / 7).ceil();
    weekList.value = List.generate(weeks, (index) => (index + 1));
  }

  Future<void> checkArguments(dynamic args) async {
    if (args != null && args is Map) {
      typeValue.value = args["category"] ?? "Makan";
      month.value =
          args["month"]?.toString() ?? DateTime.now().month.toString();
      year.value = args["year"]?.toString() ?? DateTime.now().year.toString();
      generateWeekList();
    } else if (args != null && id.value != args) {
      detailData(args);
    }
  }

  Future<void> insertData() async {
    final isEdit = id.value.isNotEmpty;
    final parentid = "${typeValue.value}_${month.value}_${year.value}_0";

    // Sama untuk tambah maupun edit
    final parentData = <String, dynamic>{
      "month": month.value,
      "year": year.value,
      "amount": amountController.text,
      "type": typeValue.value,
      "period": period.value,
      "param": 0,
      "parentid": null,
      "id": parentid,
    };

    if (isEdit) {
      // Beda hanya di sini: update parent + hapus children lama
      await budgetService.updateDataBudget(id.value, parentData);
      for (final child in childrenBudget) {
        await budgetService.deleteDataBudget(child.id);
      }
    } else {
      await budgetService.insertDataBudget(parentData);
    }

    // Anak baru: identik untuk kedua cabang
    await _insertChildren(parentid);
  }

  Future<void> _insertChildren(String parentid) async {
    if (period.value == Constant.perHari) {
      for (final entry in dayAmounts.entries) {
        if (double.tryParse(entry.value.toString()) == null) continue;
        await budgetService.insertDataBudget(
          _buildChildData(
            parentid: parentid,
            param: entry.key,
            amount: entry.value,
          ),
        );
      }
    } else if (period.value == Constant.perMinggu) {
      for (final week in weekList) {
        final amount = weekAmounts[week];
        if (amount == null || double.tryParse(amount.toString()) == null) {
          continue;
        }
        await budgetService.insertDataBudget(
          _buildChildData(parentid: parentid, param: week, amount: amount),
        );
      }
    }
  }

  Map<String, dynamic> _buildChildData({
    required String parentid,
    required int param,
    required String? amount,
  }) {
    return {
      "month": month.value,
      "year": year.value,
      "amount": amount,
      "type": typeValue.value,
      "period": period.value,
      "param": param,
      "parentid": parentid,
      "id": "${typeValue.value}_${month.value}_${year.value}_$param",
    };
  }

  Future<void> detailData(String id) async {
    Budget? data = await budgetService.fetchDataBudget(id, withChildren: true);
    if (data == null) {
      return;
    }
    amountController.text = data.amount.toString().replaceAll(".0", "");
    typeValue.value = data.type;
    period.value = data.period;
    childrenBudget.value = data.children;
    month.value = data.month.toString();
    year.value = data.year.toString();
    if (period.value == Constant.perHari) {
      for (var i = 0; i < data.children.length; i++) {
        amountsChildrenController[data.children[i].param - 1].text = data
            .children[i]
            .amount
            .toString()
            .replaceAll(".0", "");
        dayAmounts[data.children[i].param] = data.children[i].amount
            .toString()
            .replaceAll(".0", "");
      }
    } else if (period.value == Constant.perMinggu) {
      for (var i = 0; i < data.children.length; i++) {
        amountsChildrenController[data.children[i].param - 1].text = data
            .children[i]
            .amount
            .toString()
            .replaceAll(".0", "");
        weekAmounts[data.children[i].param] = data.children[i].amount
            .toString()
            .replaceAll(".0", "");
      }
    }
    this.id(id);
  }

  @override
  void onClose() {
    amountController.dispose();
    for (var controller in amountsChildrenController) {
      controller.dispose();
    }
    super.onClose();
  }

  void resetForm() {
    amountController.clear();
    id("");
    clearChildrenController();
  }

  void clearChildrenController() {
    for (var controller in amountsChildrenController) {
      controller.clear();
    }
  }
}
