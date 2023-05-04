import 'package:flutter/material.dart';
import 'package:flutter_expense_app/services/hive_service.dart';
import 'package:get/get.dart';

class ExpenseAddController extends GetxController {
  HiveService dbService = HiveService.instance;

  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  String typeValue = "Makan";
  String paymentValue = "Tunai";
  DateTime selectedDate = DateTime.now();

  void insertData() async {
    Map<String, dynamic> data = {
      "title": titleController.text,
      "amount": amountController.text,
      "type": typeValue,
      "payment": paymentValue,
      "date": selectedDate.toString(),
      "id": DateTime.now().toString(),
    };
    await dbService.insertData(data);
    titleController.clear();
    amountController.clear();
    selectedDate = DateTime.now();
    update();
  }
}
