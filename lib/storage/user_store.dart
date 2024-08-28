import 'package:flutter/foundation.dart';

class UserStore with ChangeNotifier {
  int _userId = 0;
  int _unreadCnt = 0;
  int get userId => _userId;
  int get unreadCnt => _unreadCnt;

  void setUserId(int id) {
    _userId = id;
    notifyListeners();
  }

  void setUnreadCnt(int unreadCnt){
    _unreadCnt = unreadCnt;
    notifyListeners();
  }
}