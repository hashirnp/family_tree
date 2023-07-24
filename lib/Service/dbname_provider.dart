import 'package:flutter/foundation.dart';

class DbNameProvider extends ChangeNotifier {
  String? _argument;

  String get argument => _argument!;
  void setArgument(String value) {
    _argument = value;
    notifyListeners();
  }
}
