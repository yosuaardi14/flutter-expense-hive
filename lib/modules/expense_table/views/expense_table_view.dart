import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/global_functions.dart';
import '../../base/widgets/base_app_bar.dart';
import '../../base/widgets/base_drawer.dart';
import '../../base/widgets/payment_filter.dart';
import '../../base/widgets/year_month_filter.dart';
import '../../expense_add/controllers/expense_add_controller.dart';
import '../../expense_add/views/expense_add_view.dart';
import '../controllers/expense_table_controller.dart';

class ExpenseTableView extends GetView<ExpenseTableController> {
  const ExpenseTableView({super.key});

  void addExpense() {
    Get.put(ExpenseAddController()).resetForm();
    Get.bottomSheet(const ExpenseAddView()).then((value) {
      controller.listData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        postFixtitleText: " - Table",
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              controller.listData();
            },
          ),
        ],
      ),
      drawer: const BaseDrawer(),
      body: RefreshIndicator(
        onRefresh: () async => controller.listData(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Obx(() {
                final yearValue = controller.year.value;
                final monthValue = controller.month.value;
                return YearMonthFilter(
                  yearValue: yearValue,
                  monthValue: monthValue,
                  listYear: controller.listYear,
                  onChangedYear: (val) {
                    controller.year.value = val!;
                    controller.listData();
                  },
                  onChangedMonth: (val) {
                    controller.month.value = val!;
                    controller.listData();
                  },
                );
              }),
            ),
            Obx(() {
              List<String> selectedPayment = controller.selectedPayment();
              return PaymentFilter(
                isSelected: (e) => selectedPayment.contains(e),
                onSelected: (value, e) {
                  if (value) {
                    controller.selectedPayment.add(e);
                  } else {
                    controller.selectedPayment.remove(e);
                  }
                  controller.listData();
                },
              );
            }),
            Expanded(
              child: Obx(() {
                final List<Map<String, dynamic>> tableItem =
                    controller.tableItem;
                if (tableItem.isEmpty) {
                  return const Center(child: Text("Data tidak ditemukan"));
                }
                return ListView(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Builder(
                        builder: (context) {
                          final mediaQuery = MediaQuery.sizeOf(context);
                          return Container(
                            constraints: BoxConstraints(
                              minWidth: 700,
                              maxWidth: max(mediaQuery.width, 700),
                            ),
                            padding: const EdgeInsets.all(5.0),
                            child: Table(
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.bottom,
                              columnWidths: const {
                                0: FlexColumnWidth(0.85),
                                1: FlexColumnWidth(1.5),
                                2: FlexColumnWidth(1.5),
                                3: FlexColumnWidth(1.5),
                                4: FlexColumnWidth(1.5),
                                5: FlexColumnWidth(1.5),
                              },
                              border: const TableBorder(
                                verticalInside: BorderSide(),
                                right: BorderSide(),
                                left: BorderSide(),
                              ),
                              children: [
                                const TableRow(
                                  decoration: BoxDecoration(
                                    border: Border.symmetric(
                                      horizontal: BorderSide(),
                                    ),
                                    color: Colors.purple,
                                  ),
                                  children: [
                                    TableText("Tanggal", isBold: true),
                                    TableText("Nama", isBold: true),
                                    TableText("Pemasukan", isBold: true),
                                    TableText("Pengeluaran", isBold: true),
                                    TableText("Total Pemasukan", isBold: true),
                                    TableText(
                                      "Total Pengeluaran",
                                      isBold: true,
                                    ),
                                    TableText("Sisa", isBold: true),
                                  ],
                                ),
                                ...List.generate(
                                  tableItem.length,
                                  (index) => TableRow(
                                    decoration: BoxDecoration(
                                      border: BorderDirectional(
                                        bottom:
                                            controller
                                                .tableItem[index]["isLast"]
                                            ? const BorderSide()
                                            : BorderSide.none,
                                      ),
                                    ),
                                    children: [
                                      TableText(
                                        controller.tableItem[index]["day"],
                                      ),
                                      TableText(
                                        controller.tableItem[index]["title"] ??
                                            "",
                                        isDesc: true,
                                      ),
                                      TableText(
                                        GF.rupiahFormat(
                                          controller.tableItem[index]["income"],
                                        ),
                                      ),
                                      TableText(
                                        GF.rupiahFormat(
                                          controller
                                              .tableItem[index]["outcome"],
                                        ),
                                      ),
                                      TableText(
                                        GF.rupiahFormat(
                                          controller
                                              .tableItem[index]["totalIncome"],
                                        ),
                                      ),
                                      TableText(
                                        GF.rupiahFormat(
                                          controller
                                              .tableItem[index]["totalOutcome"],
                                        ),
                                      ),
                                      TableText(
                                        GF.rupiahFormat(
                                          controller
                                              .tableItem[index]["totalSisa"],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                onPressed: addExpense,
                label: const Text("Tambah"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TableText extends StatelessWidget {
  final String text;
  final bool isBold;
  final bool isDesc;
  const TableText(
    this.text, {
    super.key,
    this.isBold = false,
    this.isDesc = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Text(
        text,
        textAlign: isBold
            ? TextAlign.center
            : isDesc
            ? TextAlign.left
            : TextAlign.right,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: isBold ? Colors.white : null,
        ),
      ),
    );
  }
}
