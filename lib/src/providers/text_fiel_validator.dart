import 'package:flutter/cupertino.dart';

class TextFielValidator with ChangeNotifier {
  bool _isActive = false;

  bool get isActive => _isActive;
  set isActive(bool status) {
    _isActive = status;
    notifyListeners();
  }
}
