import 'package:flutter/material.dart';

class BottomNavBarProvider with ChangeNotifier {
  int _currentIndex;

  int get currentIndex => _currentIndex;

  BottomNavBarProvider() {
    setIndex();
  }

  setIndex({int index}) {
    if (index != null) {
      _currentIndex = index;
      notifyListeners();
      return _currentIndex;
    } else {
      _currentIndex = 0;
      return _currentIndex;
    }
  }
}
