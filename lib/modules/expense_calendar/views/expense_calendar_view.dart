import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constant.dart';
import '../../../utils/global_functions.dart';
import '../../base/widgets/base_app_bar.dart';
import '../../base/widgets/base_drawer.dart';
import '../../base/widgets/mode_type_filter.dart';
import '../../base/widgets/payment_filter.dart';
import '../../base/widgets/year_month_filter.dart';
import '../controllers/expense_calendar_controller.dart';

class ExpenseCalendarView extends GetView<ExpenseCalendarController> {
  const ExpenseCalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        postFixtitleText: " - Calendar",
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
      body: RefreshIndicator(
        onRefresh: () async => controller.listData(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Obx(() {
                    final modeValue = controller.mode.value;
                    final typeValue = controller.type.value;
                    bool showTypeFilter = modeValue == "Outcome";
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
              final totalMonth = controller.totalSpendMap()["Bulan ini"];
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
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ...Constant.hari.map(
                    (e) => Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            strokeAlign: BorderSide.strokeAlignOutside,
                          ),
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
              child: Builder(
                builder: (context) {
                  final size = MediaQuery.sizeOf(context);
                  return Obx(() {
                    final startWeekDay = controller.startWeekDay.value;
                    final daysInMonth = controller.daysInMonth.value;
                    final sisaWeekDay = controller.sisaWeekDay.value;
                    return GridView.extent(
                      maxCrossAxisExtent: size.width / 7,
                      childAspectRatio:
                          (size.width / 7) / min(size.width / 7, 75),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1,
                      ),
                      children: [
                        ...List.generate(
                          startWeekDay,
                          (index) => Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                strokeAlign: BorderSide.strokeAlignOutside,
                              ),
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ...List.generate(daysInMonth, (index) {
                          double totalSpend = controller.totalSpendByDay(
                            index + 1,
                          );
                          return InkWell(
                            onTap: totalSpend == 0
                                ? null
                                : () {
                                    controller.showDetail(index + 1);
                                  },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                ),
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
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  FittedBox(
                                    child: Text(
                                      GF.rupiahFormatPostfix(totalSpend),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                        if (sisaWeekDay != 0)
                          ...List.generate(
                            7 - sisaWeekDay,
                            (index) => Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                ),
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
