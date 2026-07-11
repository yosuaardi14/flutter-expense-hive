import 'package:get/get.dart';

import '../../../models/budget.dart';
import '../../../models/expense.dart';
import '../../../services/hive_service.dart';
import 'base_controller.dart';
// import '../../../services/db_service.dart';

class ExpenseBaseController extends BaseController {
  HiveService dbService = HiveService.instance;
  // DBService dbService = DBService.instance;
  final listExpense = <Expense>[].obs;
  final listBudget = <Budget>[].obs;
  final expenseData = <String, dynamic>{}.obs;
}
