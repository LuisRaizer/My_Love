import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/models/app_state.dart';

class AppController extends ChangeNotifier {
  final AppState _state = AppState();
  final ConfettiController confettiController = ConfettiController(duration: Duration(seconds: 2));

  AppState get state => _state;

  Future<void> initialize() async {
    await _checkSkipIntroPreference();
  }

  Future<void> _checkSkipIntroPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final shouldSkipIntro = prefs.getBool('skipIntro') ?? false;
      
      if (shouldSkipIntro) {
        _state.hideIntro();
      }
    } catch (e) {
      print('Erro ao verificar preferência de intro: $e');
    }
  }

  Future<void> _saveSkipIntroPreference(bool skipIntro) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('skipIntro', skipIntro);
    } catch (e) {
      print('Erro ao salvar preferência de intro: $e');
    }
  }

  void startApp({bool skipIntroNextTime = false}) async {
    if (skipIntroNextTime) {
      await _saveSkipIntroPreference(true);
    }
    
    _state.hideIntro();
    confettiController.play();
  }
  Future<void> resetIntroPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('skipIntro');
      _state.showIntro = true;
      notifyListeners();
    } catch (e) {
      print('Erro ao resetar preferência de intro: $e');
    }
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }
}