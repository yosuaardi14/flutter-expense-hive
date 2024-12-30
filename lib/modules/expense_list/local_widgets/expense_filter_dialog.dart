// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constant.dart';

class ExpenseFilterDialog extends StatelessWidget {
  ExpenseFilterDialog({super.key});

  final type = "Semua".obs;
  final payment = "Semua".obs;
  final month = "0".obs;

  // @override
  // Widget build(BuildContext context) {
  //   return AlertDialog(
  //     title: const Text("Expense Filter"),
  //     content: Form(
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           DropdownButtonFormField<String>(
  //             value: type,
  //             items: [
  //               ...dropdownType.map(
  //                 (e) => DropdownMenuItem<String>(
  //                   value: e,
  //                   child: Text(e),
  //                 ),
  //               )
  //             ],
  //             decoration: const InputDecoration(labelText: 'Tipe'),
  //             onChanged: (val) {
  //               type = val!;
  //             },
  //           ),
  //           DropdownButtonFormField<String>(
  //             value: payment,
  //             items: [
  //               ...dropdownPayment.map(
  //                 (e) => DropdownMenuItem<String>(
  //                   value: e,
  //                   child: Text(e),
  //                 ),
  //               )
  //             ],
  //             decoration: const InputDecoration(labelText: 'Pembayaran'),
  //             onChanged: (val) {
  //               payment = val!;
  //             },
  //           ),
  //           DropdownButtonFormField<String>(
  //             value: month,
  //             items: [
  //               ...dropdownMonth.entries.map(
  //                 (e) => DropdownMenuItem<String>(
  //                   value: e.key,
  //                   child: Text(e.value),
  //                 ),
  //               )
  //             ],
  //             decoration: const InputDecoration(labelText: 'Bulan'),
  //             onChanged: (val) {
  //               month = val!;
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //     actions: [
  //       TextButton(
  //           onPressed: () {
  //             Navigator.pop(context, {
  //               "type": "Semua",
  //               "payment": "Semua",
  //               "month": "0",
  //             });
  //           },
  //           child: const Text("Tidak")),
  //       const SizedBox(width: 20),
  //       TextButton(
  //           onPressed: () {
  //             Navigator.pop(context, {
  //               "type": type,
  //               "payment": payment,
  //               "month": month,
  //             });
  //           },
  //           child: const Text("Ya")),
  //     ],
  //   );
  // }

  void initData(args) {
    if (args == null) {
      type.value = "Semua";
      payment.value = "Semua";
      month.value = "0";
    } else {
      type.value = args["type"];
      payment.value = args["payment"];
      month.value = args["month"];
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    initData(args);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // const Text("Expense Filter"),
              Obx(
                () => DropdownButtonFormField<String>(
                  value: type.value,
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
                    type.value = val!;
                  },
                ),
              ),
              DropdownButtonFormField<String>(
                isDense: false,
                value: payment.value,
                items: [
                  ...Constant.dropdownPayment.map(
                    (e) => DropdownMenuItem<String>(
                      value: e,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(e),
                          Chip(
                            label: Text(
                              e.substring(0, 1),
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.green,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
                decoration: const InputDecoration(labelText: 'Pembayaran'),
                onChanged: (val) {
                  payment.value = val!;
                },
              ),
              DropdownButtonFormField<String>(
                value: month.value,
                items: [
                  ...Constant.dropdownMonth.entries.map(
                    (e) => DropdownMenuItem<String>(
                      value: e.key,
                      child: Text(e.value),
                    ),
                  )
                ],
                decoration: const InputDecoration(labelText: 'Bulan'),
                onChanged: (val) {
                  month.value = val!;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        Navigator.pop(context, {
                          "type": "Semua",
                          "payment": "Semua",
                          "month": "0",
                        });
                      },
                      child: const Text("Hapus"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, {
                          "type": type.value,
                          "payment": payment.value,
                          "month": month.value,
                        });
                      },
                      child: const Text("Filter"),
                    ),
                  ),
                  // Expanded(
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.pop(context, {
                  //         "type": "Semua",
                  //         "payment": "Semua",
                  //         "month": "0",
                  //       });
                  //     },
                  //     child: const Text("Tidak"),
                  //   ),
                  // ),
                  // const SizedBox(width: 20),
                  // Expanded(
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.pop(context, {
                  //         "type": type,
                  //         "payment": payment,
                  //         "month": month,
                  //       });
                  //     },
                  //     child: const Text("Ya"),
                  //   ),
                  // ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
