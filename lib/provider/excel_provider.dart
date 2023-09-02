import 'package:flutter/foundation.dart';

class ExcelProvider with ChangeNotifier {
  bool _isLoad = false;
  bool get isLoad => _isLoad;

  void setLoadWidget(bool value) {
    _isLoad = value;
    notifyListeners();
  }
}
