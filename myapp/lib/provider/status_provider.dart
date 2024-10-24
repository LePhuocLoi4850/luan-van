import 'package:flutter/foundation.dart';

class StatusProvider extends ChangeNotifier {
  bool _status = false;

  bool get status => _status;

  void toggleStatus() {
    _status = !_status;
    notifyListeners();
  }
}
