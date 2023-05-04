import 'package:flutter/material.dart';
import 'package:flutter_expense_app/models/expense.dart';
import 'package:flutter_expense_app/modules/expense_add/controllers/expense_add_controller.dart';
import 'package:flutter_expense_app/modules/expense_add/views/expense_add_view.dart';
import 'package:flutter_expense_app/modules/expense_list/local_widgets/expense_filter_dialog.dart';
import 'package:flutter_expense_app/utils/global_functions.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/expense_list_controller.dart';

class ExpenseListView extends GetView<ExpenseListController> {
  String rupiahFormat(double amount) {
    return NumberFormat.currency(locale: "id", decimalDigits: 0, symbol: "Rp ")
        .format(amount);
  }

  void displayChart() {
    controller.showChart = !controller.showChart;
    controller.update();
  }

  void displayList() {
    controller.showList = !controller.showList;
    controller.update();
  }

  // void filterData(String val) {
  //   controller.month = val;
  //   controller.listData();
  // }

  void addExpense() {
    Get.put(ExpenseAddController());
    Get.bottomSheet(
      ExpenseAddView(),
    ).then((value) {
      controller.listData();
    });
  }

  final Map<String, String> month = {
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

  Widget expansionData(String date, List<Expense> data) {
    return Card(
      elevation: 3,
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(date),
            Text(rupiahFormat(controller.totalSpend(data))),
            // Chip(label: Text(rupiahFormat(controller.sumTotalperDay(data)))),
          ],
        ),
        children: [
          const Divider(color: Colors.black),
          ...data.map((e) => itemData(e)).toList(),
          //itemData(data)
          // const Divider(color: Colors.black),
          // totalExpenseDate,
          // addBtn,
        ],
      ),
    );
  }

  Widget itemData(Expense data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Chip(
                  label: Text(
                    data.type,
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.purple,
                ),
                SizedBox(width: 5),
                Text(data.title),
              ],
            ),
          ),
          Chip(
            label: Text(
              data.payment,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
          Chip(label: Text(rupiahFormat(data.amount.toDouble()))),
          IconButton(
            onPressed: () async {
              bool hapus = await showConfirmationDeleteDialog();
              if (hapus) {
                controller.deleteData(data.id);
              }
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget fab = FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: addExpense,
    );

    Widget filterButton = SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: () async {
          var value = await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (ctx) => ExpenseFilterDialog());
          controller.filterData(value);
        },
        child: Center(child: Text("Filter")),
      ),
    );

    Widget showButton = Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Expanded(
            // flex: 3,
            child: SizedBox(
              height: 40,
              child: ElevatedButton(
                onPressed: displayChart,
                child: GetBuilder<ExpenseListController>(
                  builder: (c) => Row(
                    children: [
                      Icon(c.showChart
                          ? Icons.visibility
                          : Icons.visibility_off),
                      SizedBox(width: 10),
                      Text("Dashboard"),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(child: filterButton),
          const SizedBox(width: 5),
          Expanded(
            // flex: 2,
            child: SizedBox(
              height: 40,
              child: ElevatedButton(
                onPressed: displayList,
                child: GetBuilder<ExpenseListController>(
                  builder: (c) => Row(
                    children: [
                      Icon(
                          c.showList ? Icons.visibility : Icons.visibility_off),
                      SizedBox(width: 10),
                      Text("List"),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );

    // Widget filterDropdown = Padding(
    //   padding: EdgeInsets.symmetric(horizontal: 4),
    //   child: DropdownButtonFormField<String>(
    //     value: "0",
    //     items: [
    //       ...month.entries
    //           .map((e) => DropdownMenuItem<String>(
    //                 child: Text(e.value),
    //                 value: e.key,
    //               ))
    //           .toList()
    //     ],
    //     onChanged: (val) {
    //       filterData(val!);
    //     },
    //     decoration: InputDecoration(
    //       isDense: true,
    //       border: OutlineInputBorder(),
    //     ),
    //   ),
    // );

    Widget dashboard = Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: GetBuilder<ExpenseListController>(
          builder: (c) => Column(
            children: controller
                .totalSpending()
                .entries
                .map(
                  (e) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        e.key + ": ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(rupiahFormat(e.value)),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );

    Widget listItem = GetBuilder<ExpenseListController>(
      init: controller..listData(),
      builder: (c) => Expanded(
        child: ListView(
          children: c.isLoading
              ? [Center(child: const CircularProgressIndicator())]
              : controller.expenseData.entries.length == 0
                  ? [
                      SizedBox(height: 10),
                      Center(child: Text("Data tidak ditemukan"))
                    ]
                  : [
                      ...controller.expenseData.entries
                          .map(
                            (e) => expansionData(e.key, e.value),
                          )
                          .toList(),
                    ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense App'),
        centerTitle: true,
      ),
      floatingActionButton: fab,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: RefreshIndicator(
        onRefresh: () async => controller.listData(),
        child: GetBuilder<ExpenseListController>(
          builder: (c) => Column(children: [
            showButton,
            if (c.showChart) dashboard,
            // filterDropdown,
            if (c.showList) listItem,
            //const SizedBox(height: 75),
          ]),
        ),
      ),
    );
  }
}
