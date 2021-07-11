import 'package:flutter/material.dart';

class BaseModel extends ChangeNotifier {
  bool _busy = false;
  bool _loading = false;

  bool get busy => _busy;
  bool get loading => _loading;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
