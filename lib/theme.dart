import 'package:flutter/material.dart';

class MyTheme extends ChangeNotifier {
  static  bool _isDark = true;

  ThemeMode currentTheme(){
    return _isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void switchTheme(){
    _isDark = !_isDark;
    notifyListeners();
  }
}

class NewTheme extends ValueNotifier {
  NewTheme(value) : super(ThemeMode.dark);

  void switchTheme(){

  }
}