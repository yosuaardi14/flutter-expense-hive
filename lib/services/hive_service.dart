// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:flutter_expense_app/models/expense.dart';
import 'package:hive/hive.dart';

class HiveService {
  Box? db;
  final String tableExpense = 'expenseNew';

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
    List<Expense> maps = db
        .toMap()
        .entries
        .map((e) => Expense.fromMap(
            jsonDecode(jsonEncode(e.value)) as Map<String, dynamic>))
        .toList();
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

  Future close() async {
    Box db = await instance.database;
    db.close();
  }
}
