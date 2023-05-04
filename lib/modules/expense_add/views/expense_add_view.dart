import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expense_app/utils/global_functions.dart';
import 'package:intl/intl.dart';

import 'package:get/get.dart';

import '../controllers/expense_add_controller.dart';

class ExpenseAddView extends GetView<ExpenseAddController> {
  final _formKey = GlobalKey<FormState>();

  void _submitData(BuildContext context) async {
    if (controller.amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = controller.titleController.text;
    final enteredAmount = int.parse(controller.amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return;
    }

    bool add = await showConfirmationAddDialog();
    if (add) {
      controller.insertData();
      Navigator.of(context).pop();
    }
  }

  void _presentDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: controller.selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      controller.selectedDate = pickedDate;
      controller.update();
    });
  }

  final List<String> dropdownType = [
    "Makan",
    "Kebutuhan",
    "Lainnya",
  ];

  final List<String> dropdownPayment = [
    "Tunai",
    "GoPay",
    "OVO",
    "Dana",
    "Bank",
    "Lainnya",
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExpenseAddController>(
      builder: (controller) => Card(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: controller.typeValue,
                  items: [
                    ...dropdownType
                        .map(
                          (e) => DropdownMenuItem<String>(
                            child: Text(e),
                            value: e,
                          ),
                        )
                        .toList()
                  ],
                  decoration: const InputDecoration(labelText: 'Tipe'),
                  onChanged: (val) {
                    controller.typeValue = val!;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Judul'),
                  controller: controller.titleController,
                ),
                TextField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(labelText: 'Biaya'),
                  controller: controller.amountController,
                  keyboardType: TextInputType.number,
                ),
                DropdownButtonFormField<String>(
                  value: controller.paymentValue,
                  items: [
                    ...dropdownPayment
                        .map(
                          (e) => DropdownMenuItem<String>(
                            child: Text(e),
                            value: e,
                          ),
                        )
                        .toList()
                  ],
                  decoration: const InputDecoration(labelText: 'Pembayaran'),
                  onChanged: (val) {
                    controller.paymentValue = val!;
                  },
                ),
                SizedBox(
                  height: 70,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'Tanggal: ${DateFormat.yMd().format(controller.selectedDate)}',
                        ),
                      ),
                      TextButton(
                        child: const Text(
                          'Pilih Tanggal',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          _presentDatePicker(context);
                        },
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  child: const Text('Tambah'),
                  onPressed: () {
                    _submitData(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
