import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/budget.dart';
import '../../../utils/constant.dart';
import '../../../utils/global_functions.dart';
import '../../base/widgets/base_app_bar.dart';
import '../../base/widgets/base_drawer.dart';
import '../../base/widgets/year_month_filter.dart';
import '../controllers/budget_list_controller.dart';

class BudgetListView extends GetView<BudgetListController> {
  const BudgetListView({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.listData,
      child: Scaffold(
        appBar: BaseAppBar(
          titleText: "Budget App - List",
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                          ...budget.children.map((e) {
                            return ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    e.period == Constant.perHari
                                        ? Constant.hari[e.param - 1]
                                        : "Minggu ${e.param}",
                                  ),
                                  Text(GF.rupiahFormat(e.amount, symbol: "Rp")),
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
          ],
        ),
      ),
    );
  }
}
