import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _showIntro = true;

  ThemeMode get themeMode => _themeMode;
  bool get showIntro => _showIntro;

  set showIntro(bool value) {
    _showIntro = value;
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void hideIntro() {
    _showIntro = false;
    notifyListeners();
  }
}