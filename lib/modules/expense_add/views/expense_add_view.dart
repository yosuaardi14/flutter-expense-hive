import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:get/get.dart';

import '../../../utils/constant.dart';
import '../../../utils/global_functions.dart';
import '../controllers/expense_add_controller.dart';

class ExpenseAddView extends StatefulWidget {
  const ExpenseAddView({super.key});

  @override
  State<ExpenseAddView> createState() => _ExpenseAddViewState();
}

class _ExpenseAddViewState extends State<ExpenseAddView> {
  final _formKey = GlobalKey<FormState>();

  late final ExpenseAddController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ExpenseAddController());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller.checkArguments(ModalRoute.of(context)?.settings.arguments);
  }

  @override
  void dispose() {
    if (Get.isRegistered<ExpenseAddController>()) {
      Get.delete<ExpenseAddController>();
    }
    super.dispose();
  }

  void _submitData() async {
    if (controller.amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = controller.titleController.text;
    final enteredAmount = int.parse(controller.amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return;
    }

    bool add = await GF.showConfirmationAddDialog(
      isEdit: controller.id.isNotEmpty,
    );
    if (add) {
      await controller.insertData();
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  void _presentDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      controller.selectedDate.value = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: !controller.isExpense.value
                    ? [
                        switchButton(),
                        DropdownButtonFormField<String>(
                          initialValue: "Pemasukan",
                          items: [
                            ...["Pemasukan"].map(
                              (e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(e),
                              ),
                            ),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Kategori',
                          ),
                          onChanged: (val) {
                            controller.typeValue.value = val!;
                          },
                          onSaved: (newValue) {
                            controller.typeValue.value = "Pemasukan";
                          },
                        ),
                        TextField(
                          decoration: const InputDecoration(labelText: 'Judul'),
                          controller: controller.titleController,
                        ),
                        TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Jumlah',
                          ),
                          controller: controller.amountController,
                          keyboardType: TextInputType.number,
                        ),
                        DropdownButtonFormField<String>(
                          initialValue: controller.incomeFromValue.value,
                          items: [
                            ...[...List<String>.from(Constant.dropdownPayment)]
                                .map(
                                  (e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(e),
                                  ),
                                ),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Sumber',
                          ),
                          onChanged: (val) {
                            controller.incomeFromValue.value = val!;
                          },
                        ),
                        SizedBox(
                          height: 70,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  'Tanggal: ${DateFormat.yMd().format(controller.selectedDate.value)}',
                                ),
                              ),
                              TextButton(
                                child: const Text(
                                  'Pilih Tanggal',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  _presentDatePicker(context);
                                },
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          child: Obx(
                            () => Text(
                              controller.id.isNotEmpty ? 'Ubah' : 'Tambah',
                            ),
                          ),
                          onPressed: () {
                            _submitData();
                          },
                        ),
                      ]
                    : [
                        switchButton(),
                        DropdownButtonFormField<String>(
                          initialValue: controller.typeValue.value,
                          items: [
                            ...Constant.dropdownType.map(
                              (e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(e),
                              ),
                            ),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Kategori',
                          ),
                          onChanged: (val) {
                            controller.typeValue.value = val!;
                          },
                        ),
                        TextField(
                          decoration: const InputDecoration(labelText: 'Judul'),
                          controller: controller.titleController,
                        ),
                        TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(labelText: 'Biaya'),
                          controller: controller.amountController,
                          keyboardType: TextInputType.number,
                        ),
                        DropdownButtonFormField<String>(
                          initialValue: controller.paymentValue.value,
                          isDense: true,
                          items: [
                            ...Constant.dropdownPayment.map(
                              (e) => DropdownMenuItem<String>(
                                alignment: Alignment.center,
                                value: e,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(e),
                                    CircleAvatar(
                                      backgroundColor: Colors.green,
                                      child: Text(
                                        e.substring(0, 1),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Pembayaran',
                          ),
                          onChanged: (val) {
                            controller.paymentValue.value = val!;
                          },
                        ),
                        SizedBox(
                          height: 70,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  'Tanggal: ${DateFormat.yMd().format(controller.selectedDate.value)}',
                                ),
                              ),
                              TextButton(
                                child: const Text(
                                  'Pilih Tanggal',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  _presentDatePicker(context);
                                },
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          child: Obx(
                            () => Text(
                              controller.id.isNotEmpty ? 'Ubah' : 'Tambah',
                            ),
                          ),
                          onPressed: () {
                            _submitData();
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
    return Obx(() {
      final isExpense = controller.isExpense.value;
      return Row(
        children: [
          Expanded(child: tabButton(isExpense, "Pengeluaran")),
          const SizedBox(width: 10),
          Expanded(child: tabButton(!isExpense, "Pemasukan")),
        ],
      );
    });
  }

  Widget tabButton(bool isActive, String text) {
    if (isActive) {
      return ElevatedButton(onPressed: () {}, child: Text(text));
    }
    return Obx(() {
      final id = controller.id();
      return OutlinedButton(
        onPressed: id == ""
            ? () {
                controller.isExpense.toggle();
              }
            : null,
        child: Text(text),
      );
    });
  }
}
