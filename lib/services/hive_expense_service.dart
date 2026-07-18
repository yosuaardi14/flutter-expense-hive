import 'package:flutter_expense_app/core/interfaces/crud_service.dart';
import 'package:flutter_expense_app/models/expense.dart';
import 'package:flutter_expense_app/services/hive_database.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveExpenseService extends GetxService implements ExpenseCrudService {
  final HiveDatabase appDb = Get.find();

  final RxList<Expense> _master = <Expense>[].obs;

  Future<void> load() async {
    final db = appDb.expenseBox;

    _master.assignAll(
      db.values.map((e) {
        return Expense.fromMap(Map<String, dynamic>.from(e));
      }),
    );
  }

  @override
  Future<List<Expense>> fetchListData() async {
    if (_master.isEmpty) {
      await load();
    }

    return List.unmodifiable(_master);
  }

  @override
  Future<Expense?> fetchData(String id) async {
    Box db = appDb.expenseBox;
    Map<dynamic, dynamic>? maps = db.get(id);
    if (maps != null) {
      return Expense.fromMap(Map<String, dynamic>.from(maps));
    }
    return null;
  }

  @override
  Future<void> insertData(Map<String, dynamic> expense) async {
    Box db = appDb.expenseBox;
    await db.put(expense["id"], expense);
    _master.add(Expense.fromMap(expense));
  }

  @override
  Future<void> updateData(String id, Map<String, dynamic> expense) async {
    Box db = appDb.expenseBox;
    await db.put(id, expense);
    final index = _master.indexWhere((e) => e.id == id);
    if (index != -1) {
      _master[index] = Expense.fromMap(expense);
    }
  }

  @override
  Future<void> deleteData(String id) async {
    Box db = appDb.expenseBox;
    await db.delete(id);
    _master.removeWhere((e) => e.id == id);
  }

  @override
  Future<int> deleteAllData() async {
    Box db = appDb.expenseBox;
    int result = await db.clear();
    _master.clear();
    return result;
  }

  @override
  Future<List<Expense>> fetchListFilterData(
    bool? isExpense,
    String? type,
    List<String>? payment,
    DateTime? dateStart,
    DateTime? dateEnd,
  ) async {
    final expenses = await fetchListData();

    return expenses.where((e) {
      if (isExpense == true && e.type == "Pemasukan") return false;
      if (isExpense == false && e.type != "Pemasukan") return false;
      if (type != null && e.type != type) return false;
      if (payment != null && !payment.contains(e.payment)) return false;
      if (dateStart != null && e.date.isBefore(dateStart)) return false;
      if (dateEnd != null && !e.date.isBefore(dateEnd)) return false;
      // if (e.date.isBefore(dateStart) || e.date.isAfter(dateEnd)) return false;
      return true;
    }).toList();
  }

  @override
  Future<double> sumRange(
    bool? isExpense,
    DateTime? dateStart,
    DateTime? dateEnd,
  ) async {
    final expenses = await fetchListData();
    return expenses
        .where((e) {
          if (isExpense == true && e.type == "Pemasukan") return false;
          if (isExpense == false && e.type != "Pemasukan") return false;
          if (dateStart != null && e.date.isBefore(dateStart)) return false;
          if (dateEnd != null && !e.date.isBefore(dateEnd)) return false;
          // return (e.date.isBefore(dateStart) || e.date.isAfter(dateEnd));
          return true;
        })
        .toList()
        .fold<double>(0.0, (sum, item) => sum + item.amount);
  }
}
