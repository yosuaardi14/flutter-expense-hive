import 'package:flutter/material.dart';
import 'package:flutter_expense_app/models/expense.dart';
import 'package:flutter_expense_app/modules/base/widgets/base_app_bar.dart';
import 'package:flutter_expense_app/modules/expense_add/controllers/expense_add_controller.dart';
import 'package:flutter_expense_app/modules/expense_add/views/expense_add_view.dart';
import 'package:flutter_expense_app/utils/global_functions.dart';

import 'package:get/get.dart';

import '../../../utils/constant.dart';
import '../../base/widgets/base_drawer.dart';
import '../controllers/expense_list_controller.dart';

class ExpenseListView extends GetView<ExpenseListController> {
  const ExpenseListView({super.key});

  void addExpense() {
    Get.put(ExpenseAddController()).resetForm(controller.isExpense.value);
    Get.bottomSheet(const ExpenseAddView()).then((value) {
      controller.listData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: Obx(
          () => Text(
            'Expense - ${controller.isExpense.value ? "Outcome" : "Income"}',
          ),
        ),
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
        onRefresh: () async => controller.listData(),
        child: Column(
          children: [
            //
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Column(
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: controller.isExpense.value
                              ? Constant.mode.first
                              : Constant.mode.last,
                          items: [
                            ...Constant.mode.map(
                              (e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(e),
                              ),
                            ),
                          ],
                          decoration: InputDecoration(labelText: 'Jenis'),
                          onChanged: (val) {
                            controller.switchList();
                          },
                        ),
                      ),
                      if (controller.isExpense.value)
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: controller.filterValue["type"],
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
                              controller.filterValue["type"] = val!;
                              controller.update();
                              controller.filterData(controller.filterValue());
                            },
                          ),
                        ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: controller.filterValue["year"],
                          items: [
                            ...controller.listYear.map(
                              (e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(e),
                              ),
                            ),
                          ],
                          decoration: const InputDecoration(labelText: 'Tahun'),
                          onChanged: (val) {
                            controller.filterValue["year"] = val!;
                            controller.update();
                            controller.filterData(controller.filterValue());
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: controller.filterValue["month"],
                          items: [
                            ...Constant.dropdownMonthOnly.entries.map(
                              (e) => DropdownMenuItem<String>(
                                value: e.key,
                                child: Text(e.value),
                              ),
                            ),
                          ],
                          decoration: const InputDecoration(labelText: 'Bulan'),
                          onChanged: (val) {
                            controller.filterValue["month"] = val!;
                            controller.update();
                            controller.filterData(controller.filterValue());
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Builder(
              builder: (context) {
                final mediaQuery = MediaQuery.sizeOf(context);
                final paymentList = Constant.dropdownPayment.sublist(1);
                return Obx(
                  () => Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    spacing: 5,
                    children: paymentList
                        .map(
                          (e) => ChoiceChip(
                            selectedColor: Colors.purple,
                            label: SizedBox(
                              width:
                                  mediaQuery.width / paymentList.length -
                                  paymentList.length * 5,
                              child: Text(
                                e,
                                style: const TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            selected: controller.selectedPayment.contains(e),
                            onSelected: (value) {
                              if (value) {
                                controller.selectedPayment.add(e);
                              } else {
                                controller.selectedPayment.remove(e);
                              }
                              controller.update();
                              controller.listData();
                            },
                          ),
                        )
                        .toList(),
                  ),
                );
              },
            ),
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total : ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      GF.rupiahFormat(
                        controller.totalSpendMap()["List"] ?? 0.0,
                        symbol: "Rp",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      // style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        controller.filterData({
                          "type": "Semua",
                          "payment": "Semua",
                          "source": "Semua",
                          "month": DateTime.now().month.toString(),
                          "year": DateTime.now().year.toString(),
                        });
                      },
                      child: const Text("Reset"),
                    ),
                  ),
                ],
              ),
            ),
            //
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: GetBuilder<ExpenseListController>(
                  builder: (c) => Column(
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
                  ),
                ),
              ),
            ),
            //
            Expanded(
              child: GetBuilder<ExpenseListController>(
                init: controller..listData(),
                builder: (c) => ListView(
                  children: c.isLoading
                      ? [const Center(child: CircularProgressIndicator())]
                      : controller.expenseData.entries.isEmpty
                      ? [
                          const SizedBox(height: 10),
                          const Center(child: Text("Data tidak ditemukan")),
                        ]
                      : [
                          ...controller.expenseData.entries.map(
                            (e) => ExpansionData(date: e.key, data: e.value),
                          ),
                        ],
                ),
              ),
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
    Get.put(ExpenseAddController());
    Get.bottomSheet(
      const ExpenseAddView(),
      settings: RouteSettings(arguments: data.id),
    ).then((value) {
      controller.listData();
    });
  }

  void deleteData() async {
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
