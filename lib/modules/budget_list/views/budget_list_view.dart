import 'package:flutter/material.dart';
import 'package:flutter_expense_app/models/budget.dart';
import 'package:flutter_expense_app/modules/base/widgets/base_drawer.dart';
import 'package:flutter_expense_app/modules/budget_list/controllers/budget_list_controller.dart';
import 'package:flutter_expense_app/utils/constant.dart';
import 'package:flutter_expense_app/utils/global_functions.dart';
import 'package:get/get.dart';

import '../../base/widgets/base_app_bar.dart';

class BudgetListView extends GetView<BudgetListController> {
  const BudgetListView({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => controller.listData(),
      child: Scaffold(
        appBar: BaseAppBar(titleText: "Budget App - List", centerTitle: false),
        drawer: const BaseDrawer(),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: controller.addBudget,
        //   child: const Icon(Icons.add),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: 
              
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => DropdownButtonFormField<String>(
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
                        onChanged: (val) {
                          controller.year.value = val!;
                          controller.getCurrentListBudget();
                          controller.update();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Obx(
                      () => DropdownButtonFormField<String>(
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
                        onChanged: (val) {
                          controller.month.value = val!;
                          controller.getCurrentListBudget();
                          controller.update();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                final listBudget = controller.currentListBudget();
                return ListView.builder(
                  itemCount: Constant.dropdownTypeOnly.length,
                  itemBuilder: (context, index) {
                    // Jika tidak ada children maka ListTile ?
                    Budget? budget = listBudget.firstWhereOrNull(
                      (e) =>
                          e.parentid == null &&
                          e.month.toString() == controller.month.value &&
                          e.year.toString() == controller.year.value &&
                          e.type == Constant.dropdownTypeOnly[index],
                    );
                    if (budget == null) {
                      return Card(
                        child: ListTile(
                          title: Text(Constant.dropdownTypeOnly[index]),
                          trailing: IconButton(
                            onPressed: () {
                              controller.addBudget(
                                category: Constant.dropdownTypeOnly[index],
                              );
                            },
                            icon: Icon(Icons.add_circle, color: Colors.purple),
                          ),
                        ),
                      );
                    }
                    return Card(
                      child: ExpansionTile(
                        showTrailingIcon: true,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Constant.dropdownTypeOnly[index],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(GF.rupiahFormat(budget.amount, symbol: "Rp")),
                          ],
                        ),
                        subtitle: Text(budget.period),
                        children: [
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Default"),
                                Text(
                                  GF.rupiahFormat(budget.amount, symbol: "Rp"),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                controller.deleteBudget(budget);
                              },
                              icon: Icon(Icons.delete, color: Colors.red),
                            ),
                            onTap: () {
                              controller.editBudget(budget);
                            },
                          ),
                          ...controller.listBudget
                              .where(
                                (e) =>
                                    e.parentid == budget.id &&
                                    e.month.toString() ==
                                        controller.month.value &&
                                    e.year.toString() ==
                                        controller.year.value &&
                                    e.type == Constant.dropdownTypeOnly[index],
                              )
                              .map((e) {
                                return ListTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        e.period == "Per Hari"
                                            ? Constant.hari[e.param - 1]
                                            : "Minggu ${e.param}",
                                      ),
                                      Text(
                                        GF.rupiahFormat(e.amount, symbol: "Rp"),
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      controller.deleteBudget(e);
                                    },
                                    icon: Icon(Icons.delete, color: Colors.red),
                                  ),
                                  onTap: () {
                                    controller.editBudget(e);
                                  },
                                );
                              }),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            //   width: double.infinity,
            //   child: ElevatedButton.icon(
            //     icon: const Icon(Icons.add),
            //     onPressed: controller.addBudget,
            //     label: const Text("Tambah"),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
