import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../utils/constant.dart';
import '../../../utils/global_functions.dart';
import '../../base/widgets/year_month_filter.dart';
import '../controllers/budget_add_controller.dart';

class BudgetAddView extends StatefulWidget {
  const BudgetAddView({super.key});

  @override
  State<BudgetAddView> createState() => _BudgetAddViewState();
}

class _BudgetAddViewState extends State<BudgetAddView> {
  final _formKey = GlobalKey<FormState>();

  late final BudgetAddController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(BudgetAddController());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller.checkArguments(ModalRoute.of(context)?.settings.arguments);
  }

  @override
  void dispose() {
    if (Get.isRegistered<BudgetAddController>()) {
      Get.delete<BudgetAddController>();
    }
    super.dispose();
  }

  Future<void> _submitData() async {
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
        if (mounted) {
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => DropdownButtonFormField<String>(
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
                ),
                Obx(() {
                  final yearValue = controller.year.value;
                  final monthValue = controller.month.value;
                  return YearMonthFilter(
                    yearValue: yearValue,
                    monthValue: monthValue,
                    listYear: controller.listYear,
                    onChangedYear: null,
                    onChangedMonth: null,
                  );
                }),
                Obx(
                  () => DropdownButtonFormField<String>(
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
                      controller.clearChildrenController();
                      // controller.calculateDayInMonth();
                    },
                  ),
                ),
                TextField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Jumlah (Default)',
                  ),
                  controller: controller.amountController,
                  keyboardType: TextInputType.number,
                ),
                // if (controller.period.value == Constant.perHari ||
                //     controller.period.value == Constant.perMinggu)
                //   Row(
                //     children: [
                //       Text("Aturan Khusus"),
                //       IconButton(
                //         onPressed: () {
                //           if (controller.period.value == Constant.perHari) {
                //             controller.dayAmounts.addEntries({});
                //           } else if (controller.period.value ==
                //               Constant.perMinggu) {
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
                Obx(() {
                  if (controller.period.value == Constant.perHari) {
                    return Column(
                      children: [
                        ...List.generate(Constant.hari.length, (index) {
                          return Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(Constant.hari[index]),
                              ),
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
                                  controller: controller
                                      .amountsChildrenController[index],
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
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                }),
                Obx(() {
                  if (controller.period.value == Constant.perMinggu) {
                    return Column(
                      children: [
                        ...List.generate(controller.weekList.length, (index) {
                          return Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Minggu ${controller.weekList[index]}",
                                ),
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
                                  controller: controller
                                      .amountsChildrenController[index],
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
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                }),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: Obx(
                    () => Text(controller.id.isNotEmpty ? 'Ubah' : 'Tambah'),
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
    );
  }
}
