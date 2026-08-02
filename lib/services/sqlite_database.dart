// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteDatabase extends GetxService {
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

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();

    return openDatabase(
      join(dbPath, "$dbName.db"),
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    // version 1,2
    await db.execute('''CREATE TABLE $tableExpense ( 
    $columnId TEXT PRIMARY KEY, 
    $columnTitle TEXT NOT NULL,
    $columnAmount DOUBLE NOT NULL,
    $columnType TEXT NOT NULL,
    $columnPayment TEXT NOT NULL,
    $columnDate DATE NOT NULL)''');

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

  Future<SqliteDatabase> init() async {
    await database;
    return this;
  }

  Future close() async {
    await _database?.close();
  }

  @override
  Future<void> onClose() async {
    await close();
    super.onClose();
  }
}
