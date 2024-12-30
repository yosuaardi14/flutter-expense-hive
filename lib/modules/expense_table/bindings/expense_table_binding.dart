import 'package:get/get.dart';

import '../controllers/expense_table_controller.dart';

class ExpenseTableBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExpenseTableController>(
      () => ExpenseTableController(),
    );
  }
}
