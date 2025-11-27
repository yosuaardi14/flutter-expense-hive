import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_expense_app/utils/global_functions.dart';
import 'package:flutter_expense_app/utils/library/feature_stub.dart';
import 'package:intl/intl.dart';

abstract class CsvUtil {
  static List<List<dynamic>> import(Uint8List bytes) {
    String csv = String.fromCharCodes(bytes);
    List<List<dynamic>> data = CsvToListConverter(
      fieldDelimiter: ";",
    ).convert(csv);
    return data;
  }

  static Future<void> export(List<List<dynamic>> data) async {
    String csv = const ListToCsvConverter(fieldDelimiter: ";").convert(data);
    String fileName =
        "EXPORT_${DateFormat("yyyy_MM_dd_hh_mm_ss").format(DateTime.now())}.csv";
    // Export to File
    try {
      if (kIsWeb) {
        // html Anchor
        AppFeature.anchorDownload(csv.codeUnits, fileName);
      } else {
        // PathProvider
        // await Permission.storage.request();
        File file = File("storage/emulated/0/Download/$fileName");
        await file.writeAsBytes(csv.codeUnits);
        // final Directory? downloadsDir = await getDownloadsDirectory();
        // print(downloadsDir);
        // if ((await downloadsDir?.exists()) ?? false) {
        //   File file = File("${downloadsDir!.path}/$fileName");
        //   await file.writeAsBytes(csv.codeUnits);
        // }
      }
      GF.showInformationDialog("Berhasil", "Silakan cek folder Download");
    } catch (e) {
      GF.showInformationDialog("Gagal", "Terjadi kesalahan ketika Export");
    }
  }
}
