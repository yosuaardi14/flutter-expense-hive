import 'package:flutter/material.dart';
import 'package:flutter_expense_app/utils/constant.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class GF {
  static void showInformationDialog(String title, String content) async {
    return await showDialog(
      barrierDismissible: false,
      context: Get.context!,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(Get.context!);
            },
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }

  static Future<bool> showConfirmationDialog(
    String title,
    String content,
  ) async {
    return await showDialog(
      barrierDismissible: false,
      context: Get.context!,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(Get.context!, false);
            },
            child: const Text("Tidak"),
          ),
          const SizedBox(width: 20),
          TextButton(
            onPressed: () {
              Navigator.pop(Get.context!, true);
            },
            child: const Text("Ya"),
          ),
        ],
      ),
    );
  }

  static Future<bool> showConfirmationDeleteDialog({
    String? title,
    String? message,
  }) async {
    return await showConfirmationDialog(
      title ?? "Konfirmasi Hapus",
      message ?? "Apa Anda yakin ingin menghapus ini?",
    );
  }

  static Future<bool> showConfirmationAddDialog({
    String? title,
    String? message,
    bool isEdit = false,
  }) async {
    return await showConfirmationDialog(
      title ?? "Konfirmasi ${isEdit ? "Ubah" : "Tambah"}",
      message ??
          "Apa Anda yakin ingin ${isEdit ? "mengubah" : "menambah"} ini?",
    );
  }

  static DateTime stringToDateTime(String date) {
    String day = date.split("-")[0];
    String month = date.split("-")[1];
    String year = date.split("-")[2];
    return DateTime.parse("$year-$month-$day");
  }

  static String rupiahFormat(double amount, {String symbol = ""}) {
    return NumberFormat.currency(
      locale: "id",
      decimalDigits: 0,
      symbol: symbol,
    ).format(amount);
  }

  static String rupiahFormatPostfix(double amount) {
    String postfix = "";
    bool isInt = false;
    if (amount > 999999999999) {
      // formatted = (amount / 1000000000).toStringAsFixed(1)+"m";
      postfix = "t";
      isInt = amount % 1000000000000 == 0;
      amount /= 1000000000000;
    } else if (amount > 999999999) {
      // formatted = (amount / 1000000000).toStringAsFixed(1)+"m";
      postfix = "m";
      isInt = amount % 1000000000 == 0;
      amount /= 1000000000;
    } else if (amount > 999999) {
      // formatted = (amount / 1000000).toStringAsFixed(1)+"jt";
      postfix = "jt";
      isInt = amount % 1000000 == 0;
      amount /= 1000000;
    } else if (amount > 999) {
      // formatted = (amount / 1000).toStringAsFixed(1)+"rb";
      postfix = "rb";
      isInt = amount % 1000 == 0;
      amount /= 1000;
    }
    String formatted = NumberFormat.currency(
      locale: "id",
      decimalDigits: isInt ? 0 : 1,
      symbol: "",
    ).format(amount);
    if (amount == 0) {
      return "-";
    }
    return formatted + postfix;
  }

  static String dateFormatString(DateTime date, {bool showWeekday = false}) {
    String dateOnlyString =
        "${date.day} ${Constant.dropdownMonth[date.month.toString()]} ${date.year}";
    if (showWeekday) {
      dateOnlyString = "${Constant.hari[date.weekday - 1]}, $dateOnlyString";
    }
    return dateOnlyString;
  }
}
