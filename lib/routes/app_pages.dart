// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';

import '../modules/expense_add/bindings/expense_add_binding.dart';
import '../modules/expense_add/views/expense_add_view.dart';
import '../modules/expense_calendar/bindings/expense_calendar_binding.dart';
import '../modules/expense_calendar/views/expense_calendar_view.dart';
import '../modules/expense_detail/bindings/expense_detail_binding.dart';
import '../modules/expense_detail/views/expense_detail_view.dart';
import '../modules/expense_list/bindings/expense_list_binding.dart';
import '../modules/expense_list/views/expense_list_view.dart';
import '../modules/expense_table/bindings/expense_table_binding.dart';
import '../modules/expense_table/views/expense_table_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = "/";

  static final routes = [
    GetPage(
      name: "/",
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.EXPENSE_LIST,
      page: () => const ExpenseListView(),
      binding: ExpenseListBinding(),
    ),
    GetPage(
      name: _Paths.EXPENSE_ADD,
      page: () => const ExpenseAddView(),
      binding: ExpenseAddBinding(),
    ),
    GetPage(
      name: _Paths.EXPENSE_DETAIL,
      page: () => const ExpenseDetailView(),
      binding: ExpenseDetailBinding(),
    ),
    GetPage(
      name: _Paths.EXPENSE_CALENDAR,
      page: () => const ExpenseCalendarView(),
      binding: ExpenseCalendarBinding(),
    ),
    GetPage(
      name: _Paths.EXPENSE_TABLE,
      page: () => const ExpenseTableView(),
      binding: ExpenseTableBinding(),
    ),
  ];
}
