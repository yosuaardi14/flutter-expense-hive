import 'package:flutter/material.dart';
import 'package:flutter_expense_app/modules/base/widgets/base_app_bar.dart';
import 'package:flutter_expense_app/utils/global_functions.dart';
import 'package:get/get.dart';

import '../../../utils/constant.dart';
// import '../../base/widgets/base_drawer.dart';
import '../controllers/expense_table_controller.dart';

class ExpenseTableView extends GetView<ExpenseTableController> {
  const ExpenseTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(
        postFixtitleText: " - Table",
        centerTitle: false,
      ),
      // drawer: const BaseDrawer(),
      body: GetBuilder<ExpenseTableController>(
        init: controller..listData(),
        builder: (controller) {
          return RefreshIndicator(
            onRefresh: () async => controller.listData(),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: DropdownButtonFormField<String>(
                      //         value: controller.type.value,
                      //         items: [
                      //           ...Constant.dropdownType.map(
                      //             (e) => DropdownMenuItem<String>(
                      //               value: e,
                      //               child: Text(e),
                      //             ),
                      //           )
                      //         ],
                      //         decoration:
                      //             const InputDecoration(labelText: 'Tipe'),
                      //         onChanged: (val) {
                      //           controller.type.value = val!;
                      //           controller.calculateDayInMonth();
                      //           controller.update();
                      //         },
                      //       ),
                      //     ),
                      //     const SizedBox(width: 10),
                      //     Expanded(
                      //       child: DropdownButtonFormField<String>(
                      //         value: controller.payment.value,
                      //         items: [
                      //           ...Constant.dropdownPayment.map(
                      //             (e) => DropdownMenuItem<String>(
                      //               value: e,
                      //               child: Text(e),
                      //             ),
                      //           )
                      //         ],
                      //         decoration:
                      //             const InputDecoration(labelText: 'Pembayaran'),
                      //         onChanged: (val) {
                      //           controller.payment.value = val!;
                      //           controller.calculateDayInMonth();
                      //           controller.update();
                      //         },
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: controller.month.value,
                              items: [
                                ...Constant.dropdownMonthOnly.entries.map(
                                  (e) => DropdownMenuItem<String>(
                                    value: e.key,
                                    child: Text(e.value),
                                  ),
                                )
                              ],
                              decoration:
                                  const InputDecoration(labelText: 'Bulan'),
                              onChanged: (val) {
                                controller.month.value = val!;
                                controller.calculateDayInMonth();
                                controller.update();
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: controller.year.value,
                              items: [
                                ...controller.listYear.map(
                                  (e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                              ],
                              decoration:
                                  const InputDecoration(labelText: 'Tahun'),
                              onChanged: (val) {
                                controller.year.value = val!;
                                controller.calculateDayInMonth();
                                controller.update();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (controller.tableItem.isNotEmpty)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      width: 700,
                      padding: const EdgeInsets.all(5.0),
                      child: Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.bottom,
                        columnWidths: const {
                          0: FlexColumnWidth(0.5),
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
                              border:
                                  Border.symmetric(horizontal: BorderSide()),
                              color: Colors.purple,
                            ),
                            children: [
                              TableText("Tgl", isBold: true),
                              TableText("Nama", isBold: true),
                              TableText("Pemasukan", isBold: true),
                              TableText("Pengeluaran", isBold: true),
                              TableText("Total Pemasukan", isBold: true),
                              TableText("Total Pengeluaran", isBold: true),
                              TableText("Sisa", isBold: true),
                            ],
                          ),
                          ...List.generate(
                            controller.tableItem.length,
                            (index) => TableRow(
                              decoration: BoxDecoration(
                                border: BorderDirectional(
                                  bottom: controller.tableItem[index]["isLast"]
                                      ? const BorderSide()
                                      : BorderSide.none,
                                ),
                              ),
                              children: [
                                TableText(controller.tableItem[index]["day"]),
                                TableText(
                                  controller.tableItem[index]["title"] ?? "",
                                  isDesc: true,
                                ),
                                TableText(GF.rupiahFormat(
                                    controller.tableItem[index]["income"])),
                                TableText(GF.rupiahFormat(
                                    controller.tableItem[index]["outcome"])),
                                TableText(GF.rupiahFormat(controller
                                    .tableItem[index]["totalIncome"])),
                                TableText(GF.rupiahFormat(controller
                                    .tableItem[index]["totalOutcome"])),
                                TableText(GF.rupiahFormat(
                                    controller.tableItem[index]["totalSisa"])),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  const Center(child: Text("Data tidak ditemukan"))
              ],
            ),
          );
        },
      ),
    );
  }
}

class TableText extends StatelessWidget {
  final String text;
  final bool isBold;
  final bool isDesc;
  const TableText(this.text,
      {super.key, this.isBold = false, this.isDesc = false});

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
