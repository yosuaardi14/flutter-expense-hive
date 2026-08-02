import 'package:flutter_expense_app/core/interfaces/crud_service.dart';
import 'package:flutter_expense_app/models/budget.dart';
import 'package:flutter_expense_app/services/hive_database.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveBudgetService extends GetxService implements BudgetCrudService {
  final HiveDatabase appDb = Get.find();

  final RxList<Budget> _master = <Budget>[].obs;

  Future<void> load() async {
    final db = appDb.budgetBox;

    _master.assignAll(
      db.values.map((e) {
        return Budget.fromMap(Map<String, dynamic>.from(e));
      }),
    );
  }

  @override
  Future<List<Budget>> fetchListDataBudget({bool reload = false}) async {
    if (_master.isEmpty || reload) {
      await load();
    }

    return List.unmodifiable(_master);
  }

  @override
  Future<List<Budget>> fetchListDataBudgetByParentId(String parentid) async {
    final budgets = await fetchListDataBudget();
    return budgets.where((e) {
      return e.parentid == parentid;
    }).toList();
  }

  @override
  Future<Budget?> fetchDataBudget(
    String id, {
    bool withChildren = false,
  }) async {
    Box db = appDb.budgetBox;
    Map<dynamic, dynamic>? maps = db.get(id);
    if (maps != null) {
      if (withChildren) {
        maps["children"] = await fetchListDataBudgetByParentId(id);
      }
      return Budget.fromMap(Map<String, dynamic>.from(maps));
    }
    return null;
  }

  @override
  Future<void> insertDataBudget(Map<String, dynamic> budget) async {
    Box db = appDb.budgetBox;
    await db.put(budget["id"], budget);
    _master.add(Budget.fromMap(budget));
  }

  @override
  Future<void> updateDataBudget(String id, Map<String, dynamic> budget) async {
    Box db = appDb.budgetBox;
    await db.put(id, budget);
    final index = _master.indexWhere((e) => e.id == id);
    if (index != -1) {
      _master[index] = Budget.fromMap(budget);
    }
  }

  @override
  Future<void> deleteDataBudget(String id) async {
    Box db = appDb.budgetBox;
    await db.delete(id);
    _master.removeWhere((e) => e.id == id);
  }

  @override
  Future<int> deleteAllDataBudget() async {
    Box db = appDb.budgetBox;
    int result = await db.clear();
    _master.clear();
    return result;
  }

  @override
  Future<List<Budget>> fetchListFilterDataBudget(
    String? parentid,
    String? period,
    int? month,
    int? year, {
    bool withChildren = true,
  }) async {
    final budgets = await fetchListDataBudget();
    final filtered = budgets.where((e) {
      if (e.parentid != parentid) return false;
      if (period != null && e.period != period) return false;
      if (month != null && e.month != month) return false;
      if (year != null && e.year != year) return false;
      return true;
    }).toList();

    if (!withChildren) {
      return filtered;
    }

    return Future.wait(
      filtered.map((budget) async {
        budget.children = await fetchListDataBudgetByParentId(budget.id);
        return budget;
      }),
    );
  }
}
