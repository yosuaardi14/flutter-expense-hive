// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:get/get.dart';

import '../../../utils/constant.dart';
import '../../../utils/global_functions.dart';
import '../controllers/expense_add_controller.dart';

class ExpenseAddView extends GetView<ExpenseAddController> {
  static final _formKey = GlobalKey<FormState>();

  const ExpenseAddView({super.key});

  void _submitData(BuildContext context) async {
    if (controller.amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = controller.titleController.text;
    final enteredAmount = int.parse(controller.amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return;
    }

    bool add = await GF.showConfirmationAddDialog();
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

  @override
  Widget build(BuildContext context) {
    controller.checkArguments(ModalRoute.of(context)?.settings.arguments);
    return GetBuilder<ExpenseAddController>(
      builder: (controller) => SingleChildScrollView(
        child: Card(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: !controller.isExpense.value
                    ? [
                        switchButton(),
                        DropdownButtonFormField<String>(
                          value: "Pemasukan",
                          items: [
                            ...["Pemasukan"].map(
                              (e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(e),
                              ),
                            )
                          ],
                          decoration: const InputDecoration(labelText: 'Tipe'),
                          onChanged: (val) {
                            controller.typeValue.value = val!;
                          },
                          onSaved: (newValue) {
                            controller.typeValue.value = "Pemasukan";
                            controller.update();
                          },
                        ),
                        TextField(
                          decoration: const InputDecoration(labelText: 'Judul'),
                          controller: controller.titleController,
                        ),
                        TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration:
                              const InputDecoration(labelText: 'Jumlah'),
                          controller: controller.amountController,
                          keyboardType: TextInputType.number,
                        ),
                        DropdownButtonFormField<String>(
                          value: controller.incomeFromValue.value,
                          items: [
                            ...[...List<String>.from(Constant.dropdownPayment)]
                                .map(
                              (e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(e),
                              ),
                            )
                          ],
                          decoration:
                              const InputDecoration(labelText: 'Sumber'),
                          onChanged: (val) {
                            controller.incomeFromValue.value = val!;
                            controller.update();
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
                      ]
                    : [
                        switchButton(),
                        DropdownButtonFormField<String>(
                          value: controller.typeValue.value,
                          items: [
                            ...Constant.dropdownType.map(
                              (e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(e),
                              ),
                            )
                          ],
                          decoration: const InputDecoration(labelText: 'Tipe'),
                          onChanged: (val) {
                            controller.typeValue.value = val!;
                            controller.update();
                          },
                        ),
                        TextField(
                          decoration: const InputDecoration(labelText: 'Judul'),
                          controller: controller.titleController,
                        ),
                        TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(labelText: 'Biaya'),
                          controller: controller.amountController,
                          keyboardType: TextInputType.number,
                        ),
                        DropdownButtonFormField<String>(
                          value: controller.paymentValue.value,
                          isDense: false,
                          items: [
                            ...Constant.dropdownPayment.map(
                              (e) => DropdownMenuItem<String>(
                                alignment: Alignment.topCenter,
                                value: e,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(e),
                                    Chip(
                                      label: Text(
                                        e.substring(0, 1),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                          decoration:
                              const InputDecoration(labelText: 'Pembayaran'),
                          onChanged: (val) {
                            controller.paymentValue.value = val!;
                            controller.update();
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
      ),
    );
  }

  Widget switchButton() {
    return GetBuilder<ExpenseAddController>(
      builder: (controller) => Row(
        children: [
          Expanded(
              child: tabButton(
                  controller, controller.isExpense.value, "Pengeluaran")),
          const SizedBox(width: 10),
          Expanded(
              child: tabButton(
                  controller, !controller.isExpense.value, "Pemasukan")),
        ],
      ),
    );
  }

  Widget tabButton(
      ExpenseAddController controller, bool isActive, String text) {
    if (isActive) {
      return ElevatedButton(
        onPressed: () {},
        child: Text(text),
      );
    }
    return OutlinedButton(
      onPressed: controller.id() == ""
          ? () {
              controller.isExpense.toggle();
              controller.update();
            }
          : null,
      child: Text(text),
    );
  }
}
