import 'package:flutter/material.dart';
import 'package:flutter_expense_app/utils/constant.dart';
import 'package:get/get.dart';

import '../../../models/expense.dart';
import '../../base/controllers/expense_base_controller.dart';

class ExpenseAddController extends ExpenseBaseController {
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  Rx<String> typeValue = "Makan".obs;
  Rx<String> paymentValue = "Tunai".obs;
  Rx<String> incomeFromValue = "Bank".obs;
  DateTime selectedDate = DateTime.now();
  final isExpense = true.obs;
  final id = "".obs;

  Future<void> checkArguments(dynamic args) async {
    if (args != null && id.value != args) {
      detailData(args);
    }
  }

  Future<void> insertData() async {
    if (id.value != "") {
      Map<String, dynamic> data = {
        "title": titleController.text,
        "amount": amountController.text,
        "type": isExpense.value ? typeValue.value : "Pemasukan",
        "payment": isExpense.value ? paymentValue.value : incomeFromValue.value,
        "date": selectedDate.toString(),
        "id": DateTime.now().toString(),
      };
      await dbService.deleteData(id.value);
      await dbService.insertData(data);
      resetForm();
      update();
    } else {
      Map<String, dynamic> data = {
        "title": titleController.text,
        "amount": amountController.text,
        "type": isExpense.value ? typeValue.value : "Pemasukan",
        "payment": isExpense.value ? paymentValue.value : incomeFromValue.value,
        "date": selectedDate.toString(),
        "id": DateTime.now().toString(),
      };
      await dbService.insertData(data);
      resetForm();
      update();
    }
  }

  void detailData(String id) async {
    Expense? data = await dbService.fetchData(id);
    if (data == null) {
      return;
    }
    isExpense.value = data.type != "Pemasukan";
    update();
    titleController.text = data.title;
    amountController.text = data.amount.toString().replaceAll(".0", "");
    typeValue.value = data.type;
    if (isExpense.value) {
      paymentValue.value = data.payment;
    } else {
      incomeFromValue.value = data.payment;
    }
    selectedDate = data.date;
    this.id(id);
    update();
  }

  Future<void> updateData(String id) async {
    Map<String, dynamic> data = {
      "title": titleController.text,
      "amount": amountController.text,
      "type": isExpense.value ? typeValue : "Pemasukan",
      "payment": isExpense.value ? paymentValue : incomeFromValue,
      "date": selectedDate.toString(),
      "id": DateTime.now().toString(),
    };
    // await dbService.deleteData(id);
    await dbService.updateData(id, data);
    resetForm();
    update();
  }

  void resetForm([bool isExpense = true]) {
    titleController.clear();
    amountController.clear();
    selectedDate = DateTime.now();
    id("");
    this.isExpense(isExpense);
    if (isExpense) {
      typeValue.value = Constant.dropdownType[1];
    } else {
      typeValue.value = "Pemasukan";
    }
    update();
  }
}
