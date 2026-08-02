// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:flutter_expense_app/models/budget.dart';
import 'package:flutter_expense_app/models/expense.dart';
import 'package:hive/hive.dart';

class HiveService {
  Box? db;
  final String tableExpense = 'expenseNew';
  final String tableBudget = 'budget';

  HiveService._privateConstructor();
  static final HiveService instance = HiveService._privateConstructor();

  // only have a single app-wide reference to the database
  static Box? _database;
  Future<Box> get database async {
    if (_database != null) return _database!;
    return await Hive.openBox(tableExpense);
  }

  Future<List<Expense>> fetchListData() async {
    Box db = await instance.database;
    //await db.clear();
    List<Expense> maps = db.toMap().entries.map((e) {
      return Expense.fromMap(
        jsonDecode(jsonEncode(e.value)) as Map<String, dynamic>,
      );
    }).toList();
    return maps;
  }

  Future<Expense?> fetchData(String id) async {
    Box db = await instance.database;
    Map<dynamic, dynamic>? maps = db.get(id);
    if (maps != null) {
      return Expense.fromMap(Map<String, dynamic>.from(maps));
    }
    return null;
  }

  Future<void> insertData(Map<String, dynamic> expense) async {
    Box db = await instance.database;
    return await db.put(expense["id"], expense);
  }

  Future<void> updateData(String id, Map<String, dynamic> expense) async {
    Box db = await instance.database;
    return await db.put(id, expense);
  }

  Future<void> deleteData(String id) async {
    Box db = await instance.database;
    return await db.delete(id);
  }

  Future<int> deleteAllData() async {
    Box db = await instance.database;
    return await db.clear();
  }

  Future close() async {
    Box db = await instance.database;
    db.close();
  }

  // Budget
  static Box? _databaseBudget;
  Future<Box> get databaseBudget async {
    if (_databaseBudget != null) return _databaseBudget!;
    return await Hive.openBox(tableBudget);
  }

  Future<List<Budget>> fetchListDataBudget() async {
    Box db = await instance.databaseBudget;
    //await db.clear();
    List<Budget> maps = db.toMap().entries.map((e) {
      return Budget.fromMap(
        jsonDecode(jsonEncode(e.value)) as Map<String, dynamic>,
      );
    }).toList();
    return maps;
  }

  Future<List<Budget>> fetchListDataBudgetByParentId(String parentid) async {
    Box db = await instance.databaseBudget;
    //await db.clear();
    List<Budget> maps = db.toMap().entries.where((e) => e.value["parentid"] == parentid).map((e) {
      return Budget.fromMap(
        jsonDecode(jsonEncode(e.value)) as Map<String, dynamic>,
      );
    }).toList();
    return maps;
  }

  Future<Budget?> fetchDataBudget(String id, {bool withChildren = false}) async {
    Box db = await instance.databaseBudget;
    Map<dynamic, dynamic>? maps = db.get(id);
    if (maps != null) {
      if (withChildren) {
        maps["children"] = await fetchListDataBudgetByParentId(id);
      }
      return Budget.fromMap(Map<String, dynamic>.from(maps));
    }
    return null;
  }

  Future<void> insertDataBudget(Map<String, dynamic> budget) async {
    Box db = await instance.databaseBudget;
    return await db.put(budget["id"], budget);
  }

  Future<void> updateDataBudget(String id, Map<String, dynamic> budget) async {
    Box db = await instance.databaseBudget;
    return await db.put(id, budget);
  }

  Future<void> deleteDataBudget(String id) async {
    Box db = await instance.databaseBudget;
    return await db.delete(id);
  }

  Future<int> deleteAllDataBudget() async {
    Box db = await instance.databaseBudget;
    return await db.clear();
  }

  Future closeBudget() async {
    Box db = await instance.databaseBudget;
    db.close();
  }
}
