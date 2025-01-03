import 'package:get/get.dart';

import '../controllers/expense_calendar_controller.dart';

class ExpenseCalendarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExpenseCalendarController>(
      () => ExpenseCalendarController(),
    );
  }
}
