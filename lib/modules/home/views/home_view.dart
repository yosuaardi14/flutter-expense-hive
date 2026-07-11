import 'package:flutter/material.dart';
import 'package:flutter_expense_app/modules/base/widgets/base_app_bar.dart';
import 'package:flutter_expense_app/modules/base/widgets/base_drawer.dart';
import 'package:flutter_expense_app/modules/home/controllers/home_controller.dart';
import 'package:flutter_expense_app/utils/global_functions.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(titleText: "Home"),
      drawer: BaseDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                GF.dateFormatString(DateTime.now(), showWeekday: true),
              ),
            ),
            // Text("Dashboard", style: TextStyle(fontWeight: FontWeight.bold)),
            Obx(
              () => Row(
                children: [
                  ...controller.total.entries.map((e) {
                    return Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(10),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            shape: BoxShape.rectangle,
                          ),
                          height: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(e.key),
                              switch (e.key) {
                                "Income" => Icon(Icons.arrow_downward),
                                "Expense" => Icon(Icons.arrow_upward),
                                _ => Icon(Icons.account_balance_wallet),
                              },
                              Text(GF.rupiahFormat(e.value, symbol: "Rp")),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            // Text("Menu", style: TextStyle(fontWeight: FontWeight.bold)),
            // Row(
            //   spacing: 5,
            //   children: [
            //     ...controller.menuList.entries.map((e) {
            //       return Expanded(
            //         child: InkWell(
            //           onTap: () {
            //             Get.offNamed(e.value);
            //           },
            //           child: Card(
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadiusGeometry.circular(10),
            //             ),
            //             child: Container(
            //               decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(10),
            //                 shape: BoxShape.rectangle,
            //               ),
            //               height: 100,
            //               child: Column(
            //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
            //                 children: [
            //                   Icon(
            //                     e.key == "Expense"
            //                         ? Icons.attach_money
            //                         : e.key == "Budget"
            //                         ? Icons.account_balance_wallet
            //                         : Icons.settings,
            //                     size: 48,
            //                     color: Colors.purple,
            //                   ),
            //                   Text(e.key),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ),
            //       );
            //     }),
            //   ],
            // ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey.shade700,
        showUnselectedLabels: true,
        // showSelectedLabels: false,
        onTap: (value) {
          if (value > 0) {
            Get.offNamed(controller.menuList[value - 1]);
          }
        },
        iconSize: 24,
        items: [
          BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
          BottomNavigationBarItem(
            label: "Expense",
            icon: Icon(Icons.attach_money),
          ),
          BottomNavigationBarItem(
            label: "Budget",
            icon: Icon(Icons.account_balance_wallet),
          ),
          BottomNavigationBarItem(label: "Setting", icon: Icon(Icons.settings)),
        ],
      ),
    );
  }
}
