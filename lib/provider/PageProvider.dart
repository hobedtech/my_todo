import 'package:flutter/material.dart';

class ItemStateProvider with ChangeNotifier {
  bool _isDeletedPage;

  bool get isDeletedPage => _isDeletedPage;

  ItemStateProvider() {
    desicion();
  }

  desicion({bool a}) {
    if (a == null) {
      _isDeletedPage = false;
      notifyListeners();
    } else {
      if (a == true) {
        _isDeletedPage = true;
        notifyListeners();
      } else {
        _isDeletedPage = false;
        notifyListeners();
      }
    }
    return _isDeletedPage;
  }
}
