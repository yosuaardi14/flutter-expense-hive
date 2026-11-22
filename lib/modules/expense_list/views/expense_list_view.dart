import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../models/expense.dart';
import '../../../utils/constant.dart';
import '../../../utils/global_functions.dart';
import '../../base/widgets/base_app_bar.dart';
import '../../base/widgets/base_drawer.dart';
import '../../base/widgets/mode_type_filter.dart';
import '../../base/widgets/payment_filter.dart';
import '../../base/widgets/year_month_filter.dart';
import '../../expense_add/views/expense_add_view.dart';
import '../controllers/expense_list_controller.dart';

class ExpenseListView extends GetView<ExpenseListController> {
  const ExpenseListView({super.key});

  void addExpense() {
    Get.bottomSheet(
      const ExpenseAddView(),
      settings: RouteSettings(
        arguments: {"isExpense": controller.mode.value == Constant.outcome},
      ),
    ).then((value) {
      controller.listData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: Obx(() {
          return Text('Expense - ${controller.mode.value}');
        }),
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
      floatingActionButton: FloatingActionButton(
        onPressed: addExpense,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: RefreshIndicator(
        onRefresh: controller.listData,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Column(
                children: [
                  Obx(() {
                    final modeValue = controller.mode.value;
                    final typeValue = controller.type.value;
                    bool showTypeFilter = modeValue == Constant.outcome;
                    return ModeTypeFilter(
                      modeValue: modeValue,
                      typeValue: typeValue,
                      showTypeFilter: showTypeFilter,
                      onChangedMode: (val) {
                        controller.mode.value = val!;
                        controller.listData();
                      },
                      onChangedType: (val) {
                        controller.type.value = val!;
                        controller.listData();
                      },
                    );
                  }),
                  Obx(() {
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
                ],
              ),
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
            Obx(() {
              final totalMonth = controller.totalSpendMap()["List"];
              return Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total : ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(GF.rupiahFormat(totalMonth ?? 0.0, symbol: "Rp")),
                    ],
                  ),
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      // style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        controller.month.value = DateTime.now().month
                            .toString();
                        controller.year.value = DateTime.now().year.toString();
                        controller.type.value = Constant.dropdownType[0];
                        controller.listData();
                      },
                      child: const Text("Reset"),
                    ),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Obx(() {
                  return Column(
                    children: controller
                        .totalSpendMap()
                        .entries
                        .where((x) => x.key != "List")
                        .map(
                          (e) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${e.key}: ",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(GF.rupiahFormat(e.value, symbol: 'Rp')),
                            ],
                          ),
                        )
                        .toList(),
                  );
                }),
              ),
            ),
            //
            Expanded(
              child: Obx(() {
                if (controller.expenseData.entries.isEmpty) {
                  return const Center(child: Text("Data tidak ditemukan"));
                }
                return ListView(
                  children: [
                    ...controller.expenseData.entries.map(
                      (e) => ExpansionData(date: e.key, data: e.value),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpansionData extends GetView<ExpenseListController> {
  final String date;
  final List<Expense> data;
  const ExpansionData({super.key, required this.date, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(date),
            Text(
              GF.rupiahFormat(controller.calcTotalSpending(data), symbol: 'Rp'),
            ),
            // Chip(label: Text(rupiahFormat(controller.sumTotalperDay(data)))),
          ],
        ),
        children: [
          const Divider(color: Colors.black),
          ...data.map((e) => ItemData(data: e)),
        ],
      ),
    );
  }
}

class ItemData extends GetView<ExpenseListController> {
  final Expense data;
  const ItemData({super.key, required this.data});

  void editData() {
    // Get.put(ExpenseAddController());
    Get.bottomSheet(
      const ExpenseAddView(),
      settings: RouteSettings(arguments: {"id": data.id}),
    ).then((value) {
      controller.listData();
    });
  }

  Future<void> deleteData() async {
    bool hapus = await GF.showConfirmationDeleteDialog();
    if (hapus) {
      controller.deleteData(data.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        // title: Text(data.type),
        // subtitle: Text(data.title),
        // leading: Chip(
        //   label: Text(
        //     data.type,
        //     style: const TextStyle(color: Colors.white),
        //   ),
        //   backgroundColor: Colors.purple,
        // ),
        title: Text(data.title),
        subtitle: Text(data.type),
        leading: CircleAvatar(
          backgroundColor: Colors.green,
          child: Text(
            data.payment.substring(0, 1),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        onTap: editData,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(
              label: Text(
                GF.rupiahFormat(data.amount.toDouble(), symbol: 'Rp'),
              ),
            ),
            IconButton(
              onPressed: deleteData,
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
