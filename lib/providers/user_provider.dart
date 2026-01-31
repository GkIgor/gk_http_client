import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _name = '';

  String get name => _name;

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void clear() {
    _name = '';
    notifyListeners();
  }

  void loadUser() {
    _name = 'Igor';
    notifyListeners();
  }
}
