// // ignore_for_file: depend_on_referenced_packages

// import 'package:flutter_expense_app/models/expense.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DBService {
//   // var databasePath = join(await getDatabasesPath(), 'doggie_database.db'),;
//   Database? db;
//   final String tableExpense = 'expense';
//   final String columnId = 'id';
//   final String columnTitle = 'title';
//   final String columnAmount = 'amount';
//   final String columnType = 'type';
//   final String columnPayment = 'payment';
//   final String columnDate = 'date';

//   DBService._privateConstructor();
//   static final DBService instance = DBService._privateConstructor();

//   // only have a single app-wide reference to the database
//   static Database? _database;
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     // lazily instantiate the db the first time it is accessed
//     _database = await _initDatabase();
//     return _database!;
//   }

//   // this opens the database (and creates it if it doesn't exist)
//   _initDatabase() async {
//     var dbPath = await getDatabasesPath();
//     String path = join(dbPath, "$tableExpense.db");
//     return await openDatabase(path, version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
//   }

//   // SQL code to create the database table
//   Future _onCreate(Database db, int version) async {
//     await db.execute(
//         '''CREATE TABLE $tableExpense ( 
//   $columnId TEXT PRIMARY KEY, 
//   $columnTitle TEXT NOT NULL,
//   $columnAmount DOUBLE NOT NULL,
//   $columnType TEXT NOT NULL,
//   $columnPayment TEXT NOT NULL,
//   $columnDate DATE NOT NULL)''');
//   }

//   void _onUpgrade(Database db, int oldVersion, int newVersion) async{
//     if (oldVersion < newVersion) {
//       // you can execute drop table and create table
//       await db.execute("ALTER TABLE $tableExpense ADD COLUMN $columnType TEXT NULL;");
//       await db.execute("ALTER TABLE $tableExpense ADD COLUMN $columnPayment TEXT NULL;");
//     }
//   }

//   Future<List<Expense>> fetchListData() async {
//     Database db = await instance.database;
//     final List<Map<String, dynamic>> maps = await db.query(tableExpense);
//     return List.generate(maps.length, (i) => Expense.fromMap(maps[i]));
//   }

//   Future<Expense?> fetchData(String id) async {
//     Database db = await instance.database;
//     List<Map> maps = await db.query(tableExpense,
//         columns: [
//           columnId,
//           columnTitle,
//           columnAmount,
//           columnType,
//           columnPayment,
//           columnDate
//         ],
//         where: '$columnId = ?',
//         whereArgs: [id]);
//     if (maps.isNotEmpty) {
//       return Expense.fromMap(maps.first as Map<String, dynamic>);
//     }
//     return null;
//   }

//   Future<void> insertData(Map<String, dynamic> expense) async {
//     Database db = await instance.database;
//     await db.insert(tableExpense, expense);
//   }

//   Future<int> updateData(String id, Map<String, dynamic> expense) async {
//     Database db = await instance.database;
//     return await db.update(tableExpense, expense,
//         where: '$columnId = ?', whereArgs: [id]);
//   }

//   Future<int> deleteData(String id) async {
//     Database db = await instance.database;
//     return await db
//         .delete(tableExpense, where: '$columnId = ?', whereArgs: [id]);
//   }

//   Future close() async {
//     Database db = await instance.database;
//     db.close();
//   }
// }
// 