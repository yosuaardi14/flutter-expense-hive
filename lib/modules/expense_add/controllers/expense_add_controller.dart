import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/expense.dart';
import '../../../services/hive_service.dart';
// import '../../../services/db_service.dart';

class ExpenseAddController extends GetxController {
  HiveService dbService = HiveService.instance;
  // DBService dbService = DBService.instance;

  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  Rx<String> typeValue = "Makan".obs;
  Rx<String> paymentValue = "Tunai".obs;
  Rx<String> incomeFromValue = "Bank".obs;
  DateTime selectedDate = DateTime.now();
  final isExpense = true.obs;
  final id = "".obs;

  Future<void> checkArguments(dynamic args) async {
    if (args != null) {
      detailData(args);
    }
  }

  void insertData() async {
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
    update();
  }
}
