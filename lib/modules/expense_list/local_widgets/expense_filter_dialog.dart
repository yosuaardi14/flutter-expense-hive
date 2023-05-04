// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpenseFilterDialog extends StatelessWidget {
  ExpenseFilterDialog({super.key});
  final List<String> dropdownType = [
    "Semua",
    "Makan",
    "Kebutuhan",
    "Lainnya",
  ];

  final List<String> dropdownPayment = [
    "Semua",
    "Tunai",
    "GoPay",
    "OVO",
    "Dana",
    "Bank",
    "Lainnya",
  ];

  final Map<String, String> dropdownMonth = {
    "0": "Semua",
    "1": "Januari",
    "2": "Februari",
    "3": "Maret",
    "4": "April",
    "5": "Mei",
    "6": "Juni",
    "7": "Juli",
    "8": "Agustus",
    "9": "September",
    "10": "Oktober",
    "11": "November",
    "12": "Desember",
  };

  String type = "Semua";
  String payment = "Semua";
  String month = "0";
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Expense Filter"),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: type,
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
                type = val!;
              },
            ),
            DropdownButtonFormField<String>(
              value: payment,
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
                payment = val!;
              },
            ),
            DropdownButtonFormField<String>(
              value: month,
              items: [
                ...dropdownMonth.entries
                    .map((e) => DropdownMenuItem<String>(
                          child: Text(e.value),
                          value: e.key,
                        ))
                    .toList()
              ],
              decoration: const InputDecoration(labelText: 'Bulan'),
              onChanged: (val) {
                month = val!;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(Get.context!, {
                "type": "Semua",
                "payment": "Semua",
                "month": "0",
              });
            },
            child: const Text("Tidak")),
        const SizedBox(width: 20),
        TextButton(
            onPressed: () {
              Navigator.pop(Get.context!, {
                "type": type,
                "payment": payment,
                "month": month,
              });
            },
            child: const Text("Ya")),
      ],
    );
  }
}
