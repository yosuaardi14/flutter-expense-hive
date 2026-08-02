import 'package:flutter/material.dart';
import 'package:flutter_expense_app/models/budget.dart';
import 'package:flutter_expense_app/utils/constant.dart';
import 'package:get/get.dart';

import '../../base/controllers/expense_base_controller.dart';

class BudgetAddController extends ExpenseBaseController {
  TextEditingController amountController = TextEditingController();
  Rx<String> typeValue = "Makan".obs;
  final id = "".obs;

  final month = "0".obs;
  final year = "2024".obs;
  final listYear = <String>[].obs;
  final period = "Per Bulan".obs;

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
    listYear.value = List.generate(
      DateTime.now().year - 2020 + 1,
      (index) => (2020 + index).toString(),
    );
    listYear.value = listYear.reversed.toList();
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
    update();
  }

  Future<void> checkArguments(dynamic args) async {
    if (args != null && args is Map) {
      typeValue.value = args["category"] ?? "Makan";
      month.value =
          args["month"]?.toString() ?? DateTime.now().month.toString();
      year.value = args["year"]?.toString() ?? DateTime.now().year.toString();
      generateWeekList();
      update();
    } else if (args != null && id.value != args) {
      detailData(args);
    }
  }

  Future<void> insertData() async {
    if (id.value != "") {
      String parentid = "${typeValue.value}_${month.value}_${year.value}_0";
      Map<String, dynamic> data = {
        "month": month.value,
        "year": year.value,
        "amount": amountController.text,
        "type": typeValue.value,
        "period": period.value,
        "param": 0,
        "parentid": null,
        "id": parentid,
      };
      await budgetService.updateDataBudget(id.value, data);
      if (childrenBudget.isNotEmpty) {
        for (var i = 0; i < childrenBudget.length; i++) {
          await budgetService.deleteDataBudget(childrenBudget[i].id);
        }
      }
      if (period.value == "Per Hari") {
        for (var i = 0; i < dayAmounts.length; i++) {
          MapEntry<int, String?> entry = dayAmounts.entries.elementAt(i);
          if (double.tryParse(entry.value.toString()) == null) {
            continue;
          }
          String elementId =
              "${typeValue.value}_${month.value}_${year.value}_${entry.key}";
          Map<String, dynamic> childData = {
            "month": month.value,
            "year": year.value,
            "amount": entry.value,
            "type": typeValue.value,
            "period": period.value,
            "param": entry.key,
            "parentid": parentid,
            "id": elementId,
          };
          await budgetService.insertDataBudget(childData);
        }
      } else if (period.value == "Per Minggu") {
        for (var i = 0; i < weekList.length; i++) {
          if (weekAmounts.containsKey(weekList[i]) &&
              (double.tryParse(weekAmounts[weekList[i]].toString()) != null)) {
            String elementId =
                "${typeValue.value}_${month.value}_${year.value}_${weekList[i]}";
            Map<String, dynamic> childData = {
              "month": month.value,
              "year": year.value,
              "amount": weekAmounts[weekList[i]],
              "type": typeValue.value,
              "period": period.value,
              "param": weekList[i],
              "parentid": parentid,
              "id": elementId,
            };
            await budgetService.insertDataBudget(childData);
          }
        }
      }
      resetForm();
      update();
    } else {
      String parentid = "${typeValue.value}_${month.value}_${year.value}_0";
      Map<String, dynamic> data = {
        "month": month.value,
        "year": year.value,
        "amount": amountController.text,
        "type": typeValue.value,
        "period": period.value,
        "param": 0,
        "parentid": null,
        "id": parentid,
      };
      await budgetService.insertDataBudget(data);
      if (period.value == "Per Hari") {
        for (var i = 0; i < dayAmounts.length; i++) {
          MapEntry<int, String?> entry = dayAmounts.entries.elementAt(i);
          if (double.tryParse(entry.value.toString()) == null) {
            continue;
          }
          String elementId =
              "${typeValue.value}_${month.value}_${year.value}_${entry.key}";
          Map<String, dynamic> childData = {
            "month": month.value,
            "year": year.value,
            "amount": entry.value,
            "type": typeValue.value,
            "period": period.value,
            "param": entry.key,
            "parentid": parentid,
            "id": elementId,
          };
          await budgetService.insertDataBudget(childData);
        }
      } else if (period.value == "Per Minggu") {
        for (var i = 0; i < weekList.length; i++) {
          if (weekAmounts.containsKey(weekList[i]) &&
              (double.tryParse(weekAmounts[weekList[i]].toString()) != null)) {
            String elementId =
                "${typeValue.value}_${month.value}_${year.value}_${weekList[i]}";
            Map<String, dynamic> childData = {
              "month": month.value,
              "year": year.value,
              "amount": weekAmounts[weekList[i]],
              "type": typeValue.value,
              "period": period.value,
              "param": weekList[i],
              "parentid": parentid,
              "id": elementId,
            };
            await budgetService.insertDataBudget(childData);
          }
        }
      }
      resetForm();
      update();
    }
  }

  void detailData(String id) async {
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
    if (period.value == "Per Hari") {
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
    } else if (period.value == "Per Minggu") {
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
    update();
  }

  void resetForm([bool isExpense = true]) {
    amountController.clear();
    id("");
    update();
  }
}
