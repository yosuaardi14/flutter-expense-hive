import 'package:get/get.dart';

import '../controllers/budget_list_controller.dart';

class BudgetListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BudgetListController>(() => BudgetListController());
  }
}
