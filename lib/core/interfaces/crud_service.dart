import 'package:flutter_expense_app/models/budget.dart';
import 'package:flutter_expense_app/models/expense.dart';

abstract class ExpenseCrudService {
  Future<List<Expense>> fetchListData();
  Future<List<Expense>> fetchListFilterData(
    bool? isExpense,
    String? type,
    List<String>? payment,
    DateTime? dateStart,
    DateTime? dateEnd,
  );
  Future<double> sumRange(bool isExpense, DateTime? dateStart, DateTime? dateEnd);
  Future<Expense?> fetchData(String id);
  Future<void> insertData(Map<String, dynamic> expense);
  Future<void> updateData(String id, Map<String, dynamic> expense);
  Future<void> deleteData(String id);
  Future<int> deleteAllData();
}

abstract class BudgetCrudService {
  Future<List<Budget>> fetchListDataBudget();
  // Future<List<Budget>> fetchListFilterDataBudget(
  //   String? period,
  //   DateTime dateStart,
  //   DateTime dateEnd,
  // );
  // Future<double> sumRange(DateTime dateStart, DateTime dateEnd);
  Future<List<Budget>> fetchListDataBudgetByParentId(String parentid);
  Future<Budget?> fetchDataBudget(String id, {bool withChildren = false});
  Future<void> insertDataBudget(Map<String, dynamic> budget);
  Future<void> updateDataBudget(String id, Map<String, dynamic> budget);
  Future<void> deleteDataBudget(String id);
  Future<int> deleteAllDataBudget();
}
