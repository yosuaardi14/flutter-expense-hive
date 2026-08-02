import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../utils/constant.dart';
import '../../../utils/global_functions.dart';
import '../controllers/budget_add_controller.dart';

class BudgetAddView extends GetView<BudgetAddController> {
  static final _formKey = GlobalKey<FormState>();

  const BudgetAddView({super.key});

  void _submitData(BuildContext context) async {
    if (controller.amountController.text.isEmpty) {
      return;
    }
    final enteredAmount = int.parse(controller.amountController.text);

    if (enteredAmount <= 0) {
      return;
    }

    bool add = await GF.showConfirmationAddDialog(
      isEdit: controller.id.isNotEmpty,
    );
    if (add) {
      controller.insertData().whenComplete(() {
        if (context.mounted) {
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BudgetAddController>(
      builder: (controller) => SingleChildScrollView(
        child: Card(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: controller.typeValue.value,
                    items: [
                      ...Constant.dropdownType.map(
                        (e) =>
                            DropdownMenuItem<String>(value: e, child: Text(e)),
                      ),
                    ],
                    decoration: const InputDecoration(labelText: 'Kategori'),
                    onChanged: null,
                    // (val) {
                    // controller.typeValue.value = val!;
                    // controller.update();
                    // },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: controller.year.value,
                          items: [
                            ...controller.listYear.map(
                              (e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(e),
                              ),
                            ),
                          ],
                          decoration: const InputDecoration(labelText: 'Tahun'),
                          onChanged: null,
                          // (val) {
                          // controller.year.value = val!;
                          // controller.update();
                          // controller.generateWeekList();
                          // },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: controller.month.value,
                          items: [
                            ...Constant.dropdownMonthOnly.entries.map(
                              (e) => DropdownMenuItem<String>(
                                value: e.key,
                                child: Text(e.value),
                              ),
                            ),
                          ],
                          decoration: const InputDecoration(labelText: 'Bulan'),
                          onChanged: null,
                          // (val) {
                          // controller.month.value = val!;
                          // controller.update();
                          // controller.generateWeekList();
                          // },
                        ),
                      ),
                    ],
                  ),
                  DropdownButtonFormField<String>(
                    initialValue: controller.period.value,
                    items: [
                      ...Constant.dropdownBudgetPeriod.map(
                        (e) =>
                            DropdownMenuItem<String>(value: e, child: Text(e)),
                      ),
                    ],
                    decoration: const InputDecoration(labelText: 'Periode'),
                    onChanged: (val) {
                      controller.period.value = val!;
                      // controller.calculateDayInMonth();
                      controller.update();
                    },
                  ),
                  TextField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Jumlah (Default)',
                    ),
                    controller: controller.amountController,
                    keyboardType: TextInputType.number,
                  ),
                  // if (controller.period.value == "Per Hari" ||
                  //     controller.period.value == "Per Minggu")
                  //   Row(
                  //     children: [
                  //       Text("Aturan Khusus"),
                  //       IconButton(
                  //         onPressed: () {
                  //           if (controller.period.value == "Per Hari") {
                  //             controller.dayAmounts.addEntries({});
                  //           } else if (controller.period.value ==
                  //               "Per Minggu") {
                  //             controller.weekAmounts.addEntries({
                  //               "1": 10.00
                  //             }.entries);
                  //           }
                  //           controller.update();
                  //         },
                  //         icon: Icon(Icons.add),
                  //       ),
                  //     ],
                  //   ),
                  if (controller.period.value == "Per Hari")
                    ...List.generate(Constant.hari.length, (index) {
                      return Row(
                        children: [
                          Expanded(flex: 2, child: Text(Constant.hari[index])),
                          // Expanded(
                          //   child: DropdownButtonFormField<String>(
                          //     initialValue: Constant.hari[0],
                          //     items: [
                          //       ...Constant.hari.map(
                          //         (e) => DropdownMenuItem<String>(
                          //           value: e,
                          //           child: Text(e),
                          //         ),
                          //       ),
                          //     ],
                          //     decoration: const InputDecoration(
                          //       labelText: 'Hari',
                          //     ),
                          //     onChanged: (val) {
                          //       // controller.year.value = val!;
                          //       // controller.calculateDayInMonth();
                          //       controller.update();
                          //     },
                          //   ),
                          // ),
                          const SizedBox(width: 5),
                          Expanded(
                            flex: 8,
                            child: TextField(
                              controller:
                                  controller.amountsChildrenController[index],
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: const InputDecoration(
                                labelText: 'Jumlah',
                              ),
                              // controller: controller.amountController,
                              onChanged: (value) {
                                controller.dayAmounts[index + 1] = value;
                              },
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          // const SizedBox(width: 10),
                          // IconButton(
                          //   onPressed: () {},
                          //   icon: Icon(Icons.delete),
                          // ),
                        ],
                      );
                    }),
                  if (controller.period.value == "Per Minggu")
                    ...List.generate(controller.weekList.length, (index) {
                      return Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text("Minggu ${controller.weekList[index]}"),
                          ),
                          // Expanded(
                          //   child: DropdownButtonFormField<String>(
                          //     initialValue: "1",
                          //     items: [
                          //       ...controller.weekList().map(
                          //         (e) => DropdownMenuItem<String>(
                          //           value: e,
                          //           child: Text(e),
                          //         ),
                          //       ),
                          //     ],
                          //     decoration: const InputDecoration(
                          //       labelText: 'Minggu',
                          //     ),
                          //     onChanged: (val) {
                          //       // controller.year.value = val!;
                          //       // controller.calculateDayInMonth();
                          //       controller.update();
                          //     },
                          //   ),
                          // ),
                          const SizedBox(width: 5),
                          Expanded(
                            flex: 8,
                            child: TextField(
                              controller:
                                  controller.amountsChildrenController[index],
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: const InputDecoration(
                                labelText: 'Jumlah',
                              ),
                              onChanged: (value) {
                                controller.weekAmounts[controller
                                        .weekList[index]] =
                                    value;
                              },
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          // const SizedBox(width: 10),
                          // IconButton(
                          //   onPressed: () {},
                          //   icon: Icon(Icons.delete),
                          // ),
                        ],
                      );
                    }),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    child: Obx(
                      () => Text(controller.id.isNotEmpty ? 'Ubah' : 'Tambah'),
                    ),
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
}
