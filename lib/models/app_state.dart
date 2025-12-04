import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _isMusicPlaying = false;
  bool _showIntro = true;
  int _loveCount = 1215;
  bool _giftOpened = false;

  ThemeMode get themeMode => _themeMode;
  bool get isMusicPlaying => _isMusicPlaying;
  bool get showIntro => _showIntro;
  int get loveCount => _loveCount;
  bool get giftOpened => _giftOpened;

  set showIntro(bool value) {
    _showIntro = value;
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void toggleMusic() {
    _isMusicPlaying = !_isMusicPlaying;
    notifyListeners();
  }

  void hideIntro() {
    _showIntro = false;
    notifyListeners();
  }

  void incrementLove() {
    _loveCount++;
    notifyListeners();
  }

  void openGift() {
    _giftOpened = true;
    notifyListeners();
  }
}