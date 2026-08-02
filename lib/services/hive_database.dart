import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase extends GetxService {
  final String tableExpense = 'expenseNew';
  final String tableBudget = 'budget';

  late Box expenseBox;
  late Box budgetBox;

  Future<HiveDatabase> init() async {
    expenseBox = await Hive.openBox(tableExpense);
    budgetBox = await Hive.openBox(tableBudget);
    return this;
  }

  Future close() async {
    expenseBox.close();
    budgetBox.close();
  }

  @override
  Future<void> onClose() async {
    await close();
    super.onClose();
  }
}
