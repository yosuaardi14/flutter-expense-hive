import 'package:get/get.dart';

import '../controllers/budget_home_controller.dart';

class BudgetHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BudgetHomeController>(() => BudgetHomeController());
  }
}
