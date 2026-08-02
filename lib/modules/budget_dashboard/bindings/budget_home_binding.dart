import 'package:get/get.dart';

import '../controllers/budget_dashboard_controller.dart';

class BudgetDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BudgetDashboardController>(() => BudgetDashboardController());
  }
}
