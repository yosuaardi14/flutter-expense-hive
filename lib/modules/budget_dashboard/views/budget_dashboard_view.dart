import 'package:flutter/material.dart';
import 'package:flutter_expense_app/models/budget.dart';
import 'package:flutter_expense_app/modules/base/widgets/base_drawer.dart';
// import 'package:flutter_expense_app/modules/base/widgets/day_widget.dart';
// import 'package:flutter_expense_app/modules/base/widgets/month_picker_dialog.dart';
import 'package:flutter_expense_app/modules/budget_dashboard/controllers/budget_dashboard_controller.dart';
import 'package:flutter_expense_app/utils/constant.dart';
import 'package:flutter_expense_app/utils/global_functions.dart';
import 'package:get/get.dart';

import '../../base/widgets/base_app_bar.dart';

class BudgetDashboardView extends GetView<BudgetDashboardController> {
  const BudgetDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => controller.listData(),
      child: Obx(() {
        int tabIdx = controller.tabIndex.value;
        return DefaultTabController(
          length: 2,
          initialIndex: tabIdx,
          child: Scaffold(
            appBar: BaseAppBar(
              titleText: "Budget App - Dashboard",
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
                TabBar(
                  labelColor: Colors.purple,
                  tabs: [
                    Tab(text: "Current".toUpperCase()),
                    Tab(text: "All".toUpperCase()),
                  ],
                  onTap: (value) {
                    controller.onChangeTab(value);
                  },
                ),
                Obx(() {
                  if (controller.tabIndex.value == 0) {
                    return const SizedBox();
                  }
                  // return Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 5,
                  //     // vertical: 5,
                  //   ),
                  //   child: ListTile(
                  //     isThreeLine: false,
                  //     onTap: () async {
                  //       final result = await Get.bottomSheet(
                  //         MonthPickerDialog(
                  //           month: controller.month.value,
                  //           year: controller.year.value,
                  //         ),
                  //       );
                  //       if (result != null) {
                  //         List<String> data = result.toString().split(",");
                  //         controller.month.value = data[0];
                  //         controller.year.value = data[1];
                  //         controller.update();
                  //         controller.onChangeTab(controller.tabIndex.value);
                  //       }
                  //     },
                  //     shape: BorderDirectional(
                  //       bottom: BorderSide(color: Colors.grey),
                  //     ),
                  //     contentPadding: EdgeInsets.symmetric(horizontal: 5),
                  //     dense: true,
                  //     title: Center(
                  //       child: Obx(
                  //         () => Text(
                  //           "${Constant.dropdownMonthOnly[controller.month.value]} ${controller.year.value}",
                  //           style: TextStyle(fontSize: 16),
                  //         ),
                  //       ),
                  //     ),
                  //     // trailing: Icon(
                  //     //   Icons.calendar_month,
                  //     //   color: Colors.purple,
                  //     // ),
                  //     leading: IconButton(
                  //       onPressed: () {
                  //         controller.navigateMonth(false);
                  //       },
                  //       icon: Icon(Icons.navigate_before, color: Colors.purple),
                  //     ),
                  //     trailing: IconButton(
                  //       onPressed: () {
                  //         controller.navigateMonth(true);
                  //       },
                  //       icon: Icon(Icons.navigate_next, color: Colors.purple),
                  //     ),
                  //   ),
                  // );
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 5,
                    ),
                    child: Row(
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
                              decoration: const InputDecoration(
                                labelText: 'Tahun',
                              ),
                              onChanged: (val) {
                                controller.year.value = val!;
                                controller.update();
                                controller.listData();
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
                              decoration: const InputDecoration(
                                labelText: 'Bulan',
                              ),
                              onChanged: (val) {
                                controller.month.value = val!;
                                controller.update();
                                controller.listData();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 5,
                  ),
                  child: Card(
                    child: Obx(
                      () => Column(
                        spacing: 10,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              "Total Budget - ${Constant.dropdownMonthOnly[controller.month.value]} ${controller.year.value}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          LinearProgressIndicator(
                            value: controller.percentageBudget.value,
                            minHeight: 10,
                            borderRadius: BorderRadius.circular(5),
                            color: (controller.percentageBudget.value) <= 0.5
                                ? Colors.green
                                : (controller.percentageBudget.value) <= 1.0
                                ? Colors.amber
                                : Colors.redAccent,
                            backgroundColor: Colors.purple.shade200,
                          ),
                          Text(
                            "${GF.rupiahFormat(controller.totalExpense.value, symbol: "Rp")} / ${GF.rupiahFormat(controller.totalBudget.value, symbol: "Rp")}",
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              "(Sisa: ${GF.rupiahFormat(controller.remainderBudget.value, symbol: "Rp")})",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => Card(
                      child: SegmentedButton(
                        style: ButtonStyle(),
                        segments: [
                          ButtonSegment(value: 0, label: Text("Daily")),
                          ButtonSegment(value: 1, label: Text("Weekly")),
                          ButtonSegment(value: 2, label: Text("Monthly")),
                        ],
                        selected: controller.periodIndex(),
                        onSelectionChanged: (val) {
                          controller.onChangePeriod(val);
                        },
                        multiSelectionEnabled: false,
                        showSelectedIcon: false,
                      ),
                    ),
                  ),
                ),
                Obx(() {
                  if (controller.tabIndex.value == 0) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 0,
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.purple, width: 1.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "${Constant.hari[int.parse(controller.weekday.value) - 1]}, ${controller.day.value} ${Constant.dropdownMonthOnly[controller.month.value]} ${controller.year.value} (Minggu ${controller.week.value})",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  }
                  if (controller.tabIndex.value == 1 &&
                      controller.currentListBudget.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 0,
                      ),
                      child: Column(
                        children: [
                          // DayWidget(
                          //   selectedDate: DateTime.parse(
                          //     "${controller.year.value}-${controller.month.value.padLeft(2, "0")}-01",
                          //   ),
                          //   weekIndex:
                          //       int.tryParse(controller.selectedWeek.value) ??
                          //       1,
                          // ),
                          if (controller.periodIndex.first == 0)
                            Row(
                              spacing: 3,
                              children: [
                                SizedBox(
                                  height: 47.5,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      controller.navigateDay(false);
                                    },
                                    label: Icon(Icons.navigate_before),
                                  ),
                                ),
                                // Expanded(
                                //   child: Obx(
                                //     () => DropdownButtonFormField<String>(
                                //       initialValue:
                                //           controller.selectedDay.value,
                                //       items: [
                                //         ...controller.listDay.map(
                                //           (e) => DropdownMenuItem<String>(
                                //             value: e.split(" - ").last,
                                //             child: Text(
                                //               "${e.replaceAll(" - ", ", ")} ${Constant.dropdownMonthOnly[controller.month.value]} ${controller.year.value}",
                                //             ),
                                //           ),
                                //         ),
                                //       ],
                                //       decoration: const InputDecoration(
                                //         // labelText: 'Hari',
                                //         border: OutlineInputBorder(),
                                //         contentPadding: EdgeInsets.symmetric(
                                //           horizontal: 5,
                                //         ),
                                //       ),
                                //       onChanged: (val) {
                                //         controller.selectedDay.value = val!;
                                //         controller.onChangeTab(
                                //           controller.tabIndex.value,
                                //         );
                                //         controller.update();
                                //       },
                                //     ),
                                //   ),
                                // ),
                                Expanded(
                                  child: TextFormField(
                                    controller: controller.dayController,
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime firstDate = DateTime.parse(
                                        "${controller.year.value}-${controller.month.value.padLeft(2, "0")}-01",
                                      );
                                      DateTime lastDate =
                                          DateTime(
                                            firstDate.year,
                                            firstDate.month + 1,
                                            1,
                                          ).subtract(
                                            const Duration(microseconds: 1),
                                          );
                                      if (DateTime.now().isBefore(firstDate)) {
                                        return;
                                      }
                                      final res = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.parse(
                                          "${controller.year.value}-${controller.month.value.padLeft(2, "0")}-${controller.selectedDay.value.padLeft(2, "0")}",
                                        ),
                                        firstDate: firstDate,
                                        lastDate: lastDate,
                                        currentDate: DateTime.now(),
                                        initialEntryMode:
                                            DatePickerEntryMode.calendarOnly,
                                      );
                                      if (res != null) {
                                        controller.selectedDay.value = res.day
                                            .toString();
                                        controller.update();
                                        controller.dayController.text =
                                            "${controller.selectedDay.value} ${Constant.dropdownMonthOnly[controller.month.value]} ${controller.year.value}";
                                        controller.listData();
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      // labelText: 'Hari',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 47.5,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      controller.navigateDay(true);
                                    },
                                    label: Icon(Icons.navigate_next),
                                  ),
                                ),
                              ],
                            ),
                          if (controller.periodIndex.first == 1)
                            Row(
                              spacing: 3,
                              children: [
                                SizedBox(
                                  height: 47.5,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      controller.navigateWeek(false);
                                    },
                                    label: Icon(Icons.navigate_before),
                                  ),
                                ),
                                Expanded(
                                  child: Obx(
                                    () => DropdownButtonFormField<String>(
                                      initialValue:
                                          controller.selectedWeek.value,
                                      items: [
                                        ...controller.listWeek.map(
                                          (e) => DropdownMenuItem<String>(
                                            value: e,
                                            child: Text(
                                              "${Constant.dropdownMonthOnly[controller.month.value]} ${controller.year.value} - Minggu $e",
                                            ),
                                          ),
                                        ),
                                      ],
                                      decoration: const InputDecoration(
                                        // labelText: 'Minggu',
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                      ),
                                      onChanged: (val) {
                                        controller.selectedWeek.value = val!;
                                        controller.update();
                                        controller.listData();
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 47.5,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      controller.navigateWeek(true);
                                    },
                                    label: Icon(Icons.navigate_next),
                                  ),
                                ),
                              ],
                            ),
                          // if (controller.periodIndex.first == 2)
                          //   Row(
                          //     spacing: 3,
                          //     children: [
                          //       SizedBox(
                          //         height: 47.5,
                          //         child: ElevatedButton.icon(
                          //           onPressed: () {
                          //             controller.navigateDateRange(false);
                          //           },
                          //           label: Icon(Icons.navigate_before),
                          //         ),
                          //       ),
                          //       Expanded(
                          //         child: TextFormField(
                          //           controller: controller.dateRangeController,
                          //           readOnly: true,
                          //           onTap: () async {
                          //             DateTime firstDate = DateTime.parse(
                          //               "${controller.year.value}-${controller.month.value.padLeft(2, "0")}-01",
                          //             );
                          //             DateTime lastDate =
                          //                 DateTime(
                          //                   firstDate.year,
                          //                   firstDate.month + 1,
                          //                   1,
                          //                 ).subtract(
                          //                   const Duration(microseconds: 1),
                          //                 );
                          //             if (DateTime.now().isBefore(firstDate)) {
                          //               return;
                          //             }
                          //             final res = await showDateRangePicker(
                          //               context: context,
                          //               initialDateRange: DateTimeRange(
                          //                 start: firstDate,
                          //                 end: DateTime.now().isBefore(lastDate)
                          //                     ? DateTime.now()
                          //                     : lastDate,
                          //               ),
                          //               firstDate: firstDate,
                          //               lastDate: lastDate,
                          //               currentDate: DateTime.now(),
                          //               initialEntryMode:
                          //                   DatePickerEntryMode.calendarOnly,
                          //               // selectableDayPredicate:(day, selectedStartDay, selectedEndDay) {

                          //               // },
                          //             );
                          //             if (res != null) {
                          //               controller.dateRange.value = res;
                          //               controller.update();
                          //               controller.dateRangeController.text =
                          //                   "${res.start.day} - ${res.end.day} ${Constant.dropdownMonthOnly[res.end.month.toString()]} ${res.end.year}";
                          //             }
                          //           },
                          //           decoration: const InputDecoration(
                          //             // labelText: 'Hari',
                          //             border: OutlineInputBorder(),
                          //             contentPadding: EdgeInsets.symmetric(
                          //               horizontal: 5,
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //       SizedBox(
                          //         height: 47.5,
                          //         child: ElevatedButton.icon(
                          //           onPressed: () {
                          //             controller.navigateDateRange(true);
                          //           },
                          //           label: Icon(Icons.navigate_next),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                }),
                Expanded(
                  child: Obx(
                    () => controller.currentListBudget.isEmpty
                        ? ListView(
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Data tidak ditemukan"),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: controller.currentListBudget().length,
                            itemBuilder: (context, index) {
                              Budget budget =
                                  controller.currentListBudget[index];
                              return SizedBox(
                                width: 150,
                                // height: 100,
                                child: Card(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    spacing: 10,
                                    children: [
                                      Text(
                                        "${budget.type} (${budget.period})",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "${GF.rupiahFormat(budget.totalExpense ?? 0, symbol: "Rp")} / ${GF.rupiahFormat(budget.amount, symbol: "Rp")}",
                                      ),
                                      Text(
                                        "(Sisa: ${GF.rupiahFormat(budget.remainder ?? 0, symbol: "Rp")})",
                                      ),
                                      LinearProgressIndicator(
                                        value: budget.percentage ?? 0.0,
                                        minHeight: 10,
                                        borderRadius: BorderRadius.circular(5),
                                        color: (budget.percentage ?? 0.0) <= 0.5
                                            ? Colors.green
                                            : (budget.percentage ?? 0.0) <= 1.0
                                            ? Colors.amber
                                            : Colors.redAccent,
                                        backgroundColor: Colors.purple.shade200,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
