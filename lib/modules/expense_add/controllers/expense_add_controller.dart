import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/expense.dart';
import '../../../utils/constant.dart';
import '../../base/controllers/expense_base_controller.dart';

class ExpenseAddController extends ExpenseBaseController {
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  Rx<String> typeValue = "Makan".obs;
  Rx<String> paymentValue = "Tunai".obs;
  Rx<String> incomeFromValue = "Bank".obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  final isExpense = true.obs;
  final id = "".obs;

  Future<void> checkArguments(dynamic args) async {
    if (args is Map) {
      if (args["id"] != null) {
        detailData(args["id"]);
      } else if (args["isExpense"] is bool) {
        isExpense(args["isExpense"] ?? true);
      }
    }
    // if (args != null && id.value != args) {
    //   detailData(args);
    // }
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
      await expenseService.deleteData(id.value);
      await expenseService.insertData(data);
      // resetForm();
    } else {
      Map<String, dynamic> data = {
        "title": titleController.text,
        "amount": amountController.text,
        "type": isExpense.value ? typeValue.value : "Pemasukan",
        "payment": isExpense.value ? paymentValue.value : incomeFromValue.value,
        "date": selectedDate.toString(),
        "id": DateTime.now().toString(),
      };
      await expenseService.insertData(data);
      // resetForm();
    }
  }

  void detailData(String id) async {
    Expense? data = await expenseService.fetchData(id);
    if (data == null) {
      return;
    }
    isExpense.value = data.type != "Pemasukan";
    titleController.text = data.title;
    amountController.text = data.amount.toString().replaceAll(".0", "");
    typeValue.value = data.type;
    if (isExpense.value) {
      paymentValue.value = data.payment;
    } else {
      incomeFromValue.value = data.payment;
    }
    selectedDate.value = data.date;
    this.id(id);
  }

  Future<void> updateData(String id) async {
    Map<String, dynamic> data = {
      "title": titleController.text,
      "amount": amountController.text,
      "type": isExpense.value ? typeValue.value : "Pemasukan",
      "payment": isExpense.value ? paymentValue.value : incomeFromValue.value,
      "date": selectedDate.value.toString(),
      "id": DateTime.now().toString(),
    };
    // await dbService.deleteData(id);
    await expenseService.updateData(id, data);
    // resetForm();
  }

  @override
  void onClose() {
    titleController.dispose();
    amountController.dispose();
    super.onClose();
  }

  void resetForm([bool isExpense = true]) {
    titleController.clear();
    amountController.clear();
    selectedDate.value = DateTime.now();
    id("");
    this.isExpense(isExpense);
    if (isExpense) {
      typeValue.value = Constant.dropdownType[1];
    } else {
      typeValue.value = "Pemasukan";
    }
  }
}
