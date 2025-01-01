import 'package:get/get.dart';

import '../controllers/expense_add_controller.dart';

class ExpenseAddBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExpenseAddController>(
      () => ExpenseAddController(),
    );
  }
}
