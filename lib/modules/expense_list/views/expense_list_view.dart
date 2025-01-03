import 'package:flutter/material.dart';
import 'package:flutter_expense_app/models/expense.dart';
import 'package:flutter_expense_app/modules/expense_add/controllers/expense_add_controller.dart';
import 'package:flutter_expense_app/modules/expense_add/views/expense_add_view.dart';
import 'package:flutter_expense_app/utils/global_functions.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/constant.dart';
import '../controllers/expense_list_controller.dart';

class ExpenseListView extends GetView<ExpenseListController> {
  const ExpenseListView({super.key});

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
    Get.put(ExpenseAddController()).resetForm(controller.isExpense.value);
    Get.bottomSheet(const ExpenseAddView()).then((value) {
      controller.listData();
    });
  }

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
          ...data.map((e) => itemData(e)),
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
        leading: Chip(
          label: Text(
            data.payment.substring(0, 1),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
        onTap: () {
          Get.put(ExpenseAddController());
          Get.bottomSheet(
            const ExpenseAddView(),
            settings: RouteSettings(
              arguments: data.id,
            ),
          ).then((value) {
            controller.listData();
          });
        },
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(label: Text(rupiahFormat(data.amount.toDouble()))),
            IconButton(
              onPressed: () async {
                bool hapus = await GF.showConfirmationDeleteDialog();
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
      ),
      // Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: [
      //     Expanded(
      //       child: Row(
      //         children: [
      //           Chip(
      //             label: Text(
      //               data.type,
      //               style: const TextStyle(color: Colors.white),
      //             ),
      //             backgroundColor: Colors.purple,
      //           ),
      //           const SizedBox(width: 5),
      //           Text(data.title),
      //         ],
      //       ),
      //     ),
      //     Chip(
      //       label: Text(
      //         data.payment.substring(0, 1),
      //         style: const TextStyle(color: Colors.white),
      //       ),
      //       backgroundColor: Colors.green,
      //     ),
      //     Chip(label: Text(rupiahFormat(data.amount.toDouble()))),
      //     IconButton(
      //       onPressed: () async {
      //         bool hapus = await showConfirmationDeleteDialog();
      //         if (hapus) {
      //           controller.deleteData(data.id);
      //         }
      //       },
      //       icon: const Icon(
      //         Icons.delete,
      //         color: Colors.red,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Widget filterButton = SizedBox(
    //   height: 40,
    //   child: ElevatedButton(
    //     onPressed: () async {
    //       var value = await Get.bottomSheet(ExpenseFilterDialog(),
    //               settings:
    //                   RouteSettings(arguments: controller.filterValue())) ??
    //           {
    //             "type": "Semua",
    //             "payment": "Semua",
    //             "month": "0",
    //           };
    //       print(value);
    //       // var value = await showDialog(
    //       //     barrierDismissible: false,
    //       //     context: context,
    //       //     builder: (ctx) => ExpenseFilterDialog());
    //       controller.filterData(value);
    //     },
    //     child: const Text("Filter"),
    //   ),
    // );

    // Widget showButton = Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    //   child: Row(
    //     children: [
    //       Expanded(
    //         // flex: 3,
    //         child: SizedBox(
    //           height: 40,
    //           child: ElevatedButton(
    //             onPressed: displayChart,
    //             child: const Text("Dashboard"),
    //             // GetBuilder<ExpenseListController>(
    //             //   builder: (c) => Row(
    //             //     children: [
    //             //       Icon(c.showChart
    //             //           ? Icons.visibility
    //             //           : Icons.visibility_off),
    //             //       const SizedBox(width: 3),
    //             //       const Expanded(child: Text("Dashboard")),
    //             //     ],
    //             //   ),
    //             // ),
    //           ),
    //         ),
    //       ),
    //       const SizedBox(width: 5),
    //       Expanded(child: filterButton),
    //       const SizedBox(width: 5),
    //       Expanded(
    //         // flex: 2,
    //         child: SizedBox(
    //           height: 40,
    //           child: ElevatedButton(
    //             onPressed: displayList,
    //             child: const Text("List"),
    //             // GetBuilder<ExpenseListController>(
    //             //   builder: (c) => Row(
    //             //     children: [
    //             //       Icon(
    //             //           c.showList ? Icons.visibility : Icons.visibility_off),
    //             //       const SizedBox(width: 3),
    //             //       const Expanded(child: Text("List")),
    //             //     ],
    //             //   ),
    //             // ),
    //           ),
    //         ),
    //       )
    //     ],
    //   ),
    // );

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
                .where((x) => x.key != "List")
                .map(
                  (e) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${e.key}: ",
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
              ? [const Center(child: CircularProgressIndicator())]
              : controller.expenseData.entries.isEmpty
                  ? [
                      const SizedBox(height: 10),
                      const Center(child: Text("Data tidak ditemukan"))
                    ]
                  : [
                      ...controller.expenseData.entries.map(
                        (e) => expansionData(e.key, e.value),
                      ),
                    ],
        ),
      ),
    );

    // Widget bottomNavigationBar = Obx(
    //   () => BottomNavigationBar(
    //     currentIndex: controller.pageIndex(),
    //     onTap: controller.changePage,
    //     items: const [
    //       BottomNavigationBarItem(
    //         label: "List",
    //         icon: Icon(Icons.list_alt),
    //       ),
    //       BottomNavigationBarItem(
    //         label: "Calendar",
    //         icon: Icon(Icons.calendar_month),
    //       ),
    //       BottomNavigationBarItem(
    //         label: "Table",
    //         icon: Icon(Icons.table_view_outlined),
    //       ),
    //     ],
    //   ),
    // );

    // Widget homePage = RefreshIndicator(
    //   onRefresh: () async => controller.listData(),
    //   child: Column(children: [
    //     showButton,
    //     if (controller.showChart) dashboard,
    //     // filterDropdown,
    //     if (controller.showList) listItem,
    //     //const SizedBox(height: 75),
    //   ]),
    // );
    // const int month = 12;
    // final int first = DateTime(DateTime.now().year, month).day;
    // final int last = DateTime(DateTime.now().year, month + 1)
    //     .subtract(const Duration(days: 1))
    //     .day;

    // Widget dashboardPage = Column(
    //   children: [
    //     const Card(
    //       child: ListTile(
    //         title: Text("data"),
    //       ),
    //     ),
    //     Expanded(
    //       child: ListView(
    //         scrollDirection: Axis.horizontal,
    //         children: [
    //           for (var i = first; i <= last; i++)
    //             Card(
    //               child: SizedBox(
    //                 width: 50,
    //                 height: 30,
    //                 child: ListTile(
    //                   title: Text(i.toString()),
    //                   subtitle: Text(month.toString()),
    //                 ),
    //               ),
    //             ),
    //         ],
    //       ),
    //     ),
    //     Expanded(
    //       child: GridView.count(
    //         crossAxisCount: 3,
    //         children: const [
    //           Card(
    //             child: ListTile(
    //               title: Text(
    //                 "Title",
    //                 textAlign: TextAlign.center,
    //                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    //               ),
    //               subtitle: Align(
    //                 alignment: Alignment.center,
    //                 child: Text(
    //                   "5",
    //                   textAlign: TextAlign.center,
    //                   style:
    //                       TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
    //                 ),
    //               ),
    //             ),
    //           ),
    //           Card(
    //             child: ListTile(
    //               title: Text(
    //                 "Title",
    //                 textAlign: TextAlign.center,
    //                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    //               ),
    //               subtitle: Align(
    //                 alignment: Alignment.center,
    //                 child: Text(
    //                   "5",
    //                   textAlign: TextAlign.center,
    //                   style:
    //                       TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
    //                 ),
    //               ),
    //             ),
    //           ),
    //           Card(
    //             child: ListTile(
    //               title: Text(
    //                 "Title",
    //                 textAlign: TextAlign.center,
    //                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    //               ),
    //               subtitle: Align(
    //                 alignment: Alignment.center,
    //                 child: Text(
    //                   "5",
    //                   textAlign: TextAlign.center,
    //                   style:
    //                       TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
    //                 ),
    //               ),
    //             ),
    //           ),
    //           Card(
    //             child: ListTile(
    //               title: Text(
    //                 "Title",
    //                 textAlign: TextAlign.center,
    //                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    //               ),
    //               subtitle: Align(
    //                 alignment: Alignment.center,
    //                 child: Text(
    //                   "5",
    //                   textAlign: TextAlign.center,
    //                   style:
    //                       TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // );

    // Widget body = Obx(
    //   () => IndexedStack(
    //     index: controller.pageIndex(),
    //     children: [
    //       homePage,
    //       dashboardPage,
    //     ],
    //   ),
    // );

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
            'Expense App - ${controller.isExpense.value ? "Outcome" : "Income"}')),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              controller.switchList();
            },
            icon: const Icon(Icons.currency_exchange),
          )
        ],
      ),
      // drawer: const BaseDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: addExpense,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: bottomNavigationBar,
      // body: body,
      body: RefreshIndicator(
        onRefresh: () async => controller.listData(),
        child: GetBuilder<ExpenseListController>(
          builder: (c) => Column(children: [
            // showButton,
            ...filter(),
            if (c.showChart) dashboard,
            // filterDropdown,
            if (c.showList) listItem,
            //const SizedBox(height: 75),
          ]),
        ),
      ),
    );
  }

  List<Widget> filter() {
    return [
      if (controller.isExpense.value)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: controller.filterValue["type"],
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
                    controller.filterValue["type"] = val!;
                    controller.update();
                    controller.filterData(controller.filterValue());
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: controller.filterValue["payment"],
                  items: [
                    ...Constant.dropdownPayment.map(
                      (e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(e),
                      ),
                    )
                  ],
                  decoration: const InputDecoration(labelText: 'Pembayaran'),
                  onChanged: (val) {
                    controller.filterValue["payment"] = val!;
                    controller.update();
                    controller.filterData(controller.filterValue());
                  },
                ),
              ),
            ],
          ),
        ),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: controller.filterValue["month"],
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
                  controller.filterValue["month"] = val!;
                  controller.update();
                  controller.filterData(controller.filterValue());
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: controller.filterValue["year"],
                items: [
                  ...controller.listYear.map(
                    (e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    ),
                  )
                ],
                decoration: const InputDecoration(labelText: 'Tahun'),
                onChanged: (val) {
                  controller.filterValue["year"] = val!;
                  controller.update();
                  controller.filterData(controller.filterValue());
                },
              ),
            ),
          ],
        ),
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
                GF.rupiahFormat(controller.totalSpending()["List"],
                    symbol: "Rp"),
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
      // Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 5),
      //   child: Row(
      //     children: [
      //       Expanded(
      //         child: ElevatedButton(
      //           style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
      //           onPressed: () {
      //             controller.filterData({
      //               "type": "Semua",
      //               "payment": "Semua",
      //               "month": "0",
      //               "year": "Semua",
      //             });
      //           },
      //           child: const Text("Hapus"),
      //         ),
      //       ),
      //       const SizedBox(width: 10),
      //       Expanded(
      //         child: ElevatedButton(
      //           onPressed: () {
      //             controller.filterData(controller.filterValue());
      //           },
      //           child: const Text("Filter"),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    ];
  }
}
