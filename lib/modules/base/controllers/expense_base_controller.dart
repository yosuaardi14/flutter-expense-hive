import 'package:flutter_expense_app/modules/base/controllers/base_controller.dart';
import 'package:get/get.dart';

import '../../../models/expense.dart';
import '../../../services/hive_service.dart';
// import '../../../services/db_service.dart';

class ExpenseBaseController extends BaseController {
  HiveService dbService = HiveService.instance;
  // DBService dbService = DBService.instance;
  final listExpense = <Expense>[].obs;
  final expenseData = <String, dynamic>{}.obs;
}
