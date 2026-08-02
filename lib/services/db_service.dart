// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_expense_app/models/budget.dart';
import 'package:flutter_expense_app/models/expense.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBService {
  Database? db;
  final String dbName = 'expenseNew';
  final String tableExpense = 'expenseNew'; // expense
  final String columnId = 'id';
  final String columnTitle = 'title';
  final String columnAmount = 'amount';
  final String columnType = 'type';
  final String columnPayment = 'payment';
  final String columnDate = 'date';

  final String tableBudget = 'bugdet';
  // final String columnId = 'id';
  final String columnMonth = 'month';
  final String columnYear = 'year';
  // final String columnType = 'type';
  final String columnPeriod = 'period';
  // final String columnAmount = 'amount';
  final String columnParam = 'param';
  final String columnParentid = 'parentid';

  DBService._privateConstructor();
  static final DBService instance = DBService._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  dynamic _initDatabase() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, "$dbName.db");
    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    // version 1
    await db.execute('''CREATE TABLE $tableExpense ( 
  $columnId TEXT PRIMARY KEY, 
  $columnTitle TEXT NOT NULL,
  $columnAmount DOUBLE NOT NULL,
  $columnType TEXT NOT NULL,
  $columnPayment TEXT NOT NULL,
  $columnDate DATE NOT NULL)''');
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // you can execute drop table and create table
      // await db.execute("ALTER TABLE $tableExpense ADD COLUMN $columnType TEXT NULL;");
      // version 2
      await db.execute(
        "ALTER TABLE $tableExpense ADD COLUMN $columnPayment TEXT NULL;",
      );
    }
    if (oldVersion < 3) {
    // version 3
      await db.execute('''CREATE TABLE $tableBudget (
    $columnId TEXT PRIMARY KEY,
    $columnMonth INTEGER NOT NULL,
    $columnYear INTEGER NOT NULL,
    $columnType TEXT NOT NULL,
    $columnPeriod TEXT NOT NULL,
    $columnAmount DOUBLE NOT NULL,
    $columnParam INTEGER NOT NULL,
    $columnParentid TEXT NULL)''');
    }
  }

  Future<List<Expense>> fetchListData() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableExpense);
    return List.generate(maps.length, (i) => Expense.fromMap(maps[i]));
  }

  Future<Expense?> fetchData(String id) async {
    Database db = await instance.database;
    List<Map> maps = await db.query(
      tableExpense,
      columns: [
        columnId,
        columnTitle,
        columnAmount,
        columnType,
        columnPayment,
        columnDate,
      ],
      where: '$columnId = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Expense.fromMap(maps.first as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> insertData(Map<String, dynamic> expense) async {
    Database db = await instance.database;
    await db.insert(tableExpense, expense);
  }

  Future<int> updateData(String id, Map<String, dynamic> expense) async {
    Database db = await instance.database;
    return await db.update(
      tableExpense,
      expense,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteData(String id) async {
    Database db = await instance.database;
    return await db.delete(
      tableExpense,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllData() async {
    Database db = await instance.database;
    return await db.delete(tableExpense);
  }

  Future<List<Budget>> fetchListDataBudget() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableBudget);
    return List.generate(maps.length, (i) => Budget.fromMap(maps[i]));
  }

  Future<List<Budget>> fetchListDataBudgetByParentId(String parentid) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableBudget,
      where: '$columnParentid = ?',
      whereArgs: [parentid],
    );
    return List.generate(maps.length, (i) => Budget.fromMap(maps[i]));
  }

  Future<Budget?> fetchDataBudget(String id, {bool withChildren = false}) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      tableBudget,
      columns: [
        columnId,
        columnMonth,
        columnYear,
        columnType,
        columnPeriod,
        columnAmount,
        columnParam,
        columnParentid,
      ],
      where: '$columnId = ?',
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

  Future<void> insertDataBudget(Map<String, dynamic> budget) async {
    Database db = await instance.database;
    await db.insert(tableBudget, budget);
  }

  Future<int> updateDataBudget(String id, Map<String, dynamic> budget) async {
    Database db = await instance.database;
    return await db.update(
      tableBudget,
      budget,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteDataBudget(String id) async {
    Database db = await instance.database;
    return await db.delete(
      tableBudget,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllDataBudget() async {
    Database db = await instance.database;
    return await db.delete(tableBudget);
  }

  Future close() async {
    Database db = await instance.database;
    db.close();
  }
}
