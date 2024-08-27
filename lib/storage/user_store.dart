import 'package:flutter/foundation.dart';

class UserStore with ChangeNotifier {
  int _userId = 0;

  int get userId => _userId;

  void setUserId(int id) {
    _userId = id;
    notifyListeners();
  }
}