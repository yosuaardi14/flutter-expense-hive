import 'dart:convert';

import 'package:web/web.dart' as web;

class AppFeature {
  static void anchorDownload(List<int> bytes, String fileName) {
    final base64Data = base64Encode(bytes);
    web.HTMLAnchorElement a = web.HTMLAnchorElement();
    a.href = 'data:application/octet-stream;base64,$base64Data';
    a.target = "_blank";
    a.download = fileName;
    a.click();
    a.remove();
  }
}
