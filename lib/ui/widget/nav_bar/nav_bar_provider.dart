import 'package:flutter/cupertino.dart';

class NavBarProvider extends ChangeNotifier{
  int _index = 0;

  int get index => _index;

  void setIndex(int newInd) {
    if (newInd == _index) return;
    _index = newInd;
    notifyListeners();
  }
}