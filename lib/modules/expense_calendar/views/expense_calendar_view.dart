import 'package:flutter/material.dart';
import 'package:flutter_expense_app/utils/global_functions.dart';
import 'package:get/get.dart';

import '../../../utils/constant.dart';
import '../../base/widgets/base_app_bar.dart';
// import '../../base/widgets/base_drawer.dart';
import '../controllers/expense_calendar_controller.dart';

class ExpenseCalendarView extends GetView<ExpenseCalendarController> {
  const ExpenseCalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(
        postFixtitleText: " - Calendar",
        centerTitle: false,
      ),
      // drawer: const BaseDrawer(),
      body: GetBuilder<ExpenseCalendarController>(
        init: controller..listData(),
        builder: (controller) {
          return RefreshIndicator(
            onRefresh: () async => controller.listData(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      DropdownButtonFormField<String>(
                        value: controller.mode.value,
                        items: [
                          ...Constant.mode.map(
                            (e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(e),
                            ),
                          )
                        ],
                        decoration: const InputDecoration(labelText: 'Tipe'),
                        onChanged: (val) {
                          controller.mode.value = val!;
                          controller.update();
                          controller.listData();
                        },
                      ),
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
                Card(
                  elevation: 3,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Bulan ini: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          GF.rupiahFormat(
                              controller.totalSpending()["Bulan ini"],
                              symbol: "Rp"),
                        ),
                      ],
                    ),
                  ),
                ),
                // Card(
                //   elevation: 3,
                //   child: Padding(
                //     padding:
                //         const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                //     child: GetBuilder<ExpenseListController>(
                //       builder: (c) => Column(
                //         children: controller
                //             .totalSpending()
                //             .entries
                //             .map(
                //               (e) => Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceBetween,
                //                 children: [
                //                   Text(
                //                     "${e.key}: ",
                //                     style: const TextStyle(
                //                         fontWeight: FontWeight.bold),
                //                   ),
                //                   Text(rupiahFormat(e.value)),
                //                 ],
                //               ),
                //             )
                //             .toList(),
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ...Constant.hari.map(
                        (e) => Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  strokeAlign: BorderSide.strokeAlignOutside),
                              color: Colors.purple,
                            ),
                            child: Text(
                              e,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    child: GridView.count(
                      crossAxisCount: 7,
                      children: [
                        ...List.generate(
                          controller.startWeekDay.value,
                          (index) => Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  strokeAlign: BorderSide.strokeAlignOutside),
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ...List.generate(
                          controller.daysInMonth.value,
                          (index) {
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    strokeAlign: BorderSide.strokeAlignOutside),
                                color: Colors.white,
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${(index + 1)}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    controller.rupiahFormat(
                                        controller.totalSpend(index + 1)),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        if (controller.sisaWeekDay.value != 0)
                          ...List.generate(
                            7 - controller.sisaWeekDay.value,
                            (index) => Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    strokeAlign: BorderSide.strokeAlignOutside),
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
