import 'package:flutter/material.dart';

abstract class BaseController<T extends StatefulWidget> extends State<T> {
  ValueNotifier<bool> isLoading = ValueNotifier(false);
}
