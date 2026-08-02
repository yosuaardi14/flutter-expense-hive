import 'package:get/get.dart';

import '../controllers/budget_add_controller.dart';

class BudgetAddBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BudgetAddController>(() => BudgetAddController());
  }
}
