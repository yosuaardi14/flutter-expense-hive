import 'package:flutter_expense_app/core/interfaces/crud_service.dart';
import 'package:flutter_expense_app/models/expense.dart';
import 'package:flutter_expense_app/services/sqlite_database.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class SqliteExpenseService extends GetxService implements ExpenseCrudService {
  final appDb = Get.find<SqliteDatabase>();

  @override
  Future<List<Expense>> fetchListData({bool reload = false}) async {
    Database db = await appDb.database;
    final List<Map<String, dynamic>> maps = await db.query(appDb.tableExpense);
    return List.generate(maps.length, (i) => Expense.fromMap(maps[i]));
  }

  @override
  Future<Expense?> fetchData(String id) async {
    Database db = await appDb.database;
    List<Map> maps = await db.query(
      appDb.tableExpense,
      columns: [
        appDb.columnId,
        appDb.columnTitle,
        appDb.columnAmount,
        appDb.columnType,
        appDb.columnPayment,
        appDb.columnDate,
      ],
      where: '${appDb.columnId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Expense.fromMap(maps.first as Map<String, dynamic>);
    }
    return null;
  }

  @override
  Future<void> insertData(Map<String, dynamic> expense) async {
    Database db = await appDb.database;
    await db.insert(appDb.tableExpense, expense);
  }

  @override
  Future<void> updateData(String id, Map<String, dynamic> expense) async {
    Database db = await appDb.database;
    await db.update(
      appDb.tableExpense,
      expense,
      where: '${appDb.columnId} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> deleteData(String id) async {
    Database db = await appDb.database;
    return await db.delete(
      appDb.tableExpense,
      where: '${appDb.columnId} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> deleteAllData() async {
    Database db = await appDb.database;
    return await db.delete(appDb.tableExpense);
  }

  @override
  Future<List<Expense>> fetchListFilterData(
    bool? isExpense,
    String? type,
    List<String>? payment,
    DateTime? dateStart,
    DateTime? dateEnd,
  ) async {
    Database db = await appDb.database;
    final conditions = <String>[];
    final args = <Object?>[];

    if (isExpense == true) {
      conditions.add('${appDb.columnType} <> ?');
      args.add('Pemasukan');
    } else if (isExpense == false) {
      conditions.add('${appDb.columnType} = ?');
      args.add('Pemasukan');
    }

    if (type != null) {
      conditions.add('${appDb.columnType} = ?');
      args.add(type);
    }

    if (payment != null && payment.isNotEmpty) {
      final placeholders = List.filled(payment.length, '?').join(',');
      conditions.add('${appDb.columnPayment} IN ($placeholders)');
      args.addAll(payment);
    }

    if (dateStart != null) {
      conditions.add('${appDb.columnDate} >= ?');
      args.add(dateStart.toString());
    }

    if (dateEnd != null) {
      conditions.add('${appDb.columnDate} < ?');
      args.add(dateEnd.toString());
    }

    final maps = await db.query(
      appDb.tableExpense,
      where: conditions.isEmpty ? null : conditions.join(' AND '),
      whereArgs: args,
    );
    return List.generate(maps.length, (i) => Expense.fromMap(maps[i]));
  }

  @override
  Future<double> sumRange(
    bool isExpense,
    DateTime? dateStart,
    DateTime? dateEnd,
  ) async {
    final db = await appDb.database;

    final conditions = <String>[];
    final args = <Object?>[];

    if (isExpense) {
      conditions.add('${appDb.columnType} <> ?');
      args.add('Pemasukan');
    } else {
      conditions.add('${appDb.columnType} = ?');
      args.add('Pemasukan');
    }

    if (dateStart != null) {
      conditions.add('${appDb.columnDate} >= ?');
      args.add(dateStart.toString());
    }

    if (dateEnd != null) {
      conditions.add('${appDb.columnDate} < ?');
      args.add(dateEnd.toString());
    }

    final result = await db.rawQuery('''
    SELECT COALESCE(SUM(${appDb.columnAmount}), 0) AS total
    FROM ${appDb.tableExpense}
    ${conditions.isEmpty ? '' : 'WHERE ${conditions.join(' AND ')}'}
    ''', args);

    return (result.first['total'] as num).toDouble();
  }
}
