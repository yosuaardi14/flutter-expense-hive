import 'package:get/get.dart';

abstract class BaseController extends GetxController {
  bool isLoading = false;

  void showLoading() {
    isLoading = true;
    update();
  }

  void hideLoading() {
    isLoading = false;
    update();
  }

  Future execute(Future Function() func, {bool withLoading = true}) async {
    try {
      if (withLoading) {
        showLoading();
      }
      await func();
    } catch (e) {
      //
    } finally {
      if (withLoading) {
        hideLoading();
      }
    }
  }
}
