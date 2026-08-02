import 'package:flutter_expense_app/core/interfaces/crud_service.dart';
import 'package:flutter_expense_app/models/budget.dart';
import 'package:flutter_expense_app/services/sqlite_database.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class SqliteBudgetService extends GetxService implements BudgetCrudService {
  final appDb = Get.find<SqliteDatabase>();

  @override
  Future<List<Budget>> fetchListDataBudget({bool reload = false}) async {
    Database db = await appDb.database;
    final List<Map<String, dynamic>> maps = await db.query(appDb.tableBudget);
    return List.generate(maps.length, (i) => Budget.fromMap(maps[i]));
  }

  @override
  Future<List<Budget>> fetchListDataBudgetByParentId(String parentid) async {
    Database db = await appDb.database;
    final List<Map<String, dynamic>> maps = await db.query(
      appDb.tableBudget,
      where: '${appDb.columnParentid} = ?',
      whereArgs: [parentid],
    );
    return List.generate(maps.length, (i) => Budget.fromMap(maps[i]));
  }

  @override
  Future<Budget?> fetchDataBudget(
    String id, {
    bool withChildren = false,
  }) async {
    Database db = await appDb.database;
    List<Map<String, dynamic>> maps = await db.query(
      appDb.tableBudget,
      columns: [
        appDb.columnId,
        appDb.columnMonth,
        appDb.columnYear,
        appDb.columnType,
        appDb.columnPeriod,
        appDb.columnAmount,
        appDb.columnParam,
        appDb.columnParentid,
      ],
      where: '${appDb.columnId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      Map<String, dynamic> data = Map<String, dynamic>.from(maps.first);
      if (withChildren) {
        data["children"] = await fetchListDataBudgetByParentId(id);
      }
      return Budget.fromMap(data);
    }
    return null;
  }

  @override
  Future<void> insertDataBudget(Map<String, dynamic> budget) async {
    Database db = await appDb.database;
    await db.insert(appDb.tableBudget, budget);
  }

  @override
  Future<int> updateDataBudget(String id, Map<String, dynamic> budget) async {
    Database db = await appDb.database;
    return await db.update(
      appDb.tableBudget,
      budget,
      where: '${appDb.columnId} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> deleteDataBudget(String id) async {
    Database db = await appDb.database;
    return await db.delete(
      appDb.tableBudget,
      where: '${appDb.columnId} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> deleteAllDataBudget() async {
    Database db = await appDb.database;
    return await db.delete(appDb.tableBudget);
  }

  @override
  Future<List<Budget>> fetchListFilterDataBudget(
    String? parentid,
    String? period,
    int? month,
    int? year, {
    bool withChildren = true,
  }) async {
    Database db = await appDb.database;
    String where = '';
    List<Object?> whereArgs = [];

    if (parentid == null) {
      where = '${appDb.columnParentid} IS NULL';
    } else {
      where = '${appDb.columnParentid} = ?';
      whereArgs.add(parentid);
    }

    if (period != null) {
      where = '$where AND ${appDb.columnPeriod} = ? ';
      whereArgs.add(period);
    }

    if (month != null) {
      where = '$where AND ${appDb.columnMonth} = ? ';
      whereArgs.add(month);
    }

    if (year != null) {
      where = '$where AND ${appDb.columnYear} = ? ';
      whereArgs.add(year);
    }

    final List<Map<String, dynamic>> maps = await db.query(
      appDb.tableBudget,
      where: where,
      whereArgs: whereArgs,
    );

    final List<Budget> filtered = List.generate(
      maps.length,
      (i) => Budget.fromMap(maps[i]),
    );
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
