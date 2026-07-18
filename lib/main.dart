import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expense_app/core/interfaces/crud_service.dart';
import 'package:flutter_expense_app/routes/app_pages.dart';
import 'package:flutter_expense_app/services/hive_budget_service.dart';
import 'package:flutter_expense_app/services/hive_database.dart';
import 'package:flutter_expense_app/services/hive_expense_service.dart';
import 'package:flutter_expense_app/services/sqlite_budget_service.dart';
import 'package:flutter_expense_app/services/sqlite_database.dart';
import 'package:flutter_expense_app/services/sqlite_expense_service.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const String storage = String.fromEnvironment("storage");
  if (kIsWeb || storage == "hive") {
    await Hive.initFlutter();
    await Get.putAsync(() => HiveDatabase().init());
    Get.put<ExpenseCrudService>(HiveExpenseService(), permanent: true);
    Get.put<BudgetCrudService>(HiveBudgetService(), permanent: true);
  } else {
    await Get.putAsync(() => SqliteDatabase().init());
    Get.put<ExpenseCrudService>(SqliteExpenseService(), permanent: true);
    Get.put<BudgetCrudService>(SqliteBudgetService(), permanent: true);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense App',
      theme: ThemeData(useMaterial3: false, primarySwatch: Colors.purple),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
