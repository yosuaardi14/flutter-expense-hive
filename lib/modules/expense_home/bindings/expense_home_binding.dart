import 'package:get/get.dart';

import '../controllers/expense_home_controller.dart';

class ExpenseHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExpenseHomeController>(() => ExpenseHomeController());
  }
}
